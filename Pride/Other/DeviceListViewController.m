//
//  DeviceListViewController.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "DeviceListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "define.h"
#import "DeviceViewController.h"
#import "DeviceCell.h"
#import "MBProgressHUD.h"


@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate, CBPeripheralDelegate>

@property(nonatomic,strong)CBCentralManager *mgr;

@property(nonatomic,strong)CBPeripheral *currentDevice;

@property(nonatomic,strong)UITableView *deviceListTableView;

@property(nonatomic,strong)UILabel *tintLabel;

@property(nonatomic,strong)NSMutableArray *devices;

@property(nonatomic,strong)NSMutableArray *deviceNames;

@property(nonatomic,strong)MBProgressHUD *progressHUD;

@property(nonatomic,strong)UIImageView *selectedChairImageView;

@property(nonatomic,strong)NSTimer * timer;

@end

@implementation DeviceListViewController
{
    NSIndexPath *markedIndexPath;
    NSString *currentDeviceName;
}

#pragma mark --  init
- (instancetype)initWithLanguage:(iCLanguage)language
{
    self = [super init];
    if (self) {
        _language = language;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLanguage) name:@"languageUpdate"
                                                   object:nil];
    }
    return self;
}

#pragma mark --  lifecycle

- (void)updateLanguage {
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    _language = language;
    [self startService];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(clearAndReloadList) userInfo:nil repeats:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    _language = language;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    [self startService];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(clearAndReloadList) userInfo:nil repeats:YES];
    NSLog(@"==========d=d============");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --  lazy load
-(NSMutableArray *)deviceNames
{
    if(!_deviceNames){
        self.deviceNames =[NSMutableArray arrayWithArray:@[@"BlueNRG1",@"doer-01",@"doer-02",@"doer-03", @"doer-04", @"doer-05", @"doer-06", @"doer-07"]];
    }
    return _deviceNames;
}



#pragma mark --  private


-(void)disconnectCurrentDevice{
    NSLog(@"disconnectCurrentDevice");
    [self.mgr cancelPeripheralConnection:self.currentDevice];
}


-(void)startService{
    //init
    self.devices = [NSMutableArray array];
    _mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
}


-(void)setUpUI
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:imageView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text =@"CNDOER";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.selectedChairImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 74, SCREEN_WIDTH - 150, SCREEN_WIDTH - 150)];
//    self.selectedChairImageView.image = [UIImage imageNamed:@"chair"];
    [self.view addSubview:self.selectedChairImageView];
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 45, 55, 55)];
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    
    self.deviceListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT *0.5, SCREEN_WIDTH, SCREEN_HEIGHT *0.5 - 77.5) style:UITableViewStylePlain];
    self.deviceListTableView.delegate = self;
    self.deviceListTableView.dataSource = self;
    [self.deviceListTableView setTableFooterView:[[UIView alloc]init]];
    self.deviceListTableView.backgroundColor = [UIColor clearColor];
    self.deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self tableView:self.deviceListTableView didSelectRowAtIndexPath:path];
    [self.view addSubview:self.deviceListTableView];
    
    self.tintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.75 - 38.5 -10, SCREEN_WIDTH, 20)];
    self.tintLabel.textAlignment = NSTextAlignmentCenter;
    self.tintLabel.textColor = CELL_TEXT_COLOR;
    self.tintLabel.text = _language == 0? @"暂未发现设备!请刷新":@"refresh again";
    [self.view addSubview:self.tintLabel];
    self.tintLabel.hidden = YES;
    
}


-(void)clearAndReloadList{
    [self.devices removeAllObjects];
    _mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
}


-(void)showAlert:(NSString *)message needButton:(BOOL)showBtn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_language == 0?@"蓝牙连接失败":@"Bluetooth connection failure" message:message preferredStyle:UIAlertControllerStyleAlert];
    if (showBtn) {
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:_language == 0?@"确定":@"yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)unmarkCell:(NSIndexPath *)indexPath{
    DeviceCell *cell = [self.deviceListTableView cellForRowAtIndexPath:indexPath];
    cell.bgImgView.image = [UIImage imageNamed:@"UnSelecBG"];
    cell.label.textColor = CELL_TEXT_COLOR;
    cell.isMarked = NO;
}


