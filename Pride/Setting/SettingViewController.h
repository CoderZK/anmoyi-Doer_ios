//
//  SettingViewController.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/12/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController


typedef NS_ENUM(NSInteger, Language) {
    Language_Chinese = 0,
    Language_English
};

@property(nonatomic,assign)Language language;

- (instancetype)initWithLanguage:(Language)language;

@end
