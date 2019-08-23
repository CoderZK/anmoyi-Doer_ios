//
//  MPPeripheralListViewController.m
//  Pride
//
//  Created by Zyh on 2017/12/18.
//  Copyright © 2017年 gfound. All rights reserved.
//

#import "MPPeripheralListViewController.h"
#import "MPBluetoothKit.h"
#import "PeripheralDetailViewController.h"

NSString *const kPeripheralCellIdentifier = @"kPeripheralCellIdentifier";

@interface MPPeripheralListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *discoverdPeripheralsTableView;


@property (nonatomic, strong) MPCentralManager *centralManager;

@end

@implementation MPPeripheralListViewController

#pragma mark --  init
- (instancetype)initWithLanguage:(mpCLanguage)language
{
    self = [super init];
    if (self) {
        _language = language;
    }
    return self;
}

#pragma mark --  lazy load
-(UITableView *)discoverdPeripheralsTableView
{
    if(!_discoverdPeripheralsTableView){
        _discoverdPeripheralsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _discoverdPeripheralsTableView.delegate = self;
        _discoverdPeripheralsTableView.dataSource = self;
        [_discoverdPeripheralsTableView setTableFooterView:[UIView new]];
        [self.view addSubview:_discoverdPeripheralsTableView];
        
    }
    return _discoverdPeripheralsTableView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Searching peripherals";
    
    [self discoverdPeripheralsTableView];
    
    __weak typeof(self) weakSelf = self;
    _centralManager = [[MPCentralManager alloc] initWithQueue:nil];
    [_centralManager setUpdateStateBlock:^(MPCentralManager *centralManager){
        if(centralManager.state == CBCentralManagerStatePoweredOn){
            [weakSelf scanPeripehrals];
        }
        else{
            [weakSelf.discoverdPeripheralsTableView reloadData];
        }
    }];
    
    [_discoverdPeripheralsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kPeripheralCellIdentifier];
}

- (void)scanPeripehrals
{
    if(_centralManager.state == CBCentralManagerStatePoweredOn){
        [_centralManager scanForPeripheralsWithServices:nil options:nil withBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            [_discoverdPeripheralsTableView reloadData];
        }];
    }
}

- (void)connectPeripheral:(MPPeripheral *)peripheral
{
    [_centralManager connectPeripheral:peripheral options:nil withSuccessBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral) {
        PeripheralDetailViewController *controller = [[PeripheralDetailViewController alloc] init];
        controller.peripheral = peripheral;
        [self.navigationController pushViewController:controller animated:YES];
    } withDisConnectBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral, NSError *error) {
        NSLog(@"disconnectd %@",peripheral.name);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_centralManager.discoveredPeripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPeripheralCellIdentifier forIndexPath:indexPath];
    
    MPPeripheral *peripheral = [_centralManager.discoveredPeripherals objectAtIndex:indexPath.row];
    NSLog( @"peripheral= %@",peripheral);

    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",[peripheral.RSSI integerValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MPPeripheral *peripheral = [_centralManager.discoveredPeripherals objectAtIndex:indexPath.row];
    [self connectPeripheral:peripheral];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}



@end
