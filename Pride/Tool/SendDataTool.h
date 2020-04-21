//
//  SendDataTool.h
//  Pride
//
//  Created by Zyh on 2017/12/18.
//  Copyright © 2017年 gfound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendDataTool : NSObject

typedef NS_ENUM(NSInteger, BlueToothOrderType) {
    BlueToothOrderType_Leg_Up_On = 0,
    BlueToothOrderType_Leg_Up_Off,
    BlueToothOrderType_Leg_Down_On,
    BlueToothOrderType_Leg_Down_Off,
    BlueToothOrderType_Waist_Up_On,
    BlueToothOrderType_Waist_Up_Off,
    BlueToothOrderType_Waist_Down_On,
    BlueToothOrderType_Waist_Down_Off,
    BlueToothOrderType_Head_Up_On,
    BlueToothOrderType_Head_Up_Off,
    BlueToothOrderType_Head_Down_On,
    BlueToothOrderType_Head_Down_Off,
    BlueToothOrderType_Reset_On,
    BlueToothOrderType_Reset_Off,
    BlueToothOrderType_Remember1_On,
    BlueToothOrderType_Remember1_New_Location,
    BlueToothOrderType_Remember2_On,
    BlueToothOrderType_Remember2_New_Location,
    BlueToothOrderType_Massage_Gear_0,//关闭
    BlueToothOrderType_Massage_Gear_1,
    BlueToothOrderType_Massage_Gear_2,
    BlueToothOrderType_Massage_Gear_3,
    BlueToothOrderType_Light_On,
    BlueToothOrderType_Light_Off,
    BlueToothOrderType_Wake_UP
};

+(void)sendData:(BlueToothOrderType)orderType complention:(void (^)(NSData * data))complentioner;

@end
