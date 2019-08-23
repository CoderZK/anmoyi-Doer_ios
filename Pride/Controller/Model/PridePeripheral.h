//
//  PridePeripheral.h
//  Pride
//
//  Created by Zyh on 2018/1/10.
//  Copyright © 2018年 gfound. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"

@interface PridePeripheral : NSObject

@property(nonatomic,strong)CBPeripheral *peripheral;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy) NSString *mac;

@property(nonatomic,strong)NSString *showName;

@end
