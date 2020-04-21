//
//  zkSignleTool.h
//  BYXuNiPan
//
//  Created by kunzhang on 2018/7/5.
//  Copyright © 2018年 kunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class clcokModel;

@interface zkSignleTool : NSObject

+ (zkSignleTool *)shareTool;
- (void)setDataModel:(clcokModel *)clcokModel withKey:(NSString *)key;
- (clcokModel *)getDataModelWithKey:(NSString *)key;

- (BOOL)isOkWithModel:(clcokModel *)model;

- (NSInteger)getWeekDayFordate;
/**  */
@property(nonatomic , strong)NSString *macKey;

@end


@interface clcokModel : NSObject

@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSArray *timeArr;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)NSDate *date;

@end
