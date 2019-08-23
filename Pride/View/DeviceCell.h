//
//  DeviceCell.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceCell : UITableViewCell

@property(nonatomic,strong)UIImageView *bgImgView;

@property(nonatomic,strong)UILabel *label;

@property(nonatomic,assign)BOOL isMarked;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
