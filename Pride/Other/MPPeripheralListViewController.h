//
//  MPPeripheralListViewController.h
//  Pride
//
//  Created by Zyh on 2017/12/18.
//  Copyright © 2017年 gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPPeripheralListViewController : UIViewController

typedef NS_ENUM(NSInteger, mpCLanguage) {
    mpCLanguage_Chinese = 0,
    mpCLanguage_English
};

@property(nonatomic,assign)mpCLanguage language;


- (instancetype)initWithLanguage:(mpCLanguage)language;


@end
