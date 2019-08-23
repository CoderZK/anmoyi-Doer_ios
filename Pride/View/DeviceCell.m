//
//  DeviceCell.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "DeviceCell.h"
#import "define.h"

@implementation DeviceCell


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    if (selected) {
//        self.bgImgView.image = [UIImage imageNamed:@"SelecBG"];
//        self.label.textColor = [UIColor whiteColor];
//    }
//    // Configure the view for the selected state
//}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isMarked = NO;
        [self prepareLayOut];
    }
    return self;
}




-(void)prepareLayOut{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 57)];
    self.bgImgView.image = NORMAL_UNSELECT_BUTTON_BG;
    [self.contentView addSubview:self.bgImgView];

    self.label = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 120, 20)];
    self.label.textColor = CELL_TEXT_COLOR;
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.label];
    
}


-(void)setIsMarked:(BOOL)isMarked{
    _isMarked = isMarked;
    if (isMarked) {
        self.bgImgView.image = NORMAL_SELECT_BUTTON_BG;
        self.label.textColor = [UIColor whiteColor];
    }else{
        self.bgImgView.image = NORMAL_UNSELECT_BUTTON_BG;
        self.label.textColor = CELL_TEXT_COLOR;
    }
    
}


@end
