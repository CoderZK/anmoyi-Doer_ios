//
//  Crash.h
//  ShareGoGo3
//
//  Created by kunzhang on 2017/9/14.
//  Copyright © 2017年 kunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crash : NSObject
void uncaughtExceptionHandler(NSException *exception);
@end
