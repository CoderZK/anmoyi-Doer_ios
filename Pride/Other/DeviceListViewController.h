//
//  DeviceListViewController.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListViewController : UIViewController

typedef NS_ENUM(NSInteger, iCLanguage) {
    iCLanguage_Chinese = 0,
    iCLanguage_English
};

@property(nonatomic,assign)iCLanguage language;


- (instancetype)initWithLanguage:(iCLanguage)language;

@end