-(NSString *)changeNativeName:(NSString *)name{
    NSLog(@"-------@ld------------",_language);
    if ([name isEqualToString:@"doer-01"]) {
        return _language == 0? @"智能沙发单控":@"Intelligent sofa Single";
    }else if ([name isEqualToString:@"doer-02"]){
        return _language == 0? @"智能沙发双控":@"Intelligent sofa Double";
    }else if ([name isEqualToString:@"doer-03"]){
        return _language == 0? @"智能沙发三控":@"Intelligent sofa Three";
    }else if ([name isEqualToString:@"doer-04"]){
        return _language == 0? @"智能床":@"Intelligent bed";
    } else if ([name isEqualToString:@"doer-05"]) {
        return _language == 0? @"智能沙发单控":@"Intelligent sofa Single";
    } else if ([name isEqualToString:@"doer-06"]) {
        return _language == 0? @"智能沙发双控":@"Intelligent sofa Double";
    } else if ([name isEqualToString:@"doer-07"]) {
        return _language == 0? @"智能沙发三控":@"Intelligent sofa Three";
    }
    
    else{
        return @"智能沙发";
    }
}


-(void)refreshList{
    if (markedIndexPath) {
        [self unmarkCell:markedIndexPath];
        markedIndexPath = nil;
    }
    [self startService];
}


-(DeviceType)DeviceTypeWithCurrentName{
    if ([currentDeviceName isEqualToString:@"doer-01"]) {
        return DeviceType_1_chair;
    } else if ([currentDeviceName isEqualToString:@"doer-02"]) {
        return DeviceType_2_chair;
    } else if ([currentDeviceName isEqualToString:@"doer-03"]) {
        return DeviceType_3_chair;
    } else if ([currentDeviceName isEqualToString:@"doer-04"]) {
        return DeviceType_bed;
    } else if ([currentDeviceName isEqualToString:@"doer-05"]) {
        return DeviceType_1_1_chair;
    } else if ([currentDeviceName isEqualToString:@"doer-06"]) {
        return DeviceType_2_1_chair;
    } else if ([currentDeviceName isEqualToString:@"doer-07"]) {
        return DeviceType_3_1_chair;
    } else {
        return DeviceType_unknown;
    }
    
//    if ([currentDeviceName isEqualToString:@"cndoer-03"]) {
//        return DeviceType_bed;
//    }else if ([currentDeviceName isEqualToString:@"cndoer-01"] ||[currentDeviceName isEqualToString:@"BlueNRG1"] ) {
//        return DeviceType_2_chair;
//    }else if([currentDeviceName isEqualToString:@"cndoer-02"]) {
//        return DeviceType_3_chair;
//    }else{
//        return DeviceType_unknown;
//    }
}


#pragma mark --  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CBPeripheral *peripheral = self.devices[indexPath.row];

    if (!cell.isMarked) {
        if (markedIndexPath) {
            [self unmarkCell:markedIndexPath];
        }
        cell.bgImgView.image = [UIImage imageNamed:@"SelecBG"];
        cell.label.textColor = [UIColor whiteColor];
        markedIndexPath = indexPath;
        CBPeripheral *peripheral = self.devices[indexPath.row];
        currentDeviceName = peripheral.name;
        self.selectedChairImageView.image = [UIImage imageNamed:@"chair"];
        cell.isMarked = !cell.isMarked;
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.progressHUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        self.currentDevice = peripheral;
        [self.mgr connectPeripheral:peripheral options:nil];

        
        
//        cell.bgImgView.image = [UIImage imageNamed:@"UnSelecBG"];
//        cell.label.textColor = CELL_TEXT_COLOR;
        
    }
}

#pragma mark --  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cid = @"device";
    DeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    CBPeripheral *peripheral = self.devices[indexPath.row];
    NSLog(@"===========%@",[self changeNativeName:peripheral.name]);;
    cell.label.text = [self changeNativeName:peripheral.name];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",peripheral.identifier];
    if ( markedIndexPath && indexPath.row == markedIndexPath.row) {
        cell.bgImgView.image = [UIImage imageNamed:@"SelecBG"];
        cell.label.textColor = [UIColor whiteColor];
        cell.isMarked = YES;
    }
    
    return cell;
    
}

