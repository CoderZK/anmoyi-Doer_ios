//
//  DeviceViewController.m
//  JakBlueTooth
//
//  Created by Zyh on 2017/9/5.
//  Copyright © 2017年 Gfound. All rights reserved.
//

#import "DeviceViewController.h"
#import "define.h"
#import "RKDropdownAlert.h"
#import "SendDataTool.h"
#import "BabyBluetooth.h"
#import "MBProgressHUD.h"
#import "UIView+BSExtension.h"

@interface DeviceViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIImageView * gear1ImageView;

@property(nonatomic,strong)UIImageView * gear2ImageView;

@property(nonatomic,strong)UIImageView * gear3ImageView;

@property (nonatomic, strong) UIButton *resetButton;
@property(nonatomic,strong)UIImageView *mem1Btn;

@property(nonatomic,strong)UIImageView *mem2Btn;


@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)NSTimer *timer;

@property (nonatomic, strong) UILabel *stateLabel;


@property(nonatomic,strong)UIButton *editBt;//编辑按钮
@property(nonatomic,strong)UILabel *titleLB;//编辑后的名字
@end

@implementation DeviceViewController
{
    BOOL isLightUp;
//    UIImage *sel_image;
//    UIImage *unsel_image;
    
    BOOL hideMemoryReset;
    BOOL hideMemoryOne;
    BOOL hideMemoryTwo;
    
}
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic DeviceType:(DeviceType)deviceType language:(NSInteger)language
{
    self.deviceType = deviceType;
//    self.deviceType = DeviceType_3_chair;
    self.language = language;
    self = [super init];
    if (self) {
        self.peripheral = peripheral;
        self.characteristic = characteristic;
        isLightUp = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
//    sel_image = [UIImage imageNamed:@"mem_selec"];
//    unsel_image = [UIImage imageNamed:@"mem_unselec"];
    
    [self setUpBaseUI];
    
    [self setUpService];
    
    
    //    [self Test];
    
    switch (self.deviceType) {
        case DeviceType_1_chair:// 一推杆
            [self setUpChair_1_stick];
            break;
        case DeviceType_2_chair://二推杆
            [self setUpChair_2_stick];
            break;
            
        case DeviceType_3_chair://三推杆
            [self setUpChair_3_stick];
            break;
            
        case DeviceType_bed://按摩床
            [self setUpBedUI];
            break;
        
        case DeviceType_1_1_chair:
            hideMemoryReset = YES;
            hideMemoryOne = YES;
            hideMemoryTwo = YES;
            [self setUpChair_1_stick];
            break;
        case DeviceType_2_1_chair:
            hideMemoryReset = YES;
            hideMemoryOne = NO;
            hideMemoryTwo = NO;
            [self setUpChair_2_stick];

            break;
        case DeviceType_3_1_chair:
            hideMemoryReset = YES;
            hideMemoryOne = NO;
            hideMemoryTwo = NO;
            [self setUpChair_3_stick];
            break;
        case DeviceType_unknown://未知
            break;
    }
    
    [self layoutMemoryButtons];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bactToMain) name:@"gotoBackground" object:nil];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[BabyBluetooth shareBabyBluetooth]cancelAllPeripheralsConnection];    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[BabyBluetooth shareBabyBluetooth] AutoReconnectCancel:self.peripheral];
}
//
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}


-(void)bactToMain{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutMemoryButtons {
    if (self.deviceType == DeviceType_1_1_chair) {
        self.resetButton.hidden = YES;
        self.mem1Btn.hidden = YES;
        self.mem2Btn.hidden = YES;
        self.stateLabel.hidden = YES;
    } else if (self.deviceType == DeviceType_2_1_chair) {
        self.resetButton.hidden = NO;
        self.mem1Btn.hidden = YES;
        self.mem2Btn.hidden = YES;
        self.stateLabel.hidden = NO;
        self.resetButton.frame = CGRectMake(SCREEN_WIDTH/2.f - self.resetButton.frame.size.width/2.f,
                                            self.resetButton.frame.origin.y,
                                            self.resetButton.frame.size.width,
                                            self.resetButton.frame.size.height);
    } else if (self.deviceType == DeviceType_3_1_chair) {
        self.resetButton.frame = CGRectMake(SCREEN_WIDTH/2.f - self.resetButton.frame.size.width/2.f,
                                            self.resetButton.frame.origin.y,
                                            self.resetButton.frame.size.width,
                                            self.resetButton.frame.size.height);
        self.resetButton.hidden = NO;
        self.mem1Btn.hidden = YES;
        self.mem2Btn.hidden = YES;
        self.stateLabel.hidden = NO;
    }
}

#pragma mark --  lazy load
-(MBProgressHUD *)hud
{
    if(!_hud){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.label.text = @"已断开连接";
    }
    return _hud;
}



-(void)setUpBaseUI{
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:imageView];
    
    
    UIImageView *titleImageView = [[UIImageView alloc]
                                   initWithImage:[UIImage imageNamed:@"logo"]];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [titleImageView sizeToFit];
    [self.view addSubview:titleImageView];
    titleImageView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, SCREEN_WIDTH, CGRectGetHeight(titleImageView.frame));
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleImageView.frame) + 5 , 10 , 18)];
    self.titleLB.font =[UIFont systemFontOfSize:14];
    self.titleLB.textColor = [UIColor whiteColor];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLB];
    self.titleLB.text = self.prideModel.showName;
    [self.titleLB sizeToFit];
    self.titleLB.height = 18;
    self.titleLB.x = (SCREEN_WIDTH - self.titleLB.width)/2.0 + 13 ;
    
    
    

    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.text = _language==0?@"利亚斯":@"LIYASI";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:titleLabel];
    
    CGFloat aWidth = 25 ;
    CGFloat bWidth = 10;
    CGFloat bottomBtnWidth = (SCREEN_WIDTH - aWidth*4 - bWidth *2)/3;
    
    self.editBt = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - self.titleLB.width )/2.0 - 13 , CGRectGetMaxY(titleImageView.frame) + 5   , 20, 20)];
