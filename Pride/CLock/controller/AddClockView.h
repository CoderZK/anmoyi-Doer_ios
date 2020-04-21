//
//  AddClockView.h
//  Pride
//
//  Created by kunzhang on 2020/4/21.
//  Copyright © 2020 gfound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zkSignleTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddClockView : UIView
- (void)show;
- (void)diss;
@property(nonatomic,copy)void(^clickConfirmBlock)(clcokModel *model);
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString *keyStr;
@property(nonatomic,strong)clcokModel *model;
@end

NS_ASSUME_NONNULL_END
