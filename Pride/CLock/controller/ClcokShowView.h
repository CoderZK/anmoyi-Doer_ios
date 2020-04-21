//
//  ClcokShowView.h
//  Pride
//
//  Created by zk on 2020/4/21.
//  Copyright © 2020 gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClcokShowView : UIView
- (void)show;
- (void)diss;

@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,copy)void(^clossClcokBlock)();

@end

NS_ASSUME_NONNULL_END
