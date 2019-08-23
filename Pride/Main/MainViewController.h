//
//  MainViewController.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController


@property(nonatomic,assign)NSInteger language;


- (instancetype)initWithLanguage:(NSInteger )language;


@end
