//
//  BBViewController.m
//  Pride
//
//  Created by Zyh on 2017/12/18.
//  Copyright © 2017年 gfound. All rights reserved.
//

#import "BBViewController.h"
#import "define.h"
#import "DeviceCell.h"
#import "DeviceViewController.h"
#import "MBProgressHUD.h"
#import "PridePeripheral.h"

@interface BBViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *deviceListTableView;

@property(nonatomic,strong)CBPeripheral *currentPeripheral;

@property(nonatomic,strong)NSMutableArray *peripherals;

@property(nonatomic,strong)UILabel *tintLabel;

@property(nonatomic,strong)NSMutableArray *devices;

@property(nonatomic,strong)NSMutableArray *deviceNames;

@property(nonatomic,strong)MBProgressHUD *progressHUD;

@property(nonatomic,strong)UIImageView *selectedChairImageView;

@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,weak)DeviceViewController *deviceVC;

@property(nonatomic,assign)BOOL isPresenting;

@property(nonatomic,assign)DeviceType deviceType;

@property (nonatomic, strong) UIButton *jiantou_left_button;
@property (nonatomic, strong) UIButton *jiantou_right_button;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) DeviceCell *selectedCell;


@property(nonatomic,strong)PridePeripheral *prideModel;

@end

@implementation BBViewController
{
    BabyBluetooth *baby;
    
}

#pragma mark --  init

- (instancetype)initWithLanguage:(NSInteger)language
{
    self = [super init];
    if (self) {
        _language = language;
    }
    return self;
}

#pragma mark --  lazy load
-(NSMutableArray *)peripherals
{
    if(!_peripherals){
        self.peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

#pragma mark --  FifeCycle

-  (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startScan) name:@"backToMain" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLanguage) name:@"languageUpdate" object:nil];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    self.language = language;
    
    [self setUpBaseUI];
    
    [self setUpTableView];
    
    [self setUpService];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isPresenting = NO;
    [self startScan];
}

#pragma mark --  Basic


-(void)setUpObserver{
}

-(void)setUpService{
    
    //实例化baby
    baby = [BabyBluetooth shareBabyBluetooth];
    //配置委托
    [self babyDelegate];
    
}


-(void)setUpBaseUI{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:imageView];
    
    UIImageView *titleImageView = [[UIImageView alloc]
                                   initWithImage:[UIImage imageNamed:@"logo"]];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [titleImageView sizeToFit];
    [self.view addSubview:titleImageView];
    titleImageView.frame = CGRectMake(0, 50, SCREEN_WIDTH, CGRectGetHeight(titleImageView.frame));
    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.text =@"Pride";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:titleLabel];
    
    self.selectedChairImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 162)];
    self.selectedChairImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.selectedChairImageView];
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 45, 55, 55)];
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(startScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    self.tintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.75 - 38.5 -10, SCREEN_WIDTH, 20)];
    self.tintLabel.textAlignment = NSTextAlignmentCenter;
    self.tintLabel.textColor = CELL_TEXT_COLOR;
    self.tintLabel.text = @"暂未发现设备!请刷新";
    [self.view addSubview:self.tintLabel];
    self.tintLabel.hidden = YES;
    
    self.jiantou_left_button = [UIButton new];
    [self.jiantou_left_button setImage:[UIImage imageNamed:@"jiantou_left"] forState:UIControlStateNormal];
    [self.view addSubview:self.jiantou_left_button];
    [self.jiantou_left_button addTarget:self
                                 action:@selector(leftAction:)
                       forControlEvents:UIControlEventTouchUpInside];
    self.jiantou_left_button.frame = CGRectMake(20, self.selectedChairImageView.frame.origin.y + self.selectedChairImageView.frame.size.height/2.f,
                                                46,
                                                52);
    
    self.jiantou_right_button = [UIButton new];
    [self.jiantou_right_button setImage:[UIImage imageNamed:@"jiantou_right"] forState:UIControlStateNormal];
    [self.view addSubview:self.jiantou_right_button];
    [self.jiantou_right_button addTarget:self
                                 action:@selector(rightAction:)
                       forControlEvents:UIControlEventTouchUpInside];
    self.jiantou_right_button.frame = CGRectMake(SCREEN_WIDTH-20-46, self.selectedChairImageView.frame.origin.y + self.selectedChairImageView.frame.size.height/2.f,
                                                46,
                                                52);
}

