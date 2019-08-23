//
//  StoreViewController.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/12/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController


typedef NS_ENUM(NSInteger, sLanguage) {
    sLanguage_Chinese = 0,
    sLanguage_English
};

@property(nonatomic,assign)sLanguage language;

- (instancetype)initWithLanguage:(sLanguage)language;

@end
