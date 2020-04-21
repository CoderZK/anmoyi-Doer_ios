//
//  SendDataTool.m
//  Pride
//
//  Created by Zyh on 2017/12/18.
//  Copyright © 2017年 gfound. All rights reserved.
//

#import "SendDataTool.h"

@implementation SendDataTool


+(void)sendData:(BlueToothOrderType)orderType complention:(void (^)(NSData * data))complentioner{
    int  word,byte;
    
    switch (orderType) {
        case BlueToothOrderType_Leg_Up_On:
        {
            word = 0xA1;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Leg_Up_Off:
        {
            word = 0xA1;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Leg_Down_On:
        {
            word = 0xA2;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Leg_Down_Off:
        {
            word = 0xA2;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Waist_Up_On:
        {
            word = 0xA3;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Waist_Up_Off:
        {
            word = 0xA3;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Waist_Down_On:
        {
            word = 0xA4;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Waist_Down_Off:
        {
            word = 0xA4;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Head_Up_On:
        {
            word = 0xA5;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Head_Up_Off:
        {
            word = 0xA5;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Head_Down_On:
        {
            word = 0xA6;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Head_Down_Off:
        {
            word = 0xA6;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Reset_On:
        {
            word = 0xA7;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Reset_Off:
        {
            word = 0xA7;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Remember1_On:
        {
            word = 0xA8;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Remember1_New_Location:
        {
            word = 0xA8;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Remember2_On:
        {
            word = 0xA9;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Remember2_New_Location:
        {
            word = 0xA9;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Massage_Gear_1:
        {
            word = 0xAA;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Massage_Gear_2:
        {
            word = 0xAA;byte = 0x02;
        }
            break;
        case BlueToothOrderType_Massage_Gear_3:
        {
            word = 0xAA;byte = 0x03;
        }
            break;
        case BlueToothOrderType_Massage_Gear_0:
        {
            word = 0xAA;byte = 0x04;
             break;
        }
        case BlueToothOrderType_Wake_UP:{
            word = 0xAD;byte = 0x01;
             break;
        }
           
            //        case BlueToothOrderType_Massage2_Gear_1:
            //        {
            //            word = 0xAB;byte = 0x01;
            //        }
            //            break;
            //        case BlueToothOrderType_Massage2_Gear_2:
            //        {
            //            word = 0xAB;byte = 0x02;
            //        }
            //            break;
            //        case BlueToothOrderType_Massage2_Gear_3:
            //        {
            //            word = 0xAB;byte = 0x03;
            //        }
            //            break;
            //        case BlueToothOrderType_Massage2_Gear_Off:
            //        {
            //            word = 0xAB;byte = 0x04;
            //        }
            //            break;
        case BlueToothOrderType_Light_On:
        {
            word = 0xAC;byte = 0x01;
        }
            break;
        case BlueToothOrderType_Light_Off:
        {
            word = 0xAC;byte = 0x02;
        }
            break;
        default:
        {
            NSLog(@"状态码异常!");
        }
            return;
    }
    
    uint8_t sendData[]={0xFD,0xFD,word,byte,(0xFD + 0xFD + word + byte) & 0x7f,0x0D,0x0A};
    NSMutableData *data=[[NSMutableData alloc]init];
    [data appendBytes:(void *)(&sendData[0]) length:sizeof(sendData)];
    complentioner(data);
}


@end