//    [self.editBt setBackgroundColor:[UIColor redColor]];
//    [self.editBt setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.editBt setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [self.editBt addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editBt];
    
    
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.8 *SCREEN_WIDTH + 70 + 40 , SCREEN_WIDTH, 15)];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.text = _language==0?@"/     预设状态      /":@"/     Default state      /";
    stateLabel.font = [UIFont systemFontOfSize:14];
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:stateLabel];
    self.stateLabel = stateLabel;
    
    if (SCREEN_HEIGHT <= 667) {
        stateLabel.frame = CGRectMake(0, 0.8 *SCREEN_WIDTH + 65 , SCREEN_WIDTH, 15);
//        self.editBt.frame = CGRectMake((SCREEN_WIDTH - 40)/2, 0.8 *SCREEN_WIDTH + 55, 40, 40);
    }else {
        stateLabel.frame = CGRectMake(0, 0.8 *SCREEN_WIDTH + 100  , SCREEN_WIDTH, 15);
//        self.editBt.frame = CGRectMake((SCREEN_WIDTH - 40)/2, 0.8 *SCREEN_WIDTH + 90, 40, 40);
    }
    
    
    UIImageView *leftLayLineView = [[UIImageView alloc]initWithFrame:CGRectMake(bottomBtnWidth + aWidth, 3, 5, 9)];
    leftLayLineView.image = [UIImage imageNamed:@"layline"];
    [stateLabel addSubview:leftLayLineView];
    
    UIImageView *rightLayLineView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - bottomBtnWidth - aWidth, 3, 5, 9)];
    rightLayLineView.image = [UIImage imageNamed:@"layline"];
    [stateLabel addSubview:rightLayLineView];
    
    
    
    
    //初始
    UIButton *homeBtn =[[UIButton alloc]initWithFrame:CGRectMake(aWidth, SCREEN_HEIGHT - 65 - 0.5 * SCREEN_WIDTH * 0.2  - bottomBtnWidth *1.25, bottomBtnWidth, bottomBtnWidth)];
    [homeBtn setBackgroundImage:[self nowMem1Image:NO] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(homeBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [homeBtn addTarget:self action:@selector(homeBtnRelaxed:) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:homeBtn];
    _resetButton = homeBtn;
    
    

//    UILabel *homeBtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.2 * bottomBtnWidth, 1.25 * bottomBtnWidth *18 / 25, 0.6 *bottomBtnWidth, 1.25 * bottomBtnWidth *3 / 25)];
//    homeBtnLabel.tag = 1;
//    homeBtnLabel.textAlignment = NSTextAlignmentCenter;
//    homeBtnLabel.adjustsFontSizeToFitWidth= YES;
//    homeBtnLabel.text =_language == 0?@"初始":@"Home";
//    homeBtnLabel.font= [UIFont systemFontOfSize:9.5];
//    homeBtnLabel.textColor = [UIColor whiteColor];
//    [homeBtn addSubview:homeBtnLabel];
    
//    if (_language == 0) {
//
//        UILabel *homeBtnDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1.25 * bottomBtnWidth *21 / 25, bottomBtnWidth, 1.25 * bottomBtnWidth *3 / 25)];
//        homeBtnDetailLabel.tag = 20;
//        homeBtnDetailLabel.textAlignment = NSTextAlignmentCenter;
//        homeBtnDetailLabel.font= [UIFont systemFontOfSize:9.5];
//        homeBtnDetailLabel.adjustsFontSizeToFitWidth= YES;
//        homeBtnDetailLabel.text = @"Home";
//        homeBtnDetailLabel.textColor = [UIColor whiteColor];
//        [homeBtn addSubview:homeBtnDetailLabel];
//
//    }
    
    [self setUpMemoryBtn];
}

- (void)editAction:(UIButton *)button {
    
    NSString * str1 = self.language == 0 ? @"请修改设备显示名称":@"please modify the device display name";
    NSString * str2 = self.language == 0 ? @"确定":@"confirm";
    NSString * str3 = self.language == 0 ? @"取消":@"cancel";
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str1 preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:str3 style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:str2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * userNameTextField = alertController.textFields.firstObject;
        self.titleLB.text = userNameTextField.text;
        [[NSUserDefaults standardUserDefaults] setObject:userNameTextField.text forKey:[NSString stringWithFormat:@"%ld%@",(long)self.language,self.prideModel.mac]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
        textField.placeholder=str1;

        
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)setUpMemoryBtn{
    
    CGFloat aWidth = 25 ;
    CGFloat bWidth = 10;
    CGFloat bottomBtnWidth = (SCREEN_WIDTH - aWidth*4 - bWidth *2)/3;
    
    self.mem1Btn=[[UIImageView alloc]initWithFrame:CGRectMake(2*aWidth + bottomBtnWidth + bWidth, SCREEN_HEIGHT - 65 - 0.5 * SCREEN_WIDTH * 0.2  - bottomBtnWidth *1.25, bottomBtnWidth, bottomBtnWidth)];
//    [self.mem1Btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];
    self.mem1Btn.image = [self nowMem2Image:NO];
    self.mem1Btn.userInteractionEnabled = YES;
    [self.view addSubview:self.mem1Btn];
    self.mem1Btn.contentMode = UIViewContentModeScaleAspectFit;
    
//    UILabel *mem1BtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.28 * bottomBtnWidth, 1.25 * bottomBtnWidth *18 / 25, 0.44 *bottomBtnWidth, 1.25 * bottomBtnWidth *3 / 25)];
//    mem1BtnLabel.textAlignment = NSTextAlignmentCenter;
//    mem1BtnLabel.font= [UIFont systemFontOfSize:9.5];
//    mem1BtnLabel.adjustsFontSizeToFitWidth= YES;
//    mem1BtnLabel.text = _language == 0?@"记忆一":@"Memory 1";
//    mem1BtnLabel.textColor = [UIColor whiteColor];
//    [self.mem1Btn addSubview:mem1BtnLabel];
    
    
    self.mem2Btn =[[UIImageView alloc]initWithFrame:CGRectMake(3*aWidth + 2 * bottomBtnWidth + 2 *bWidth, SCREEN_HEIGHT - 65 - 0.5 * SCREEN_WIDTH * 0.2  - bottomBtnWidth *1.25, bottomBtnWidth, bottomBtnWidth)];
//    [self.mem2Btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];
    self.mem2Btn.image = [self nowMem3Image:NO];
    self.mem2Btn.userInteractionEnabled = YES;
    [self.view addSubview:self.mem2Btn];
    self.mem2Btn.contentMode = UIViewContentModeScaleAspectFit;
    
//    UILabel *mem2BtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.28 * bottomBtnWidth, 1.25 * bottomBtnWidth *18 / 25, 0.44 *bottomBtnWidth, 1.25 * bottomBtnWidth *3 / 25)];
//    mem2BtnLabel.textAlignment = NSTextAlignmentCenter;
//    mem2BtnLabel.font= [UIFont systemFontOfSize:9.5];
//    mem2BtnLabel.adjustsFontSizeToFitWidth= YES;
//    mem2BtnLabel.text = _language == 0?@"记忆二":@"Memory 2";
//    mem2BtnLabel.textColor = [UIColor whiteColor];
//    [self.mem2Btn addSubview:mem2BtnLabel];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mem1btntap:)];
    [self.mem1Btn addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mem2btntap:)];
    [self.mem2Btn addGestureRecognizer:tap2];
    
    
    UILongPressGestureRecognizer *longP1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap1Action:)];
    longP1.minimumPressDuration = 1.0f;
    longP1.delegate = self;
    [self.mem1Btn addGestureRecognizer:longP1];
    
    
    UILongPressGestureRecognizer *longP2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap2Action:)];
    longP2.minimumPressDuration = 1.0f;
    longP2.delegate = self;
    [self.mem2Btn addGestureRecognizer:longP2];
}


