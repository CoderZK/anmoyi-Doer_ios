//
//  DeviceViewController.h
//  JakBlueTooth
//
//  Created by Zyh on 2017/9/5.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PridePeripheral.h"
@interface DeviceViewController : UIViewController

typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceType_1_chair,
    DeviceType_2_chair,
    DeviceType_3_chair,
    DeviceType_bed,
    DeviceType_1_1_chair,
    DeviceType_2_1_chair,
    DeviceType_3_1_chair,
    DeviceType_unknown
    
};
@property(nonatomic,strong)CBPeripheral *peripheral;

@property(nonatomic,strong)PridePeripheral *prideModel;
@property (nonatomic,strong)CBCharacteristic * characteristic;

@property(nonatomic,assign)DeviceType deviceType;

@property(nonatomic,assign)NSInteger language;


- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic DeviceType:(DeviceType)deviceType language:(NSInteger)language;


@end
