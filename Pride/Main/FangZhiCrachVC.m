//
//  FangZhiCrachVC.m
//  FangZhiAPP
//
//  Created by zk on 2019/7/1.
//  Copyright © 2019 张坤. All rights reserved.
//

#import "FangZhiCrachVC.h"

@interface FangZhiCrachVC ()
@property (weak, nonatomic) IBOutlet UITextView *TV;

@end

@implementation FangZhiCrachVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
    
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    NSString *content=[NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    
    self.TV.text = content;
    
    
}
- (IBAction)fuzhi:(id)sender {
    
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = self.TV.text;
    
}
- (IBAction)delete:(id)sender {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dataPath]) {
        
        BOOL isSuccess = [fileManager removeItemAtPath:dataPath error:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
