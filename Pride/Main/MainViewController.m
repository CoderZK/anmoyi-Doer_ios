//
//  MainViewController.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/9/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceListViewController.h"
#import "define.h"
#import "SettingViewController.h"
#import "StoreViewController.h"
#import "MPPeripheralListViewController.h"
#import "BBViewController.h"

@interface MainViewController ()

@property(nonatomic,strong)UIView *tabbarView;

@property(nonatomic,strong)UIImageView *storeBtn;

@property(nonatomic,strong)UILabel *storeLabel;

@property(nonatomic,strong)UIImageView *indexBtn;

@property(nonatomic,strong)UILabel *indexLabel;

@property(nonatomic,strong)UIImageView *settingBtn;

@property(nonatomic,strong)UILabel *settingLabel;

@end

@implementation MainViewController

- (instancetype)initWithLanguage:(NSInteger )language
{
    _language = language;
    self = [super init];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLanguage) name:@"languageUpdate" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.hidden = YES;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.tabBar setClipsToBounds:YES];


    [self setUpUI];
    self.selectedIndex = 1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --   private

-(void)updateLanguage{
    NSInteger language = [[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
    self.storeLabel.text = language == 0?@"商城":@"Store";
    self.settingLabel.text = language == 0?@"设置":@"Setting";
    self.indexLabel.text = language == 0?@"主页":@"Home";

}

-(void)setUpUI{
    
    //tabbar
    CGFloat tabbarHeight = 60;
    self.tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - tabbarHeight, SCREEN_WIDTH, tabbarHeight)];
    if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
         self.tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - tabbarHeight-34, SCREEN_WIDTH, tabbarHeight)];
    }
    self.tabbarView.backgroundColor = COLOR_RGB(41, 42, 43);
    [self.view addSubview:self.tabbarView];
    
    
    CGFloat indexBtnBorder = 50;
    
    CGFloat btnBorder = 26;
    self.storeBtn = [[UIImageView alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH - indexBtnBorder) *0.5 - btnBorder)*0.5, (tabbarHeight - btnBorder - 10) *0.5, btnBorder, btnBorder)];
    self.storeBtn.image = [UIImage imageNamed:@"store_unselec"];
    [self.tabbarView addSubview:self.storeBtn];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH - indexBtnBorder) *0.5 - 40)*0.5, (tabbarHeight - 50) *0.5, 40, 40)];
    [leftBtn addTarget:self action:@selector(tapLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.tabbarView addSubview:leftBtn];
    
    self.storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH - indexBtnBorder) *0.5 - btnBorder)*0.5, tabbarHeight - 15, btnBorder, 10)];
    self.storeLabel.font = [UIFont systemFontOfSize:10];
    self.storeLabel.textColor = [UIColor lightGrayColor];
    self.storeLabel.text = _language == 0?@"商城":@"Store";
    self.storeLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabbarView addSubview:self.storeLabel];
    
    self.settingBtn = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.75 - btnBorder *0.5 + indexBtnBorder *0.25, (tabbarHeight - btnBorder - 10) *0.5, btnBorder, btnBorder)];
    self.settingBtn.image = [UIImage imageNamed:@"set_unselec"];
    [self.tabbarView addSubview:self.settingBtn];
    
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.75 - btnBorder *0.5 + indexBtnBorder *0.25, (tabbarHeight - 50) *0.5, 40, 40)];
    [rightBtn addTarget:self action:@selector(tapRight) forControlEvents:UIControlEventTouchUpInside];
    [self.tabbarView addSubview:rightBtn];
    
    self.settingLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.75 - btnBorder *0.5 + indexBtnBorder *0.25 -5, tabbarHeight - 15, btnBorder+10, 10)];
    self.settingLabel.font = [UIFont systemFontOfSize:10];
    self.settingLabel.textColor = [UIColor lightGrayColor];
    self.settingLabel.text = _language == 0?@"设置":@"Setting";
    self.settingLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabbarView addSubview:self.settingLabel];
    
    UIView *radiusView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - indexBtnBorder)*0.5-3, - 0.35 *indexBtnBorder - 3, indexBtnBorder+6, indexBtnBorder+6)];
    radiusView.backgroundColor = self.tabbarView.backgroundColor;
    radiusView.clipsToBounds = YES;
    radiusView.layer.cornerRadius = 0.5 *indexBtnBorder +3;
    radiusView.layer.masksToBounds = YES;
    [self.tabbarView addSubview:radiusView];
    
    self.indexBtn = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - indexBtnBorder)*0.5, - 0.35 *indexBtnBorder, indexBtnBorder, indexBtnBorder)];
    self.indexBtn.image = [UIImage imageNamed:@"main_selec"];
    self.indexBtn.clipsToBounds = YES;
    self.indexBtn.layer.cornerRadius = 0.25 *btnBorder;
    self.indexBtn.layer.masksToBounds = YES;
    [self.tabbarView addSubview:self.indexBtn];
    
    UIButton *middleBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - indexBtnBorder - 10)*0.5, - 0.35 *indexBtnBorder, indexBtnBorder+10, indexBtnBorder+10)];
    [middleBtn addTarget:self action:@selector(tapMiddle) forControlEvents:UIControlEventTouchUpInside];
    [self.tabbarView addSubview:middleBtn];
    
    
    self.indexLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - indexBtnBorder)*0.5, tabbarHeight - 20, indexBtnBorder, 10)];
    self.indexLabel.font = [UIFont systemFontOfSize:10];
    self.indexLabel.textColor = BTN_COLOR;
    self.indexLabel.text = _language == 0?@"主页":@"Home";
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabbarView addSubview:self.indexLabel];
    
    
    //viewControllers
    StoreViewController *storeVC= [[StoreViewController alloc]initWithLanguage:_language];
    UINavigationController *storeNC = [[UINavigationController alloc]initWithRootViewController:storeVC];
    [storeNC setNavigationBarHidden:NO animated:YES];
    
    SettingViewController *settingVC = [[SettingViewController alloc]initWithLanguage:_language];
    UINavigationController *settingNC = [[UINavigationController alloc]initWithRootViewController:settingVC];
    [settingNC setNavigationBarHidden:NO animated:YES];
