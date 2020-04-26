//
//  AddClockView.m
//  Pride
//
//  Created by kunzhang on 2020/4/21.
//  Copyright © 2020 gfound. All rights reserved.
//

#import "AddClockView.h"
#import "define.h"
#import "UIView+BSExtension.h"
#import "zkSignleTool.h"
#import "MBProgressHUD.h"
@interface AddClockView()
@property(nonatomic , strong)UIView *blackV;
@property(nonatomic , strong)UIDatePicker *datePicker;
@property(nonatomic , strong)UILabel *timeLB;
@property(nonatomic , strong)UISwitch *switchBt;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UIButton *chooseBt;

@property(nonatomic,strong)UIView *blackTwoView;

@end


@implementation AddClockView


- (UIView *)blackTwoView {
    if (_blackTwoView == nil) {
        
        NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];

        
        
        _blackTwoView = [[UIView  alloc] initWithFrame:CGRectMake(30, 120, SCREEN_WIDTH-60, SCREEN_HEIGHT - 240)];
        _blackTwoView.backgroundColor = [UIColor blackColor];
        
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.blackV.width, 8)];
        view.backgroundColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        [_blackTwoView addSubview:view];
              
              
        UILabel * lb1 =[[UILabel alloc] initWithFrame:CGRectMake(50, 25, self.blackV.width - 100, 20)];
        lb1.textColor = [UIColor whiteColor];
        lb1.font = [UIFont systemFontOfSize:15 weight:0.2];
        
        NSString * str1 = @"编辑闹钟";
        if (language == 1) {
            str1 = @"Edit the alarm clock";
        }
        
        lb1.text =str1;
        lb1.textAlignment = NSTextAlignmentCenter;
        [_blackTwoView addSubview:lb1];
        
        NSString * str2 = @"返回";
        if (language == 1) {
            str2 = @"back";
        }
        
        UIButton * buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 70, 40)];
        [buttonBack setTitle:str2 forState:UIControlStateNormal];
        [buttonBack setTitleColor:[UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0] forState:UIControlStateNormal];
        [buttonBack setImage:[UIImage imageNamed:@"zkfan"] forState:UIControlStateNormal];
        [buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_blackTwoView addSubview:buttonBack];
        
        NSArray * arr = @[@"每周日",@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六"];
        if (language == 1) {
            arr = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
        }
        for (int i = 0 ; i < arr.count ; i++) {
            UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 55+ i*50+15, 100, 20)];
            lb.font = [UIFont systemFontOfSize:14];
            lb.text = arr[i];
            lb.textColor = [UIColor whiteColor];
            [_blackTwoView addSubview:lb];
            
            UIView * backV =[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lb.frame) + 14.7, SCREEN_WIDTH-60 - 20 , 0.6)];
            backV.backgroundColor = [UIColor whiteColor];
            [_blackTwoView addSubview:backV];
            
            UIButton * button  = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-60 - 50 , CGRectGetMinY(lb.frame) - 10, 40, 40)];
            [_blackTwoView addSubview:button];
            button.tag = 100+i;
            [button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(timeChooseAction:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        
        
    }
    return _blackTwoView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
         NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
        
        UIButton * clossBt =[[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:clossBt];
        [clossBt addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.backgroundColor =[UIColor colorWithWhite:0 alpha:0.1];
        self.blackV = [[UIView alloc] initWithFrame:CGRectMake(30, 120, SCREEN_WIDTH-60, SCREEN_HEIGHT - 240)];
        self.blackV.backgroundColor = [UIColor blackColor];
        self.blackV.layer.cornerRadius = 5;
        self.blackV.clipsToBounds = YES;
        [self addSubview:self.blackV];
    
        UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.blackV.width, 8)];
        view.backgroundColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        [self.blackV addSubview:view];
        
        
        UILabel * lb1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.blackV.width - 20, 20)];
        lb1.textColor = [UIColor whiteColor];
        lb1.font = [UIFont systemFontOfSize:15 weight:0.2];

        NSString * str1 = @"编辑闹钟";
        if (language == 1) {
            str1 = @"Edit the alarm clock";
        }
        lb1.text = str1;
        self.titleLB = lb1;
        lb1.textAlignment = NSTextAlignmentCenter;
        [self.blackV addSubview:lb1];
        
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, 50, self.blackV.width - 20, self.blackV.height - 240)];
        [self.blackV addSubview:self.datePicker];
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        [self.datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
        self.datePicker.backgroundColor = [UIColor blackColor];
        self.datePicker.datePickerMode =  UIDatePickerModeCountDownTimer;
    
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        
        UILabel * lb2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.datePicker.frame) + 10+15, 60, 20)];
        lb2.textColor = [UIColor whiteColor];
        lb2.font = [UIFont systemFontOfSize:14];
        lb2.text = @"重复";
        if (language == 1) {
            lb2.text = @"repeat";
        }
        [self.blackV addSubview:lb2];
        
        
        
        
        self.timeLB = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMinY(lb2.frame), self.blackV.width - 80, 20)];
        self.timeLB.textColor = [UIColor whiteColor];
        self.timeLB.textAlignment = NSTextAlignmentRight;
        self.timeLB.font = [UIFont systemFontOfSize:13];
        [self.blackV addSubview:self.timeLB];
        self.timeLB.text = @"永不 >";
        if (language == 1) {
            self.timeLB.text = @"never >";
        }
        self.chooseBt = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.datePicker.frame) + 10+ 5, self.blackV.width - 20, 40)];
        [self.blackV addSubview:self.chooseBt];
        [self.chooseBt addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIView * backV =[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLB.frame) + 15, self.blackV.width - 20, 0.6)];
        backV.backgroundColor = [UIColor whiteColor];
        [self.blackV addSubview:backV];
        
        UILabel * lb3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backV.frame) + 15,120, 20)];
        lb3.textColor = [UIColor whiteColor];
        lb3.font = [UIFont systemFontOfSize:14];
        lb3.text = @"是否启用";
        if (language == 1) {
            lb3.text = @"Enabled";
        }
        [self.blackV addSubview:lb3];
        
        self.switchBt = [[UISwitch alloc] initWithFrame:CGRectMake(self.blackV.width - 70, CGRectGetMaxY(backV.frame) + 10, 60, 30)];
