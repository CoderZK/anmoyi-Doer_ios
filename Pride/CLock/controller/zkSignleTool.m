//
//  zkSignleTool.m
//  BYXuNiPan
//
//  Created by kunzhang on 2018/7/5.
//  Copyright © 2018年 kunzhang. All rights reserved.
//

#import "zkSignleTool.h"
static zkSignleTool * tool = nil;


@implementation zkSignleTool

+ (zkSignleTool *)shareTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[zkSignleTool alloc] init];
    });
    return tool;
}

- (void)setMacKey:(NSString *)macKey {
    [[NSUserDefaults  standardUserDefaults] setObject:macKey forKey:@"macKey"];
    [[NSUserDefaults  standardUserDefaults] synchronize];
}


- (NSString *)macKey {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"macKey"] == nil ) {
        return @"";
    }else {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"macKey"];
    }
    
  
}

//- (void)setUserModel:(QYZJUserModel *)userModel {
//    if (userModel) {
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
//        if (data) {
//            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userModel"];
//        }
//    }
//}
//- (QYZJUserModel *)userModel{
//    //取出
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
//    if (data) {
//        QYZJUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        return model;
//    }
//    return nil;
//
//}

- (void)setDataModel:(clcokModel *)clcokModel withKey:(NSString *)key {
    
    if (clcokModel){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:clcokModel];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        }
    }
    
    
}

- (clcokModel *)getDataModelWithKey:(NSString *)key {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data) {
        clcokModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    }
    return nil;
}

- (BOOL)isOkWithModel:(clcokModel *)model {
    BOOL isOK = NO;
    if (model.isOpen == NO) {
        return NO;
    }
    if (model.timeArr.count == 0) {
        return NO;
    }
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
    NSString * str = [NSString stringWithFormat:@"%d:%d:%d",hour,minute,second];
    
    NSLog(@"=======\n---%d   && %@ &&%@",second,model.time,str);
    
    
    
    if (![model.time isEqualToString:str]) {
        return NO;
    }
    NSInteger week = [self getWeekDayFordate];
    if ([model.time isEqualToString:str] && [model.timeArr containsObject:@(week)]) {
        return YES;
    }
    return isOK;
    
}


- (NSInteger)getWeekDayFordate

{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *now = [NSDate date];
    
    // 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    comps = [calendar components:unitFlags fromDate:now];
    
    return [comps weekday] - 1;
    
}




@end


@implementation clcokModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (self.time) {
        [aCoder encodeObject:self.time forKey:@"time"];
    }
    if (self.timeArr) {
        [aCoder encodeObject:self.timeArr forKey:@"timeArr"];
    }
    if (self.isOpen) {
        [aCoder encodeBool:self.isOpen forKey:@"isOpen"];
    }
    if (self.date) {
        [aCoder encodeObject:self.date forKey:@"date"];
    }
//    if (self.token) {
//        [aCoder encodeObject:self.token forKey:@"token"];
//    }
//    if (self.role) {
//        [aCoder encodeObject:self.role forKey:@"role"];
//    }
//    if (self.isSetPayPass) {
//        [aCoder encodeObject:self.isSetPayPass forKey:@"isSetPayPass"];
//    }
//    if (self.app_openid) {
//        [aCoder encodeObject:self.app_openid forKey:@"app_openid"];
//    }
//    if (self.telphone) {
//        [aCoder encodeObject:self.telphone forKey:@"telphone"];
//    }
}

//解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.timeArr = [aDecoder decodeObjectForKey:@"timeArr"];
        self.isOpen = [aDecoder decodeBoolForKey:@"isOpen"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
//        self.token = [aDecoder decodeObjectForKey:@"token"];
//        self.role = [aDecoder decodeObjectForKey:@"role"];
//        self.isSetPayPass = [aDecoder decodeObjectForKey:@"isSetPayPass"];
//        self.app_openid = [aDecoder decodeObjectForKey:@"app_openid"];
//        self.telphone = [aDecoder decodeObjectForKey:@"telphone"];
    }
    return self;
}


@end