-(void)setUpService{
    [[BabyBluetooth shareBabyBluetooth] setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [self hud];
        [self.navigationController popViewControllerAnimated:YES];
//        [[[BabyBluetooth shareBabyBluetooth] centralManager] connectPeripheral:self.peripheral options:nil];
    }];
}


-(void)mem1btntap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
//        self.mem1Btn.image = sel_image;
        self.mem1Btn.image = [self nowMem2Image:YES];
//        [self.mem1Btn setImage:[self nowMem2Image:YES] forState:UIControlStateNormal];
        
    }if (tap.state == UIGestureRecognizerStateEnded) {
        [self sendData:BlueToothOrderType_Remember1_On];
        self.mem1Btn.image = [self nowMem2Image:NO];
//        [self.mem1Btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];

    }else if (tap.state == UIGestureRecognizerStateCancelled) {
//        self.mem1Btn.image = unsel_image;
        self.mem1Btn.image = [self nowMem2Image:NO];
//        [self.mem1Btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];
    }
}

-(void)mem2btntap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        self.mem2Btn.image = [self nowMem3Image:YES];
//        [self.mem2Btn setImage:[self nowMem3Image:YES] forState:UIControlStateNormal];

    }if (tap.state == UIGestureRecognizerStateEnded) {
        [self sendData:BlueToothOrderType_Remember2_On];
//        self.mem2Btn.image = unsel_image;
        self.mem2Btn.image = [self nowMem3Image:NO];
//         [self.mem2Btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];
        
    }else if (tap.state == UIGestureRecognizerStateCancelled) {
//        self.mem2Btn.image = unsel_image;
        self.mem2Btn.image = [self nowMem3Image:NO];
//        [self.mem2Btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];

    }else{
    }
    
}