//        self.switchBt.tintColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        self.switchBt.onTintColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        [self.blackV addSubview:self.switchBt];
        self.switchBt.on = YES;
        
        UIView * backV2 =[[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(backV.frame) + 50, self.blackV.width - 10, 0.6)];
               backV2.backgroundColor = [UIColor whiteColor];
               [self.blackV addSubview:backV2];
        
    
        UIButton * confirmBt = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(backV2.frame) +18, self.blackV.width - 20, 40)];
        confirmBt.backgroundColor = [UIColor colorWithRed:147/255.0 green:91/255.0 blue:24/255.0 alpha:1.0];
        confirmBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBt.layer.cornerRadius = 5;
        confirmBt.clipsToBounds = YES;
        [self.blackV addSubview:confirmBt];
        [confirmBt addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBt setTitle:@"确定" forState:UIControlStateNormal];
        
        if (language==1) {
            [confirmBt setTitle:@"Confirm" forState:UIControlStateNormal];
        }
        
        

    }
    
    
    return  self ;
}

//选择时间
- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"yyyy年 MM月 dd日";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    

}

- (void)setModel:(clcokModel *)model {
    _model = model;
    if (model == nil) {
        [self.datePicker setDate:[NSDate date]];
        self.timeLB.text = @"永不 >";
        NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
               
        if (language == 1) {
            self.timeLB.text = @"never >";
        }
        
    }else {
        if (self.model.date != nil) {
            [self.datePicker setDate:model.date];
            self.dataArray = model.timeArr;
        }
        
       
    }

}


//点击确定
- (void)confirmAction:(UIButton *)button {
    
    
    NSLog(@"\n===%@",self.datePicker.date);
   


       NSDate *now = self.datePicker.date;
       NSLog(@"now date is: %@", now);
       
       NSCalendar *calendar = [NSCalendar currentCalendar];
       NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
       NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
       
//       int year =(int) [dateComponent year];
//       int month = (int) [dateComponent month];
//       int day = (int) [dateComponent day];
//       int hour = (int) [dateComponent hour];
//       int minute = (int) [dateComponent minute];
//       int second = (int) [dateComponent second];
    
    
    NSInteger year = [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    clcokModel * model = [[clcokModel alloc] init];
    model.time = [NSString stringWithFormat:@"%d:%d:%d",hour,minute,0];
    model.timeArr = self.dataArray;
    model.isOpen = self.switchBt.on;
    model.date = self.datePicker.date;
    
    NSLog(@"===%d",[zkSignleTool shareTool].macKey != nil);
    NSLog(@"----===%@",[zkSignleTool shareTool].macKey);
    if ([zkSignleTool shareTool].macKey.length > 0) {
       [[zkSignleTool shareTool] setDataModel:model withKey:[zkSignleTool shareTool].macKey];
       
        
        if (self.clickConfirmBlock != nil) {
            self.clickConfirmBlock(model);
        }
        [self diss];
        
    }else {
        
        NSString * str1 = @"设备断开无法添加闹钟";
        NSString * str2 = @"确定";
         NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
        if (language==1) {
            str2  = @"confirm";
            str1 = @"Device disconnected unable to add alarm";
            }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:str2 style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:action];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        [self diss];
        
    }
    

    
     NSLog(@"%@",@"123");
}


//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return NO;
}

- (void)timeChooseAction:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)chooseAction {
    [self addSubview:self.blackTwoView];
    
    [self setButtonSelctWithArr:self.dataArray];
}

- (void)setButtonSelctWithArr:(NSArray *)arr {
    
    for (int i = 0 ; i < 7; i++) {
         UIButton * button = [self.blackTwoView viewWithTag:100+i];
        if ([arr containsObject:@(i)]) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
       }
    
    
}

//点击返回按钮
- (void)backAction {
    NSMutableArray * arr = @[].mutableCopy;
    for (int i = 0 ; i < 7; i++) {
        UIButton * button = [self.blackTwoView viewWithTag:100+i];
        if (button.selected) {
            [arr addObject:@(i)];
        }
    }
    self.dataArray = arr;
    [self setTimeWithArr:self.dataArray];
    [self.blackTwoView removeFromSuperview];
    
}


- (void)setTimeWithArr:(NSArray *)arr {
    
    NSArray * arrTwo = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    if (language == 1) {
        arrTwo = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    }
    NSMutableArray * arrThree = @[].mutableCopy;
    if (arr.count == 0) {
        self.timeLB.text = @"永不 >";
        if (language == 1) {
            self.timeLB.text = @"never >";
        }
    }else if (arr.count == 7){
       self.timeLB.text = @"每天 >";
        if (language == 1) {
            self.timeLB.text = @"everyday >";
        }
    }else {
        for (int i = 0 ; i < arr.count; i++) {
              [arrThree addObject:arrTwo[[arr[i] intValue]]];
            }
        self.timeLB.text = [NSString stringWithFormat:@"%@ >",[arrThree componentsJoinedByString:@","]];
    }
    
    
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self setTimeWithArr:dataArray];
    
    
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
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
