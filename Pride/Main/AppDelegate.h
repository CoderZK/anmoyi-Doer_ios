//
//  AppDelegate.h
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)AVAudioPlayer *avPlayer;

@property(nonatomic,assign)BOOL isClocking;

@end

