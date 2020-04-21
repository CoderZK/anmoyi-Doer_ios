//
//  ClcokShowView.m
//  Pride
//
//  Created by zk on 2020/4/21.
//  Copyright © 2020 gfound. All rights reserved.
//

#import "ClcokShowView.h"
#import "define.h"
#import "zkSignleTool.h"
#import "UIView+BSExtension.h"
@interface ClcokShowView()
@property(nonatomic , strong)UIView *blackV;
@property(nonatomic , strong)UILabel *timeLB;
@property(nonatomic,strong)UILabel *tiemLBTwo;
@end

@implementation ClcokShowView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        UIButton * clossBt =[[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:clossBt];
        [clossBt addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.1];
        self.blackV = [[UIView alloc] initWithFrame:CGRectMake(30,(SCREEN_HEIGHT - 410)/2, SCREEN_WIDTH-60, 410)];
        self.blackV.backgroundColor = [UIColor blackColor];
        self.blackV.layer.cornerRadius = 5;
        self.blackV.clipsToBounds = YES;
        [self addSubview:self.blackV];
    
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.blackV.width, 8)];
        view.backgroundColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        [self.blackV addSubview:view];
        
        self.timeLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 100 , self.blackV.width - 20, 30)];
        self.timeLB.textColor = [UIColor whiteColor];
        self.timeLB.textAlignment = NSTextAlignmentCenter;
        self.timeLB.font = [UIFont systemFontOfSize:20];
        [self.blackV addSubview:self.timeLB];
        self.timeLB.text = @"周一";
        
       self.tiemLBTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLB.frame) + 10 , self.blackV.width - 20, 20)];
       self.tiemLBTwo.textColor = [UIColor whiteColor];
       self.tiemLBTwo.textAlignment = NSTextAlignmentCenter;
       self.tiemLBTwo.font = [UIFont systemFontOfSize:14];
       [self.blackV addSubview:self.tiemLBTwo];
       self.tiemLBTwo.text = @"周一";
        
       
           NSDate *now = [NSDate date];
           NSLog(@"now date is: %@", now);
           
           NSCalendar *calendar = [NSCalendar currentCalendar];
           NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
           NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
           NSInteger year = [dateComponent year];
           NSInteger month =  [dateComponent month];
           NSInteger day = [dateComponent day];
           NSInteger hour =  [dateComponent hour];
           NSInteger minute =  [dateComponent minute];
           NSInteger second = [dateComponent second];
        NSInteger week = [[zkSignleTool shareTool] getWeekDayFordate];
        NSArray * arr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        
        self.tiemLBTwo.text = [NSString stringWithFormat:@"%d月%d  %@",month,day,arr[week]];
        
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake((self.blackV.width - 130)/2, CGRectGetMaxY(self.tiemLBTwo.frame) + 15, 130, 130)];
        [self.blackV addSubview:imgV];
        imgV.backgroundColor = [UIColor redColor];
        
        UIButton * confirmBt = [[UIButton alloc] initWithFrame:CGRectMake((self.blackV.width - 100)/2 , CGRectGetMaxY(imgV.frame) + 30   , 100, 40)];
//        confirmBt.backgroundColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        confirmBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBt.layer.cornerRadius = 20;
        confirmBt.clipsToBounds = YES;
        confirmBt.layer.borderColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0].CGColor;
        confirmBt.layer.borderWidth = 1.0;
        [self.blackV addSubview:confirmBt];
        [confirmBt addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBt setTitle:@"确定" forState:UIControlStateNormal];
        
        
        

    }
    
    
    return  self ;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    self.timeLB.text = timeStr;
    
    
}

- (void)confirmAction:(UIButton *)button {
    
    if (self.clossClcokBlock != nil) {
        self.clossClcokBlock();
    }
     
    
}


- (void)show {
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
    }];
    
    
}

- (void)diss {
    [UIView animateWithDuration:0.2 animations:^{
          self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.1];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
