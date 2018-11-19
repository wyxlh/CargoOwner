//
//  YFModeBindViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/10/17.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFModeBindViewController.h"

@interface YFModeBindViewController (){
    NSTimer *timer;//倒计时验证码发送
    NSInteger counting;//倒计时秒数
}
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//发送验证码
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;//绑定
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewWidthCons;
@property (weak, nonatomic) IBOutlet UIView *topView;
@end

@implementation YFModeBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    counting = 60;
    SKViewsBorder(self.bindBtn, 3, 0, NavColor);
    self.rightTitleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    if (self.sourceType == BindPhoneByPersonMessageType) {
        self.title = @"变更手机号";
        self.topViewWidthCons.constant = 0.00f;
        self.topView.hidden = YES;
        [self.bindBtn setTitle:@"变更" forState:0];
    }else{
        self.title = @"绑定手机号";
        self.topViewWidthCons.constant = 40.0f;
        self.topView.hidden = NO;
        [self addRightTitleBtn:@"跳过"];
    }
}

/**
 跳过
 */
- (void)rightTitleButtonClick:(UIButton *)sender{
    [self goBack];
}

-(void)backButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //验证用户信息是够完整
    if (self.sourceType == BindPhoneByTMSAccountType) {
        [YFLoginModel verifyInformationIntegrity];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark  发送验证码
- (IBAction)clickCodeBtn:(id)sender {
    [self.view endEditing:YES];
    @weakify(self)
    [WKRequest postWithURLString:@"phone/verification.do" parameters:@{@"mobile":self.userNameTF.text} isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"短信发送成功" inView:self.view];
            [self startTime];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark  倒计时开始
-(void)startTime {
    if (timer == nil){
        timer                        = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeCounting) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    self.codeBtn.userInteractionEnabled = NO;
    [timer fire];
}

#pragma mark - 定时器倒计时
- (void)TimeCounting {
    counting--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)counting] forState:UIControlStateNormal];
    
    if (counting == 0)
    {
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
        counting = 60;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //离开界面销毁定时器
    [timer invalidate];
    timer = nil;
    
}

#pragma mark 监听 textField 的变化
- (IBAction)textFieldDidChange:(UITextField *)textField {
    
    if (textField == self.userNameTF) {
        //第一位只能是1
        if (textField.text.length == 1 && ![textField.text isEqualToString:@"1"]) {
            textField.text = @"";
        }
        //最多11位 电话号码
        if (textField.text.length > 11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        }
    }
    //验证发送验证码 按钮 字体颜色
    if ([NSString validateMobile:self.userNameTF.text]) {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitleColor:OrangeBtnColor forState:0];
    }else{
        self.codeBtn.enabled = NO;
        [self.codeBtn setTitleColor:GrayColor forState:0];
    }
    //验证绑定按钮颜色
    if ([NSString validateMobile:self.userNameTF.text] && ![NSString isBlankString:self.codeTF.text]) {
        self.bindBtn.enabled = YES;
        self.bindBtn.alpha = 1;
    }else{
        self.bindBtn.enabled = NO;
        self.bindBtn.alpha = 0.6;
    }
}

#pragma mark 绑定手机号
- (IBAction)clickBindBtn:(id)sender {
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.userNameTF.text forKey:@"mobile"];
    [parms safeSetObject:self.codeTF.text forKey:@"valicode"];
    @weakify(self)
    [WKRequest postWithURLString:@"user/phone/binding.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [UserData userInfo:nil];
            [UserData userInfo:[baseModel.mDictionary safeJsonObjForKey:@"data"]];
            [YFToast showMessage:@"绑定成功"];
            [self goBack];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