- (void) longTap1Action:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.mem1Btn.image = [self nowMem2Image:NO];
//        [self.mem1Btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];
        [self startTimerSendData1];
        
    }if (longPress.state == UIGestureRecognizerStateEnded) {
        self.mem1Btn.image = [self nowMem2Image:NO];
//        [self.mem1Btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];
        [self stopTimer];
        
    }else if (longPress.state == UIGestureRecognizerStateCancelled) {
        self.mem1Btn.image = [self nowMem2Image:NO];
//        [self.mem1Btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];
        [self stopTimer];
        
    }
    
}

- (void) longTap2Action:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.mem2Btn.image = [self nowMem3Image:NO];
//         [self.mem2Btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];
        [self startTimerSendData2];
        
    }if (longPress.state == UIGestureRecognizerStateEnded) {
        self.mem2Btn.image = [self nowMem3Image:NO];
//        [self.mem2Btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];
        [self stopTimer];
        
    }else if (longPress.state == UIGestureRecognizerStateCancelled) {
        self.mem2Btn.image = [self nowMem3Image:NO];
//        [self.mem2Btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];
        [self stopTimer];
        
    }
    
}


-(void)startTimerSendData1{//三秒后执行
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(longTap1) userInfo:nil repeats:NO];
    
}
-(void)startTimerSendData2{//三秒后执行
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(longTap2) userInfo:nil repeats:NO];
    
}

-(void)longTap1{
    [self sendData:BlueToothOrderType_Remember1_New_Location];
    [RKDropdownAlert title:_language == 0?@"记忆一学习新位置":@"Memory 1 learn" backgroundColor:BTN_COLOR textColor:[UIColor whiteColor]];
//    [self showMemory1Alert];
}


-(void)longTap2{
    [self sendData:BlueToothOrderType_Remember2_New_Location];
    [RKDropdownAlert title:_language == 0?@"记忆二学习新位置":@"Memory 2 learn" backgroundColor:BTN_COLOR textColor:[UIColor whiteColor]];
//    [self showMemory2Alert];
}


-(void)stopTimer{//关闭计时器
    if (_timer) {
        [_timer invalidate];
    }
}

-(void)showMemory1Alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_language == 0?@"记忆一学习新位置":@"Memory 1 learn" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        [alert performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:1.0f];
    }];
    
}

-(void)showMemory2Alert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_language == 0?@"记忆二学习新位置":@"Memory 2 learn" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        [alert performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:1.0f];
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    if ( gestureRecognizer.view == self.mem1Btn) {
        NSLog(@"shouldReceiveTouch");
//        self.mem1Btn.image = sel_image;
        self.mem1Btn.image = [self nowMem2Image:YES];
//        [self.mem1Btn setImage:[self nowMem2Image:YES] forState:UIControlStateNormal];
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            NSLog(@"UIGestureRecognizerStateFailed");
//            self.mem1Btn.image = unsel_image;
        }else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled){
            NSLog(@"UIGestureRecognizerStateCancelled__");
        }
        
        
    }else if ( gestureRecognizer.view == self.mem2Btn){
        self.mem2Btn.image = [self nowMem3Image:YES];
//        [self.mem2Btn setImage:[self nowMem3Image:YES] forState:UIControlStateNormal];
        
        
        
    }
    
    return YES;
}

