//
//  StoreViewController.m
//  iCare_LIYASI
//
//  Created by Zyh on 2017/12/11.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "StoreViewController.h"
#import <WebKit/WebKit.h>

@interface StoreViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation StoreViewController

- (instancetype)initWithLanguage:(sLanguage)language
{
    self = [super init];
    if (self) {
        _language = language;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _language == 0?@"商城":@"Store";
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:imageView];
    
//    [self showLabel];
//    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

- (void)setUpUI {
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnczdf.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showLabel{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2 - 20, [UIScreen mainScreen].bounds.size.width, 40)];
    label.text = _language == 0?@"开发中...":@"Developing...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}



@end
