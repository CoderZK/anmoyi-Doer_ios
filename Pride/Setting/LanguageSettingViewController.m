//
//  LanguageSettingViewController.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "LanguageSettingViewController.h"
#import "define.h"
#import "MainViewController.h"
#import "Crash.h"
#import "FangZhiCrachVC.h"

@interface LanguageSettingViewController ()

@property(nonatomic,strong)UIImageView *chineseSelection;


@property(nonatomic,strong)UIImageView *englishSelection;


@property(nonatomic,strong)UILabel *chineseLabel;

@property(nonatomic,strong)UILabel *englishLabel;

@end

@implementation LanguageSettingViewController

#pragma mark --  lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:imageView];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    [headImageView sizeToFit];
    headImageView.image = [UIImage imageNamed:@"logo"];
    headImageView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 29);
    [self.view addSubview:headImageView];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat height = 45;
    self.chineseSelection = [[UIImageView alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT *0.75 - height, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 78 / 612)];
    self.chineseSelection.image = [UIImage imageNamed:@"SelecBG"] ;
    self.chineseSelection.userInteractionEnabled = YES;
    UITapGestureRecognizer *chineseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectChinese)];
    [self.chineseSelection addGestureRecognizer:chineseTap];
    [self.view addSubview:self.chineseSelection];
    
    self.englishSelection = [[UIImageView alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT *0.75+10 , SCREEN_WIDTH - 40, (SCREEN_WIDTH - 40) * 78 / 612 )];
    self.englishSelection.image = [UIImage imageNamed:@"UnSelecBG"];
    self.englishSelection.userInteractionEnabled = YES;
    UITapGestureRecognizer *englishTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectEnglish)];
    [self.englishSelection addGestureRecognizer:englishTap];
    [self.view addSubview:self.englishSelection];
    
    self.chineseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, height)];
    self.chineseLabel.backgroundColor = [UIColor clearColor];
    self.chineseLabel.textColor = [UIColor whiteColor];
    self.chineseLabel.textAlignment = NSTextAlignmentCenter;
    self.chineseLabel.text = @"中文";
    [self.chineseSelection addSubview:self.chineseLabel];
    
    self.englishLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, height)];
    self.englishLabel.backgroundColor = [UIColor clearColor];
    self.englishLabel.textColor = BTN_COLOR;
    self.englishLabel.textAlignment = NSTextAlignmentCenter;
    self.englishLabel.text = @"English";
    [self.englishSelection addSubview:self.englishLabel];
    
    
    
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --  private

-(void)selectChinese{
    self.chineseSelection.image = [UIImage imageNamed:@"SelecBG"];
    self.englishSelection.image = [UIImage imageNamed:@"UnSelecBG"];
    self.englishLabel.textColor = BTN_COLOR;
    self.chineseLabel.textColor = [UIColor whiteColor];
    [self showAlertTitle:@"提示" message:@"使用中文?" language:0];
}


-(void)selectEnglish{
    self.chineseSelection.image = [UIImage imageNamed:@"UnSelecBG"];
    self.englishSelection.image = [UIImage imageNamed:@"SelecBG"];
    self.englishLabel.textColor = [UIColor whiteColor];
    self.chineseLabel.textColor = BTN_COLOR;
    [self showAlertTitle:@"Tint" message:@"Use English?" language:1];

}

-(void)showAlertTitle:(NSString *)title message:(NSString *)message language:(NSInteger) language{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:language==0?@"确定":@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults]setInteger:language forKey:@"language"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"opened"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"languageUpdate" object:nil];
        
        MainViewController *mainVC = [[MainViewController alloc] initWithLanguage:language];
   
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
        });
        
    }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:language==0?@"取消":@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //注册消息处理函数的处理方法
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        // 发送崩溃日志
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
        
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        
        NSString *content=[NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
        
        NSLog(@"\n\n\n---%@",content);
        if (data != nil) {
                   
            [self presentViewController:[[FangZhiCrachVC alloc] init] animated:YES completion:nil];
                   
        }
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}



@end
