//
//  YFLoginViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFLoginViewController.h"
#import "YFForgetPassWordViewController.h"
#import "YFRegisterViewController.h"
#import "YFMechanismLoginView.h"

@interface YFLoginViewController (){
    NSInteger counting;//倒计时秒数
}
@property (nonatomic, strong) NSTimer *timer;//倒计时验证码发送
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *modeLoginBtn;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;//验证码登录背景
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;// 用户名
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//发送验证码
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;//验证码登录
@property (nonatomic, assign) BOOL isCodeLogin;//是否是验证码登录
@property (weak, nonatomic) IBOutlet UIButton *secureBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPswBtn;//忘记密码
@property (nonatomic, strong) YFMechanismLoginView *mLoginView;//机构登录
@end

@implementation YFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                               = @"验证码登录";
    [self addLeftImageBtn:@"Back"];
    [self addRightTitleBtn:@"机构登录"];
    self.rightTitleBtn.titleLabel.font       = [UIFont systemFontOfSize:15];
    self.isCodeLogin                         = YES;//默认是验证码登录
    
    SKViewsBorder(self.loginBtn, 3, 0, NavColor);
    SKViewsBorder(self.modeLoginBtn, 3, 0, NavColor);
    counting                                 = 60;
    self.userNameTF.text                     = [NSString isBlankString:USERPHONE] ? @"" : USERPHONE;
    //获取验证码校验
    [self verificationCodeTF];
}

#pragma mark 登录
- (IBAction)clickLoginBtn:(id)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *parms               = [NSMutableDictionary dictionary];
    if (self.isCodeLogin) {
        //验证码登录参数
        [parms safeSetObject:self.userNameTF.text forKey:@"mobile"];
        [parms safeSetObject:self.codeTF.text forKey:@"valicode"];
    }else{
        [parms safeSetObject:self.userNameTF.text forKey:@"username"];
        [parms safeSetObject:self.passWordTF.text forKey:@"password"];
        [parms safeSetObject:@"1" forKey:@"type"];
    }
    NSString *pathUrl = self.isCodeLogin ? @"loginBySms.do" : @"login.do?";

    @weakify(self)
    [WKRequest postWithURLString:pathUrl parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self loginSuccessWithModel:baseModel];
        }else if (CODE_REPEAT){
            [self repeatAccount:baseModel];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
            !self.loginFailureBlock ? : self.loginFailureBlock();
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginSuccessWithModel:(WKBaseModel *)baseModel{
    // 存储用户信息
    [UserData userInfo:[baseModel.mDictionary safeJsonObjForKey:@"data"]];
    //存储用户账号信息
    [self storageUserAccountMessage];
    //返回需要做的操作
    !self.loginSuccessBlock ? :self.loginSuccessBlock();
    [self Back];
}

/**
 存储用户的账户信息
 */
- (void)storageUserAccountMessage{
    [YFUserDefaults setObject:self.userNameTF.text forKey:@"USERPHONE"];
}

/**
 手机号重复需要
 */
- (void)repeatAccount:(WKBaseModel *)baseModel{
    WS(weakSelf)
    [self showAlertViewControllerTitle:wenxinTitle Message:@"手机号重复, 请用账号登录, 并验证手机号" CancelTitle:@"确定" CancelTextColor:ConfirmColor ConfirmTitle:@"取消" ConfirmTextColor: CancelColor cancelBlock:^{
        [weakSelf rightTitleButtonClick:[UIButton new]];
    } confirmBlock:^{
        
    }];
}

#pragma mark  发送验证码
- (IBAction)clickCodeBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![NSString validateMobile:self.userNameTF.text]) {
        [YFToast showMessage:@"请输入正确的手机号" inView:self.view];
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.userNameTF.text forKey:@"mobile"];
    @weakify(self)
    [WKRequest postWithURLString:@"getLoginSms.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
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

#pragma mark 忘记密码
- (IBAction)clickForgetPsw:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([sender.titleLabel.text containsString:@"忘记密码"]) {
        YFForgetPassWordViewController *forget   = [YFForgetPassWordViewController new];
        forget.title                             = @"忘记密码";
        [self.navigationController pushViewController:forget animated:YES];
    }else{
        [self showAlertViewControllerTitle:wenxinTitle Message:@"请联系客服电话021-32581211-8060" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            NSString *phone                      = [NSString stringWithFormat:@"tel:021-32581211-8060"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }];
    }
}

#pragma mark 注册
- (IBAction)clickRegister:(id)sender {
    [self.view endEditing:YES];
    YFRegisterViewController *registe        = [YFRegisterViewController new];
    registe.isLoginOut                       = self.isLoginOut;
    [self.navigationController pushViewController:registe animated:YES];
}