//
//    DeviceListViewController *deviceVC = [[DeviceListViewController alloc]initWithLanguage:_language];
//    MPPeripheralListViewController *deviceVC = [[MPPeripheralListViewController alloc]initWithLanguage:_language];
    BBViewController *deviceVC = [[BBViewController alloc]init];
//    BBDeviceListController *deviceVC = [[BBDeviceListController alloc]init];
    
    UINavigationController *deviceNC = [[UINavigationController alloc]initWithRootViewController:deviceVC];
    [deviceNC setNavigationBarHidden:YES animated:YES];

    
    self.viewControllers = @[storeNC,deviceNC,settingNC];
    
   
    
}



-(void)tapLeft{
    self.selectedIndex = 0;
    self.storeBtn.image = [UIImage imageNamed:@"store_selec"];
    self.settingBtn.image = [UIImage imageNamed:@"set_unselec"];
    self.indexBtn.image = [UIImage imageNamed:@"main_unselec"];
    self.storeLabel.textColor = BTN_COLOR;
    self.settingLabel.textColor = [UIColor lightGrayColor];
    self.indexLabel.textColor = [UIColor lightGrayColor];

}


-(void)tapMiddle{
    self.selectedIndex = 1;
    self.storeBtn.image = [UIImage imageNamed:@"store_unselec"];
    self.settingBtn.image = [UIImage imageNamed:@"set_unselec"];
    self.indexBtn.image = [UIImage imageNamed:@"main_selec"];
    self.storeLabel.textColor = [UIColor lightGrayColor];
    self.settingLabel.textColor = [UIColor lightGrayColor];
    self.indexLabel.textColor = BTN_COLOR;
    
    
    UINavigationController *deviceVC = self.viewControllers[1];
    [deviceVC popToRootViewControllerAnimated:YES];
}


-(void)tapRight{
    self.selectedIndex = 2;
    self.storeBtn.image = [UIImage imageNamed:@"store_unselec"];
    self.settingBtn.image = [UIImage imageNamed:@"set_selec"];
    self.indexBtn.image = [UIImage imageNamed:@"main_unselec"];
    self.storeLabel.textColor = [UIColor lightGrayColor];
    self.settingLabel.textColor = BTN_COLOR;
    self.indexLabel.textColor = [UIColor lightGrayColor];
}

@end
