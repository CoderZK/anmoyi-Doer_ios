//
//  FunctionDescC.m
//  Pride
//
//  Created by 蒋宇 on 2018/2/18.
//  Copyright © 2018年 gfound. All rights reserved.
//

#import "FunctionDescC.h"

@interface FunctionDescC ()
@property (weak, nonatomic) IBOutlet UILabel *ibAboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibCopyRightLabel;

@end

@implementation FunctionDescC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];

    if (language == 0) {
        self.ibAboutLabel.text = @"关于左右智能";
        self.ibVersionLabel.text = @"版本v1.0.1";
        self.ibCopyRightLabel.text = @"左右智能 版权所有";
    } else {
        self.ibAboutLabel.text = @"ABOUT ZUOYOU";
        self.ibVersionLabel.text = @"Rev v1.0.1";
        self.ibCopyRightLabel.text = @"Copyright@2020 ZUOYOU. All Rights Reserverd.";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ibaBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