//允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setUpChair_1_stick {
    CGFloat interval = SCREEN_HEIGHT *2 / 7;
    
    
    for (int i = 0 ; i<1; i++) {
        int upI = 2;
        int downI = 5;
        
        CGFloat left = 18;
        
        if (SCREEN_WIDTH <= 320.f) {
            left = 0;
        }
        
        UIButton *up_btn= [[UIButton alloc]initWithFrame:CGRectMake(left, interval+100, 95, 62)];
        up_btn.tag = i;
        [up_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chair%d",upI]] forState:UIControlStateNormal];
        [self.view addSubview:up_btn];
        
        UIButton *down_btn= [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 95 - left, interval+100, 95, 62)];
        down_btn.tag = i+10;
        [down_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chair%d",downI]] forState:UIControlStateNormal];
        [self.view addSubview:down_btn];
        
        [up_btn addTarget:self action:@selector(chair_1_stick_BtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        [down_btn addTarget:self action:@selector(chair_1_stick_BtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        
    }
    
    UIImageView *chairImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f-70, 0.5 * SCREEN_WIDTH * 0.2 + 100, 140, 162)];
    chairImageView.image = [UIImage imageNamed:@"subchair"];
    [self.view addSubview:chairImageView];
}

-(void)setUpChair_2_stick {
    CGFloat interval = SCREEN_HEIGHT * 2/7;
    
    
    for (int i = 0 ; i<2; i++) {
        int upI = 0;
        if (i == 1){
            upI = 2;
        }
        int downI = upI + 3;
        
        CGFloat left = 18;
        
        if (SCREEN_WIDTH <= 320.f) {
            left = 0;
        }
        
        UIButton *up_btn= [[UIButton alloc]initWithFrame:CGRectMake(left, i*interval+100, 95, 62)];
        up_btn.tag = i;
        [up_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chair%d",upI]] forState:UIControlStateNormal];
        [self.view addSubview:up_btn];
        
        UIButton *down_btn= [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - left - 95, i*interval+100, 95, 62)];
        down_btn.tag = i+10;
        [down_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chair%d",downI]] forState:UIControlStateNormal];
        [self.view addSubview:down_btn];
        
        [up_btn addTarget:self action:@selector(chair_2_stick_BtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        [down_btn addTarget:self action:@selector(chair_2_stick_BtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        
    }
    
    UIImageView *chairImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f-70, 0.5 * SCREEN_WIDTH * 0.2 + 100, 140, 162)];
    chairImageView.image = [UIImage imageNamed:@"subchair"];
    [self.view addSubview:chairImageView];
    
    
}

-(void)setUpChair_3_stick{
    CGFloat interval = SCREEN_HEIGHT / 7;
    
    CGFloat left = 18;
    
    if (SCREEN_WIDTH <= 320.f) {
        left = 0;
    }
    
    for (int i = 0 ; i<3; i++) {
        NSLog(@"%d",i);
        UIButton *up_btn= [[UIButton alloc]initWithFrame:CGRectMake(left, i*interval+100, 95, 62)];
        up_btn.tag = i;
        [up_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chair%d",i]] forState:UIControlStateNormal];
        [self.view addSubview:up_btn];
        
        UIButton *down_btn= [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - left - 95 , i*interval+100, 95, 62)];
        down_btn.tag = i+3;
        [down_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chair%d",i+3]] forState:UIControlStateNormal];
        [self.view addSubview:down_btn];
        
        /*
        if (i == 1) {
            CGFloat labelHeight =0.5 * SCREEN_WIDTH * 0.1;
            UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH *0.2, labelHeight)];
            leftLabel.userInteractionEnabled= YES;
            leftLabel.font = [UIFont systemFontOfSize:labelHeight * 0.7];
            leftLabel.textColor = [UIColor whiteColor];
            leftLabel.adjustsFontSizeToFitWidth = YES;
            leftLabel.textAlignment = NSTextAlignmentCenter;
            leftLabel.text = self.language ==0?@"腰":@"lumbar";
            up_btn.tag = 5-i;
            [up_btn addSubview:leftLabel];
            
            
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH *0.2, labelHeight)];
            rightLabel.userInteractionEnabled = YES;
            rightLabel.font = [UIFont systemFontOfSize:labelHeight * 0.7];
            rightLabel.textColor = [UIColor whiteColor];
            rightLabel.adjustsFontSizeToFitWidth = YES;
            rightLabel.textAlignment = NSTextAlignmentCenter;
            rightLabel.text = self.language ==0?@"腰":@"lumbar";
            down_btn.tag = i;
            [down_btn addSubview:rightLabel];
            
        }
         */
        
        [up_btn addTarget:self action:@selector(massageBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        [down_btn addTarget:self action:@selector(massageBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        
    }
    
    UIImageView *chairImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.f-70, 0.5 * SCREEN_WIDTH * 0.2 + 100, 140, 162)];
    chairImageView.image = [UIImage imageNamed:@"subchair"];
    [self.view addSubview:chairImageView];
    
    
}



-(void)setUpBedUI{
    CGFloat interval = 0.4 * SCREEN_WIDTH - 20;
    
    
    
    CGFloat left = 18;
    
    CGFloat space = (SCREEN_WIDTH - 2 * left - 3 * 91) /2;
    
    if (SCREEN_WIDTH <= 320.f) {
        left = 0;
    }
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *up_btn = [[UIButton alloc]initWithFrame:CGRectMake(left + i * (space + 91), 100, 91, 60)];
        up_btn.tag = i;
        [up_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bed%d",i]] forState:UIControlStateNormal];
        [up_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bed0-%d",i]] forState:UIControlStateHighlighted];
        [self.view addSubview:up_btn];
        
        UIButton *down_btn= [[UIButton alloc]initWithFrame:CGRectMake(left + i * (space + 91), SCREEN_HEIGHT *2/7+100,91, 60)];
        down_btn.tag = i+3;
        [down_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bed%d",i+3]] forState:UIControlStateNormal];
        [down_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bed0-%d",i+3]] forState:UIControlStateHighlighted];
        [self.view addSubview:down_btn];
        
        if (i == 1) {
            CGFloat labelHeight =0.5 * SCREEN_WIDTH * 0.1;
            UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,labelHeight, SCREEN_WIDTH *0.2, labelHeight)];
            leftLabel.userInteractionEnabled= YES;
            leftLabel.font = [UIFont systemFontOfSize:labelHeight * 0.7];
            leftLabel.textColor = [UIColor whiteColor];
            leftLabel.adjustsFontSizeToFitWidth = YES;
            leftLabel.textAlignment = NSTextAlignmentCenter;
            leftLabel.text = self.language ==0?@"关闭":@"Off";
            //            up_btn.tag = 5-i;
            [up_btn addSubview:leftLabel];
            up_btn.hidden = YES;
            
            
//            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,labelHeight, SCREEN_WIDTH *0.2, labelHeight)];
//            rightLabel.userInteractionEnabled = YES;
//            rightLabel.font = [UIFont systemFontOfSize:labelHeight * 0.7];
//            rightLabel.textColor = [UIColor whiteColor];
//            rightLabel.adjustsFontSizeToFitWidth = YES;
//            rightLabel.textAlignment = NSTextAlignmentCenter;
//            rightLabel.text = self.language ==0?@"关灯":@"Light Off";
//            //            down_btn.tag = i;
//            [down_btn addSubview:rightLabel];
            
        }
        [up_btn addTarget:self action:@selector(bedBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        [down_btn addTarget:self action:@selector(bedBtnAction:forEvent:) forControlEvents:UIControlEventAllTouchEvents];
        
        /*
        UIView *gearView = [[UIView alloc]init];
        gearView.backgroundColor = [UIColor clearColor];
        gearView.frame = CGRectMake(SCREEN_WIDTH/2 - 100, 67, 200, 25);
        [self.view addSubview:gearView];
        
        
        CGFloat interval = 5;
        CGFloat imageViewY = 5;
        CGFloat imageViewWH = 15;
        CGFloat labelW = 40;
        UIFont *labelF = [UIFont systemFontOfSize:15];
        
        self.gear1ImageView = [[UIImageView alloc]init];
        self.gear1ImageView.image = [UIImage imageNamed:@"gear_unsel"];
        self.gear1ImageView.frame = CGRectMake(interval, imageViewY, imageViewWH, imageViewWH);
        self.gear1ImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGera1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGear1)];
        [self.gear1ImageView addGestureRecognizer:tapGera1];
        [gearView addSubview:self.gear1ImageView];
        
        UILabel *gear1Label = [UILabel new];
        gear1Label.frame = CGRectMake(CGRectGetMaxX(self.gear1ImageView.frame)+interval, imageViewY, labelW, imageViewWH);
        gear1Label.text = @"1档";
        gear1Label.backgroundColor = [UIColor clearColor];
        gear1Label.textColor = CELL_TEXT_COLOR;
        gear1Label.font = labelF;
        gear1Label.adjustsFontSizeToFitWidth = YES;
        gear1Label.userInteractionEnabled = YES;
        [gear1Label addGestureRecognizer:tapGera1];
        [gearView addSubview:gear1Label];
        
        self.gear2ImageView = [[UIImageView alloc]init];
        self.gear2ImageView.image = [UIImage imageNamed:@"gear_unsel"];
        self.gear2ImageView.frame = CGRectMake(CGRectGetMaxX(gear1Label.frame)+interval, imageViewY, imageViewWH, imageViewWH);
        self.gear2ImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGera2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGear2)];
        [self.gear2ImageView addGestureRecognizer:tapGera2];
        [gearView addSubview:self.gear2ImageView];
        
        UILabel *gear2Label = [UILabel new];
        gear2Label.frame = CGRectMake(CGRectGetMaxX(self.gear2ImageView.frame)+interval, imageViewY, labelW, imageViewWH);
        gear2Label.text = @"2档";
        gear2Label.backgroundColor = [UIColor clearColor];
        gear2Label.textColor = CELL_TEXT_COLOR;
        gear2Label.font = labelF;
        gear2Label.adjustsFontSizeToFitWidth = YES;
        gear2Label.userInteractionEnabled = YES;
        [gear2Label addGestureRecognizer:tapGera2];
        [gearView addSubview:gear2Label];
        
        self.gear3ImageView = [[UIImageView alloc]init];
        self.gear3ImageView.image = [UIImage imageNamed:@"gear_unsel"];
        self.gear3ImageView.frame = CGRectMake(CGRectGetMaxX(gear2Label.frame)+interval, imageViewY, imageViewWH, imageViewWH);
        self.gear3ImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGera3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGear3)];
        [self.gear3ImageView addGestureRecognizer:tapGera3];
        [gearView addSubview:self.gear3ImageView];
        
        UILabel *gear3Label = [UILabel new];
        gear3Label.frame = CGRectMake(CGRectGetMaxX(self.gear3ImageView.frame)+interval, imageViewY, labelW, imageViewWH);
        gear3Label.text = @"3档";
        gear3Label.backgroundColor = [UIColor clearColor];
        gear3Label.textColor = CELL_TEXT_COLOR;
        gear3Label.font = labelF;
        gear3Label.adjustsFontSizeToFitWidth = YES;
        gear3Label.userInteractionEnabled = YES;
        [gear3Label addGestureRecognizer:tapGera3];
        [gearView addSubview:gear3Label];
         */
    }
    
    UIImageView *bedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + SCREEN_WIDTH *0.1, 0.5 * SCREEN_WIDTH * 0.2 + 130, 0.8 *SCREEN_WIDTH - 40,  102)];
    bedImageView.image = [UIImage imageNamed:@"bed"];
    [self.view addSubview:bedImageView];
    
}

-(void)homeBtnClicked:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:1];
    label.textColor = BTN_COLOR;
    UILabel *detailLabel = [btn viewWithTag:2];
    detailLabel.textColor = BTN_COLOR;
    [btn setImage:[self nowMem1Image:YES] forState:UIControlStateHighlighted];
    [self sendData:BlueToothOrderType_Reset_On];
}


-(void)homeBtnRelaxed:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:1];
    label.textColor = [UIColor whiteColor];
    UILabel *detailLabel = [btn viewWithTag:2];
    detailLabel.textColor = [UIColor whiteColor];
    [btn setImage:[self nowMem1Image:NO] forState:UIControlStateNormal];
    [self sendData:BlueToothOrderType_Reset_Off];
}




-(void)mem1BtnClicked:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:10];
    label.textColor = BTN_COLOR;
    UILabel *detailLabel = [btn viewWithTag:20];
    detailLabel.textColor = BTN_COLOR;
    [btn setImage:[self nowMem2Image:YES] forState:UIControlStateHighlighted];
    [self sendData:BlueToothOrderType_Remember1_On];
}

-(void)mem1BtnRelaxed:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:10];
    label.textColor = [UIColor whiteColor];
    UILabel *detailLabel = [btn viewWithTag:20];
    detailLabel.textColor = [UIColor whiteColor];
    [btn setImage:[self nowMem2Image:NO] forState:UIControlStateNormal];
}

-(void)mem1BtnLongPress:(id)sender{
    UITapGestureRecognizer *tap = sender;
    UIButton *btn = (UIButton *)tap.view;
    UILabel *label = [btn viewWithTag:10];
    label.textColor = BTN_COLOR;
    UILabel *detailLabel = [btn viewWithTag:20];
    detailLabel.textColor = BTN_COLOR;
    [btn setImage:[self nowMem2Image:YES] forState:UIControlStateHighlighted];
    if (tap.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    
    [self sendData:BlueToothOrderType_Remember1_New_Location];
}

-(void)mem2BtnClicked:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:10];
    label.textColor = BTN_COLOR;
    UILabel *detailLabel = [btn viewWithTag:20];
    detailLabel.textColor = BTN_COLOR;
    [self sendData:BlueToothOrderType_Remember2_On];
}

