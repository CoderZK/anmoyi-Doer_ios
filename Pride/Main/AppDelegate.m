//
//  AppDelegate.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LanguageSettingViewController.h"
#import "BabyBluetooth.h"
#import "zkSignleTool.h"
#import "ClcokShowView.h"
#import "define.h"
#import "Crash.h"
#import "FangZhiCrachVC.h"

@interface AppDelegate ()

@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)NSTimer *tiemer,*timerOne,*TTTT;
@property(nonatomic,strong)ClcokShowView *clockShowView;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@end

@implementation AppDelegate

//- (ClcokShowView *)clockShowView {
//    if (_clockShowView == nil) {
//        _clockShowView = [[ClcokShowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    }
//    return _clockShowView;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZFBPAY:) name:@"ClossClock" object:nil];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"opened"]) {
        NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
        MainViewController *mainVC = [[MainViewController alloc]initWithLanguage:language];
        self.window.rootViewController = mainVC;
        
    }else{
        LanguageSettingViewController *languageVC = [[LanguageSettingViewController alloc]init];
        self.window.rootViewController = languageVC;
        
    }
    
    [self.window makeKeyAndVisible];
    
    [zkSignleTool shareTool].macKey = @"123456";
    
//    NSArray * arr = @[@""];
//    NSLog(@"%@",arr[1]);

    
    
//    //注册消息处理函数的处理方法
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
//    // 发送崩溃日志
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
//
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
//
//    NSString *content=[NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
//
//    NSLog(@"\n\n\n---%@",content);
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (data != nil) {
//
//               [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[FangZhiCrachVC alloc] init] animated:YES completion:nil];
//
//           }
//    });

    // Override point for customization after application launch.
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //让 app 支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    NSError * error;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:(AVAudioSessionPortOverrideSpeaker) error:&error];;
    
    //播放背景音乐
    NSString *musicPath=[[NSBundle mainBundle] pathForResource:@"ppppp" ofType:@"wav"];
    NSURL *url=[[NSURL alloc]initFileURLWithPath:musicPath];
    //创建播放器
    AVAudioPlayer *audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [audioPlayer prepareToPlay];
    self.avPlayer = audioPlayer;
    //无限循环播放
    audioPlayer.numberOfLoops=-1;
    audioPlayer.volume = 1;
    //        [audioPlayer play];
    
    self.isClocking = NO;
    self.number = 0;
    self.timerOne =  [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(printCurrentTime:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerOne  forMode:NSRunLoopCommonModes];
    
    
    
    return YES;
}

- (void)ZFBPAY:(NSNotificationCenter *)notic {
    
    self.number = 31;
    
    
}

-(void)printCurrentTimeTwo:(id)sender{
    
    self.number++;
    
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSString *tiemStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,self.number];
    self.clockShowView.timeStr = tiemStr;
    
    
    
    
}

-(void)printCurrentTime:(id)sender{
    //    NSLog(@"当前的时间是---%@---",[self getCurrentTime]);
    
    clcokModel * model = nil;
    
    if ([zkSignleTool shareTool].macKey.length > 0) {
        model =  [[zkSignleTool shareTool] getDataModelWithKey:[zkSignleTool shareTool].macKey];
    }
    
    NSLog(@"==\n%d--%@---%@",model.isOpen,model.time,model.timeArr);
    
    
    if (self.number >=30) {
        
        NSLog(@"\n\n-----++++%@",@"播放无声音频");
        
        self.isClocking = NO;
        NSString *musicPath=[[NSBundle mainBundle] pathForResource:@"ppppp" ofType:@"wav"];
        NSURL *url=[[NSURL alloc]initFileURLWithPath:musicPath];
        self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [self.avPlayer play];
        
        [self.tiemer invalidate];
        self.tiemer = nil;
        
        [self.clockShowView diss];
        if (self.number == 30) {
            //发送蓝牙事件
            NSLog(@"%@",@"触发蓝牙事件");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wakeUp" object:nil];
        }
        self.isClocking = NO;
        self.number = 0;
        
    }else {
        
        if (model != nil && [[zkSignleTool shareTool] isOkWithModel:model] ) {
            //触发播放声音
            if (self.isClocking == NO) {
                
                NSLog(@"\n\n-----%@",@"播放声音");
                self.clockShowView =  [[ClcokShowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [self.clockShowView show];
                __weak typeof(self) weakSelf = self;
                self.clockShowView.clossClcokBlock = ^{
                    weakSelf.number = 31;
                    [weakSelf.clockShowView diss];
                };
                
                NSString *musicPath=[[NSBundle mainBundle] pathForResource:@"TTTTT" ofType:@"mp3"];
                NSURL *url=[[NSURL alloc]initFileURLWithPath:musicPath];
                self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                [self.avPlayer play];
                self.isClocking = YES;
                self.tiemer =  [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(printCurrentTimeTwo:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_tiemer  forMode:NSRunLoopCommonModes];
                
            }
            
        }
        
    }
    
    
    
    
    
    
    
    //    if (model != nil && [[zkSignleTool shareTool] isOkWithModel:model] && self.number < 30) {
    //
    //        NSLog(@"\n--------%@",@"成功");
    //
    //
    //
    //        NSString *musicPath=[[NSBundle mainBundle] pathForResource:@"TTTTT" ofType:@"mp3"];
    //        NSURL *url=[[NSURL alloc]initFileURLWithPath:musicPath];
    //        if ([self.avPlayer isPlaying] && ![self.avPlayer.url isEqual:url] && self.isClocking == NO) {
    //            self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //            [self.avPlayer play];
    //        }
    //        self.isClocking = YES;
    //        self.number++;
    //
    //    }else {
    //        self.number = 0;
    //
    //         NSLog(@"\n--------%@",@"失败");
    //
    //        NSString *musicPath=[[NSBundle mainBundle] pathForResource:@"ppppp" ofType:@"wav"];
    //        NSURL *url=[[NSURL alloc]initFileURLWithPath:musicPath];
    //        if ([self.avPlayer isPlaying] && ![self.avPlayer.url isEqual:url] && self.isClocking == NO) {
    //            self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //            [self.avPlayer play];
    //        }
    //    }
    
}
-(NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
    NSString *dateTime=[dateFormatter stringFromDate:[NSDate date]];
    //    self.startTime=dateTime;
    return dateTime;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //    [[BabyBluetooth shareBabyBluetooth] cancelAllPeripheralsConnection];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoBackground" object:nil];
    
    [ self comeToBackgroundMode];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}




-(void)comeToBackgroundMode{
    //初始化一个后台任务BackgroundTask，这个后台任务的作用就是告诉系统当前app在后台有任务处理，需要时间
    UIApplication*  app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    //开启定时器 不断向系统请求后台任务执行的时间
    self.TTTT = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
    [self.TTTT fire];
}

-(void)applyForMoreTime {
    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 60) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            self.bgTask = UIBackgroundTaskInvalid;
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backToMain" object:nil];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[BabyBluetooth shareBabyBluetooth] cancelAllPeripheralsConnection];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
