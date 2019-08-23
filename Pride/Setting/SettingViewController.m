//
//  SettingViewController.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/12/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "SettingViewController.h"
#import "LanguageSettingViewController.h"
#import "define.h"
#import "FunctionDescC.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibFunctionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibLanuageLabel;
@end

@implementation SettingViewController

- (instancetype)initWithLanguage:(Language)language
{
    self = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    if (self) {
        self.language = language;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLanguage) name:@"languageUpdate"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLanguage];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)updateLanguage {
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    self.title = _language == 0?@"设置":@"Setting";
    [self setLanguage:language];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ibaShowFunctionDesc:(id)sender {
    FunctionDescC *con = [[FunctionDescC alloc]
                          initWithNibName:@"FunctionDescC" bundle:nil];
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)ibaChangeLanauage:(id)sender {
    LanguageSettingViewController *languageVC = [[LanguageSettingViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = languageVC;
}

- (void)setLanguage:(Language)language {
    _language = language;
    self.ibLanuageLabel.text = _language == 0?@"设置语言":@"Choose language";
    self.ibFunctionLabel.text = _language==0?@"关于我们":@"About Us";

}

@end