-(void)mem2BtnRelaxed:(UIButton *)btn{
    UILabel *label = [btn viewWithTag:10];
    label.textColor = [UIColor whiteColor];
    UILabel *detailLabel = [btn viewWithTag:20];
    detailLabel.textColor = [UIColor whiteColor];
    [btn setImage:[self nowMem3Image:NO] forState:UIControlStateNormal];
}

-(void)mem2BtnLongPress:(id)sender{
    UITapGestureRecognizer *tap = sender;
    if (tap.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    UIButton *btn = (UIButton *)tap.view;
    UILabel *label = [btn viewWithTag:10];
    label.textColor = BTN_COLOR;
    UILabel *detailLabel = [btn viewWithTag:20];
    detailLabel.textColor = BTN_COLOR;
    [self nowMem3Image:YES];
    [self sendData:BlueToothOrderType_Remember2_New_Location];
}


-(void)tapGear1{
    self.gear1ImageView.image = [UIImage imageNamed:@"gear_sel"];
    self.gear2ImageView.image = [UIImage imageNamed:@"gear_unsel"];
    self.gear3ImageView.image = [UIImage imageNamed:@"gear_unsel"];
    [self sendData:BlueToothOrderType_Massage_Gear_1];
    
}

-(void)tapGear2{
    self.gear1ImageView.image = [UIImage imageNamed:@"gear_unsel"];
    self.gear2ImageView.image = [UIImage imageNamed:@"gear_sel"];
    self.gear3ImageView.image = [UIImage imageNamed:@"gear_unsel"];
    [self sendData:BlueToothOrderType_Massage_Gear_2];
    
}

-(void)tapGear3{
    self.gear1ImageView.image = [UIImage imageNamed:@"gear_unsel"];
    self.gear2ImageView.image = [UIImage imageNamed:@"gear_unsel"];
    self.gear3ImageView.image = [UIImage imageNamed:@"gear_sel"];
    [self sendData:BlueToothOrderType_Massage_Gear_3];
    
}

-(void)lightUp{
    if (isLightUp) {
        [self sendData:BlueToothOrderType_Light_Off];
    }else{
        [self sendData:BlueToothOrderType_Light_On];
    }
    isLightUp = !isLightUp;
}


- (void)resetBtnClicked:(id)sender forEvent:(UIEvent *)event{
    
    UITouchPhase phase =event.allTouches.anyObject.phase;
    if (phase == UITouchPhaseBegan) {
        [self sendData:BlueToothOrderType_Reset_On];
    }
    else if(phase == UITouchPhaseEnded){
        [self sendData:BlueToothOrderType_Reset_Off];
    }
}

-(void)rememberBtnLongPress:(id)sender{
    UITapGestureRecognizer *tap = sender;
    if (tap.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    switch (tap.view.tag) {
        case 0:
        {
            [self sendData:BlueToothOrderType_Remember1_New_Location];
        }
            break;
        case 1:
        {
            [self sendData:BlueToothOrderType_Remember2_New_Location];
        }
            break;
    }
}

-(void)rememberBtnClicked:(id)sender{
    UITapGestureRecognizer *tap = sender;
    switch (tap.view.tag) {
        case 0:
        {
            [self sendData:BlueToothOrderType_Remember1_On];
        }
            break;
        case 1:
        {
            [self sendData:BlueToothOrderType_Remember2_On];
        }
            break;
    }
}


- (void)bedBtnAction:(id)sender forEvent:(UIEvent *)event{
    UITouchPhase phase =event.allTouches.anyObject.phase;
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 0:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Head_Up_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Head_Up_Off];
            }
        }
            break;
        case 1:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Massage_Gear_0];
                self.gear1ImageView.image = [UIImage imageNamed:@"gear_unsel"];
                self.gear2ImageView.image = [UIImage imageNamed:@"gear_unsel"];
                self.gear3ImageView.image = [UIImage imageNamed:@"gear_unsel"];
                
            }
        }
            break;
        case 2:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Leg_Up_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Leg_Up_Off];
            }
        }
            break;
        case 3:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Head_Down_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Head_Down_Off];
            }
        }
            break;
        case 4:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Light_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Light_Off];
            }
        }
            break;
        case 5:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Leg_Down_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Leg_Down_Off];
            }
        }
            break;
    }
    
}