#pragma mark - CBCentralManager的代理方法
/**
 *  状态发生改变的时候会执行该方法(蓝牙4.0没有打开变成打开状态就会调用该方法)
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn:
            //打开状态
        {
            self.title = @"选择蓝牙设备";
            //开始扫描
            [self.mgr scanForPeripheralsWithServices:self.devices options:nil];
        }
            
            
            break;
        case CBManagerStatePoweredOff:
            //关闭状态
        {
            [self.devices removeAllObjects];
            [self.deviceListTableView reloadData];
            self.title =@"蓝牙未打开,请打开蓝牙!";
            [self showAlert:@"蓝牙未打开,请打开蓝牙!" needButton:YES];
        }
            break;
        case CBManagerStateResetting:
            //复位
            break;
        case CBManagerStateUnsupported:
            //表明设备不支持蓝牙低功耗
        {
            [self showAlert:@"本手机不支持该蓝牙协议,请升级手机固件" needButton:NO];
        }
            break;
        case CBManagerStateUnauthorized:
            //该应用程序是无权使用蓝牙低功耗
        {
            self.title =@"请在设置中打开蓝牙权限";
            [self showAlert:@"请在设置中打开蓝牙权限" needButton:YES];
        }
            break;
        case CBManagerStateUnknown:
            //未知
        {
            [self showAlert:@"未知错误" needButton:NO];
        }
            break;
        default:
            break;
    }
}

/**
 *  当发现外围设备的时候会调用该方法
 *
 *  @param peripheral        发现的外围设备
 *  @param advertisementData 外围设备发出信号
 *  @param RSSI              信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    if ([self.deviceNames containsObject:peripheral.name]) {
        [self.devices addObject:peripheral];
        NSLog(@"devices = %@",self.devices);
    }

    [self.deviceListTableView reloadData];

    if (self.devices.count == 0) {
        self.tintLabel.hidden = NO;
    }else{
        self.tintLabel.hidden = YES;
    }
}


/**
 *  连接上外围设备的时候会调用该方法
 *
 *  @param peripheral 连接上的外围设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connect %@ success",peripheral.name);
    // 1.扫描所有的服务
    // serviceUUIDs:指定要扫描该外围设备的哪些服务(传nil,扫描所有的服务)
    [peripheral discoverServices:nil];
    
    // 2.设置代理
    peripheral.delegate = self;
    
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    [self.progressHUD hideAnimated:YES];

    //重新开扫
    [self startService];
}

//连接断开
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    [self.progressHUD hideAnimated:YES];

    if([self.devices containsObject:peripheral]){
        [self.devices removeObject:peripheral];
    }
    //重新开扫
    [self startService];
}

#pragma mark --   CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error == nil){
        for (CBService *pService in peripheral.services) {
            
            //发现特征
            //            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:nil]] forService:pService];
            [peripheral discoverCharacteristics:nil forService:pService];
        }
    }else{
        //如果有错，则主动断开，然后会走（centralManager:didDisconnectPeripheral:error:）
        [self.mgr cancelPeripheralConnection:peripheral];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error == nil) {

        for (CBCharacteristic *sChar in service.characteristics){
            
            //判断Characteristic属性类型
//            if ((sChar.properties & CBCharacteristicPropertyRead)){
//                [peripheral readValueForCharacteristic:sChar];
//            }
            if ((sChar.properties & CBCharacteristicPropertyWrite)){
                
                [peripheral setNotifyValue:YES forCharacteristic:sChar];
                NSLog(@"----%@",sChar);
                [self.progressHUD hideAnimated:YES];

                DeviceViewController *deviceVC = [[DeviceViewController alloc]initWithPeripheral:self.currentDevice characteristic:sChar DeviceType:[self DeviceTypeWithCurrentName] language:self.language];
                [self.navigationController pushViewController:deviceVC animated:YES];
            }
        }
    }
    else{
        //如果有错，则主动断开，然后会走（centralManager:didDisconnectPeripheral:error:）
        [self.mgr cancelPeripheralConnection:peripheral];
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (characteristic.isNotifying) {
        NSLog(@"成功");
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError *)error;
{
    NSLog(@"error = %@",error.userInfo);
}


-(void)dealloc{
    [_timer invalidate];
}

@end
