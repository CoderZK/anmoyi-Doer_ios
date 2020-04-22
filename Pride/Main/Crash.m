//
//  Crash.m
//  ShareGoGo3
//
//  Created by kunzhang on 2017/9/14.
//  Copyright © 2017年 kunzhang. All rights reserved.
//

#import "Crash.h"


//崩溃的时候
@implementation Crash
void uncaughtExceptionHandler(NSException *exception){
    

    NSArray *stackArry= [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception name:%@\nException reatoin:%@\nException stack :%@",name,reason,stackArry];
    
    NSLog(@"%@",exceptionInfo);
    
    NSError * error = nil;
    
    //保存到本地沙盒中
    
    NSString * file = [NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()] ;
    
    [exceptionInfo writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        NSLog(@"%@",@"写入崩溃日志成功");

    }else {
        NSLog(@"\n---%d",error.code);
        NSLog(@"\n===%@",error.description);


    }
    
    
    
}

@end