- (void)chair_1_stick_BtnAction:(id)sender forEvent:(UIEvent *)event {
    UIButton *btn = sender;
    if (btn.tag == 0) {
        btn.tag = 2;
    } else if (btn.tag == 10) {
        btn.tag = 5;
    }
    
    [self massageBtnAction:btn forEvent:event];
}

-(void)chair_2_stick_BtnAction:(id)sender forEvent:(UIEvent *)event{
    UIButton *btn = sender;
    
    if (btn.tag == 0) {
        btn.tag = 0;
    }else if (btn.tag == 1) {
        btn.tag = 2;
    }else if (btn.tag == 10) {
        btn.tag = 3;
    }else if (btn.tag == 11) {
        btn.tag = 5;
    }
    
    sender = btn;
    
    [self massageBtnAction:sender forEvent:event];
    
}


- (void)massageBtnAction:(id)sender forEvent:(UIEvent *)event{
    UITouchPhase phase =event.allTouches.anyObject.phase;
    UIButton *btn = sender;
    switch (btn.tag) {
        case 0:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Head_Up_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Head_Up_Off];
            }
        }
            break;
        case 1:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Waist_Up_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Waist_Up_Off];
            }
        }
            break;
        case 2:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Leg_Up_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Leg_Up_Off];
            }
        }
            break;
        case 3:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Head_Down_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Head_Down_Off];
            }
        }
            break;
        case 4:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Waist_Down_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Waist_Down_Off];
            }
        }
            break;
        case 5:
        {
            if (phase == UITouchPhaseBegan) {
                [self sendData:BlueToothOrderType_Leg_Down_On];
            }
            else if(phase == UITouchPhaseEnded){
                [self sendData:BlueToothOrderType_Leg_Down_Off];
            }
        }
            break;
    }
    
}