- (void)leftAction:(id)sender {
    NSInteger count = self.peripherals.count;
    NSInteger nowSelectedCount = self.selectedIndexPath.row;
    NSInteger leftCount = nowSelectedCount - 1;
    if (leftCount < 0) {
        return;
    }
    
    NSIndexPath *willActionIndexPath = [NSIndexPath indexPathForRow:leftCount inSection:0];
    
    [self.deviceListTableView selectRowAtIndexPath:willActionIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    self.selectedIndexPath = willActionIndexPath;
}

- (void)rightAction:(id)sender {
    NSInteger count = self.peripherals.count;
    NSInteger nowSelectedCount = self.selectedIndexPath.row;
    NSInteger rightCount = nowSelectedCount + 1;
    if (rightCount >= count) {
        return;
    }
    
    NSIndexPath *willActionIndexPath = [NSIndexPath indexPathForRow:rightCount inSection:0];
    
    [self.deviceListTableView selectRowAtIndexPath:willActionIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    self.selectedIndexPath = willActionIndexPath;
}

-(void)setUpTableView{
    self.deviceListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectedChairImageView.frame)+40, SCREEN_WIDTH, SCREEN_HEIGHT *0.5 - 77.5) style:UITableViewStylePlain];
    self.deviceListTableView.delegate = self;
    self.deviceListTableView.dataSource = self;
    [self.deviceListTableView setTableFooterView:[[UIView alloc]init]];
    self.deviceListTableView.backgroundColor = [UIColor clearColor];
    self.deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.deviceListTableView];
}


-(DeviceCell *)setUpCellViewInTableView:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cid = @"per";
    DeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    return cell;
}


#pragma mark --  Tool
-(void)updateLanguage{
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    self.language = language;
    
}

-(void)showAlert:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString * )titleStr:(PridePeripheral *)pride {
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld%@",self.language,pride.mac]];
    
    if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"(null)"]) {
        NSString *name = pride.name;
        if ([name isEqualToString:@"doer-01"]) {
            return _language == 0? @"智能沙发单控":@"recliner sofa(single control)";
        }else if ([name isEqualToString:@"doer-02"]){
            return _language == 0? @"智能沙发双控":@"recliner sofa(double control)";
        }else if ([name isEqualToString:@"doer-03"]){
            return _language == 0? @"智能沙发三控":@"recliner sofa(three control)";
        }
        else if ([name isEqualToString:@"doer-04"]){
            return _language == 0? @"电动床":@"Motion Bed";
        }
        else if ([name isEqualToString:@"doer-05"]) {
            return _language == 0?  @"智能沙发单控":@"recliner sofa(single control)";
        } else if ([name isEqualToString:@"doer-06"]) {
            return _language == 0? @"智能沙发双控":@"recliner sofa(double control)";
        } else if ([name isEqualToString:@"doer-07"]) {
            return _language == 0? @"智能沙发三控":@"recliner sofa(three control)";
        }
        return nil;
    }else {
        
        return str;
    }
 
}


-(NSString *)rename:(NSString *)name{
//    if ([name isEqualToString:@"doer-01"]) {
//        return @"智能沙发单控";
//    }else if ([name isEqualToString:@"doer-02"]){
//        return @"智能沙发双控";
//    }else if ([name isEqualToString:@"doer-03"]){
//        return @"智能沙发三控";
//    }else if ([name isEqualToString:@"doer-04"]){
//        return @"智能床";
//    } else if ([name isEqualToString:@"doer-05"]) {
//        return @"智能沙发单控";
//    } else if ([name isEqualToString:@"doer-06"]) {
//        return @"智能沙发双控";
//    } else if ([name isEqualToString:@"doer-07"]) {
//        return @"智能沙发三控";
//    }
//
    
    if ([name isEqualToString:@"doer-01"]) {
        return _language == 0? @"智能沙发单控":@"recliner sofa(single control)";
    }else if ([name isEqualToString:@"doer-02"]){
        return _language == 0? @"智能沙发双控":@"recliner sofa(double control)";
    }else if ([name isEqualToString:@"doer-03"]){
        return _language == 0? @"智能沙发三控":@"recliner sofa(three control)";
    }
    else if ([name isEqualToString:@"doer-04"]){
        return _language == 0? @"电动床":@"Motion Bed";
    }
    else if ([name isEqualToString:@"doer-05"]) {
        return _language == 0?  @"智能沙发单控":@"recliner sofa(single control)";
    } else if ([name isEqualToString:@"doer-06"]) {
        return _language == 0? @"智能沙发双控":@"recliner sofa(double control)";
    } else if ([name isEqualToString:@"doer-07"]) {
        return _language == 0? @"智能沙发三控":@"recliner sofa(three control)";
    }
    
    return nil;
//    if ([name isEqualToString:@"cndoer-01"]){
//        return @"按摩椅(两推杆)";
//    }else if ([name isEqualToString:@"cndoer-02"]){
//        return @"按摩椅(三推杆)";
//    }else if ([name isEqualToString:@"cndoer-03"]){
//        return @"按摩床";
//    }
//    return nil;
}