- (IBAction)clickSecure:(UIButton *)sender {
    sender.selected                          = !sender.selected;
    self.passWordTF.secureTextEntry          = !sender.selected;
}

#pragma mark 切换登录方式
- (IBAction)clickCodeLogin:(UIButton *)sender {
    self.isCodeLogin                         = !self.isCodeLogin;
    self.codeBgView.hidden                   = !self.isCodeLogin;
    self.passWordTF.hidden                   = self.secureBtn.hidden = self.isCodeLogin;
    self.userNameTF.placeholder              = self.isCodeLogin ? @"请输入手机号" : @"请输入账号或手机号";
    self.title                               = self.isCodeLogin ? @"验证码登录" : @"密码登录";
    [self.forgetPswBtn setTitle:self.isCodeLogin ? @"无法收到验证码?" : @"忘记密码" forState:UIControlStateNormal];
    [self.codeLoginBtn setTitle:self.isCodeLogin ? @"密码登录" : @"验证码登录" forState:0];
    //判断当前登录方式是否可用
    [self textFieldDidChange:nil];
    
}

#pragma mark 设置导航栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark  倒计时开始
- (void)startTime {
    if (!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeCounting) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    self.codeBtn.userInteractionEnabled = NO;
    [_timer fire];
}

#pragma mark - 定时器倒计时
- (void)TimeCounting {
    counting--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)counting] forState:UIControlStateNormal];
    
    if (counting == 0)
    {
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer                              = nil;
        counting                            = 60;
    }
}

/**
 重置发送验证码y按钮
 */
- (void)recharge{
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeBtn.userInteractionEnabled = YES;
    [_timer invalidate];
    _timer                              = nil;
    counting                            = 60;
}

#pragma mark 机构登录页面
- (YFMechanismLoginView *)mLoginView{
    if (!_mLoginView) {
        _mLoginView             = [[[NSBundle mainBundle] loadNibNamed:@"YFMechanismLoginView" owner:nil options:nil] lastObject];
        _mLoginView.frame       = CGRectMake(0, 0, ScreenWidth, 400);
        _mLoginView.superVC     = self;
        @weakify(self)
        _mLoginView.mechanismLoginSuccessBlock = ^{
            //登录成功
            @strongify(self)
            !self.loginSuccessBlock ? :self.loginSuccessBlock();
            [self Back];
        };
        _mLoginView.mechanismLoginFailureBlock = ^{
          //登录失败
            @strongify(self)
            !self.loginFailureBlock ? : self.loginFailureBlock();
        };
        [self.view addSubview:_mLoginView];
    }
    return _mLoginView;
}

/**
 机构登录

 @param sender sender description
 */
- (void)rightTitleButtonClick:(UIButton *)sender{
    self.title = @"机构登录";
    self.rightTitleBtn.selected = self.rightTitleBtn.hidden = YES;
    self.mLoginView.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //离开界面销毁定时器
    [_timer invalidate];
    _timer = nil;
}

#pragma mark 返回
- (void)leftImageButtonClick:(UIButton *)sender{
    if (self.rightTitleBtn.selected) {
        self.title = self.isCodeLogin ? @"验证码登录" : @"密码登录";
        self.mLoginView.hidden = YES;
        self.rightTitleBtn.selected = self.rightTitleBtn.hidden = NO;
        return;
    }
    
    !self.loginFailureBlock ? : self.loginFailureBlock();
    if (self.modeType == YFLoginModeSpecialType) {
        [self selectTabbarIndex:0];
    }
    [self Back];
}

- (void)Back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 监听输入框
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.userNameTF && textField.text.length > 11) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
    }
    if (self.isCodeLogin) {
        //验证码登录
        if ([NSString validateMobile:self.userNameTF.text] && ![NSString isBlankString:self.codeTF.text]) {
            self.loginBtn.enabled = YES;
            self.loginBtn.alpha = 1;
        }else{
            self.loginBtn.enabled = NO;
            self.loginBtn.alpha = 0.6;
        }
    }else{
        //密码登录
        if ([NSString validateMobile:self.userNameTF.text] && ![NSString isBlankString:self.passWordTF.text]) {
            self.loginBtn.enabled = YES;
            self.loginBtn.alpha = 1;
        }else{
            self.loginBtn.enabled = NO;
            self.loginBtn.alpha = 0.6;
        }
    }
}

/**
 获取验证码按钮的颜色控制
 */
- (void)verificationCodeTF {
    @weakify(self)
    [[self.userNameTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *codeNum = [NSString stringWithFormat:@"%@",x];
        if ([NSString validateMobile:codeNum]) {
            self.codeBtn.enabled = YES;
            [self.codeBtn setTitleColor:OrangeBtnColor forState:0];
        }else{
            self.codeBtn.enabled = NO;
            [self.codeBtn setTitleColor:GrayColor forState:0];
        }
    }];
}

@end