-(void)sendData:(BlueToothOrderType)orderType{
   
   // [SendDataTool sendData:orderType complention:^(NSData *data) {
    //    [self.peripheral writeValue:data.copy forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
   // }];
    
    
    [SendDataTool sendData:orderType complention:^(NSData *data) {
        if (self.characteristic.properties & CBCharacteristicPropertyWrite) {
            [self.peripheral writeValue:data.copy forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        }
        else {
            [self.peripheral writeValue:data.copy forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
        }
        
    }];
}

- (UIImage *)nowMem1Image:(BOOL)sel {
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    if (language == 0) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"mem_1_%@",
                                    sel?@"sel":@"unsel"]];
    } else {
        return [UIImage imageNamed:[NSString stringWithFormat:@"en_mem_1_%@",
                                    sel?@"sel":@"unsel"]];
    }
}

- (UIImage *)nowMem2Image:(BOOL)sel {
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    if (language == 0) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"mem_2_%@",
                                    sel?@"sel":@"unsel"]];
    } else {
        return [UIImage imageNamed:[NSString stringWithFormat:@"en_mem_2_%@",
                                    sel?@"sel":@"unsel"]];
    }
}

- (UIImage *)nowMem3Image:(BOOL)sel {
    NSInteger language = [[NSUserDefaults standardUserDefaults]integerForKey:@"language"];
    if (language == 0) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"mem_3_%@",
                                    sel?@"sel":@"unsel"]];
    } else {
        return [UIImage imageNamed:[NSString stringWithFormat:@"en_mem_3_%@",
                                    sel?@"sel":@"unsel"]];
    }
}

@end