-(DeviceType)DeviceTypeWithCurrentName:(NSString *)currentDeviceName{
//    if ([currentDeviceName isEqualToString:@"cndoer-03"]) {
//        return DeviceType_bed;
//    }else if ([currentDeviceName isEqualToString:@"cndoer-01"]) {
//        return DeviceType_2_chair;
//    }else if([currentDeviceName isEqualToString:@"cndoer-02"]) {
//        return DeviceType_3_chair;
//    }else{
//        return DeviceType_unknown;
//    }
    
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
}

#pragma mark --  Service

//开始扫描
-(void)startScan{
    [self.peripherals removeAllObjects];
    [self.deviceListTableView reloadData];
    self.progressHUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    baby.scanForPeripherals().begin();
    
    [self.progressHUD performSelector:@selector(hideAnimated:) withObject:@YES afterDelay:2.0f];

}

//连接外设
-(void)connect:(CBPeripheral *)peripheral{
    self.progressHUD= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.progressHUD hideAnimated:YES afterDelay:10.0f]; baby.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics(CBCharacteristicPropertyWrite).begin();
    
   
    
}

//断开外设
-(void)disconnectCurrentDevice:(CBPeripheral *)per{
    [baby cancelPeripheralConnection:per];
    [self.peripherals removeAllObjects];
    [self startScan];
}


#pragma mark --  Baby


//配置委托
- (void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(baby) weakBaby = baby;
    
    [self.peripherals removeAllObjects];

    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *locolName = [[advertisementData objectForKey:@"kCBAdvDataLocalName"] lowercaseString];
//        NSString *mac = [[NSString alloc] initWithData:[advertisementData objectForKey:@"kCBAdvDataManufacturerData"] encoding:NSUTF8StringEncoding];
//        [peripheral discoverServices:@[[CBUUID UUIDWithString:@"180A"]]];
        NSLog(@"搜索到了设备:%@, locolName = %@",peripheral.name,locolName);
        [weakSelf.progressHUD hideAnimated:YES];

        NSUUID * uuid = peripheral.identifier;
        NSString * mac = [uuid UUIDString];
        
        NSLog(@"===============");
        
        PridePeripheral *prideP = [[PridePeripheral alloc] init];
        
        prideP.name = locolName;
        prideP.mac = mac;
        prideP.peripheral = peripheral;
        
        NSLog(@"===========%@====",weakSelf.peripherals);
        
        NSArray *names = [weakSelf.peripherals valueForKeyPath:@"mac"];
        
        if (![names containsObject:mac]) {
            [weakSelf.peripherals addObject:prideP];
            [weakSelf.deviceListTableView reloadData];
        }
        
        
        
        
        
        
        if([weakSelf.peripherals count]>0){
            
            
            PridePeripheral *_prideP = [weakSelf.peripherals objectAtIndex:0];
            
            if([_prideP.name isEqualToString:@"doer-04"])
            {
                weakSelf.selectedChairImageView.image = [UIImage imageNamed:@"bed"];
                
            }else{
                
                weakSelf.selectedChairImageView.image = [UIImage imageNamed:@"chair"];
            }
        }

        
    }];
    
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {

        [weakBaby cancelScan];
        [weakSelf.progressHUD hideAnimated:YES];
        NSLog(@"设备：%@--连接成功",peripheral.name);
            

    }];

    //发现服务的回调
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {

            for (CBService *service in peripheral.services) {
                NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
            }

    }];
    //发现特征的回调
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        if ((service.UUID.UUIDString.length == 4 && [[service.UUID.UUIDString substringWithRange:NSMakeRange(2, 2)].lowercaseString isEqualToString:@"e0"]) || (service.UUID.UUIDString.length >= 8 && [[service.UUID.UUIDString substringWithRange:NSMakeRange(6, 2)].lowercaseString isEqualToString:@"e0"])){
            for (CBCharacteristic * characteristic in service.characteristics) {
                if ((characteristic.UUID.UUIDString.length == 4 && [[characteristic.UUID.UUIDString substringWithRange:NSMakeRange(2, 2)].lowercaseString isEqualToString:@"e2"]) || (characteristic.UUID.UUIDString.length >= 8 && [[characteristic.UUID.UUIDString substringWithRange:NSMakeRange(6, 2)].lowercaseString isEqualToString:@"e2"])) {
                    NSLog(@"Charateristic UUID is :%@", characteristic.UUID.UUIDString);
                    if (!weakSelf.isPresenting) {
                        DeviceViewController *deviceVC = [[DeviceViewController alloc] initWithPeripheral:peripheral
                                                                                          characteristic:characteristic
                                                                                              DeviceType:weakSelf.deviceType language:weakSelf.language];
                        deviceVC.prideModel = weakSelf.prideModel;
                        [weakSelf.navigationController pushViewController:deviceVC animated:YES];
                        weakSelf.isPresenting = YES;
                    }
                }
            }
        }
    }];
    
    
    
    
    //设备断开后
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
         [self.peripherals removeAllObjects];
        [weakSelf startScan];
        
    }];
   
    
    //过滤器
    //设置查找设备名称的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
         NSString *locolName = [[advertisementData objectForKey:@"kCBAdvDataLocalName"] lowercaseString];
        NSLog(@"local name is %@", locolName);
        if (peripheralName.length >0 && [NamePoolArray containsObject:locolName]) {
            return YES;
        }
        return NO;
//        return YES;
    }];

    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    DeviceViewController *deviceVC = [[DeviceViewController alloc] initWithPeripheral:nil
//                                                                       characteristic:nil
//                                                                           DeviceType:self.deviceType language:self.language];
//    [self.navigationController pushViewController:deviceVC animated:YES];
//
////    DeviceViewController *deviceVC = [[DeviceViewController alloc]init];
////    [self.navigationController pushViewController:deviceVC animated:YES];
//
//}



#pragma mark --  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.peripherals.count;
//    return 3;
//    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DeviceCell *cell  = [self setUpCellViewInTableView:tableView AtIndexPath:indexPath];
    
    PridePeripheral *per = self.peripherals[indexPath.row];
//    cell.label.text =[self rename:per.name];
    per.showName = [self titleStr:per];
    cell.label.text =  [self titleStr:per];
//    cell.label.text = @"测试";
    
    return cell;
    
}


#pragma mark --  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 78 * (SCREEN_WIDTH - 20)/612.0 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DeviceViewController *deviceVC = [[DeviceViewController alloc]initWithPeripheral:nil
//                                                                      characteristic:nil
//                                                                          DeviceType:DeviceType_3_1_chair language:self.language];
//    [self.navigationController pushViewController:deviceVC animated:YES];
//    self.isPresenting = YES;
    
    DeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.isMarked) {
        PridePeripheral *prideP = [self.peripherals objectAtIndex:indexPath.row];
        self.prideModel = prideP;
        self.deviceType = [self DeviceTypeWithCurrentName:prideP.name];
        if (self.deviceType != DeviceType_unknown) {
            [self connect:prideP.peripheral];
            [baby AutoReconnect:prideP.peripheral];
        }else{
            [self showAlert:@"连接错误,请刷新!"];
        }
    }
    else{
        
        self.selectedCell.isMarked = NO;
        self.selectedCell = cell;
        
        PridePeripheral *_prideP = [self.peripherals objectAtIndex:indexPath.row];
        if([_prideP.name isEqualToString:@"doer-04"])
        {
            self.selectedChairImageView.image = [UIImage imageNamed:@"bed"];
            
        }else{
            
            self.selectedChairImageView.image = [UIImage imageNamed:@"chair"];
        }
        NSLog(@"---test------");
        
    }
    
    cell.isMarked = !cell.isMarked;
}


@end
