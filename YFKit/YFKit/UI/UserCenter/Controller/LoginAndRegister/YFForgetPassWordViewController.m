//
//  YFForgetPassWordViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFForgetPassWordViewController.h"

@interface YFForgetPassWordViewController (){
    NSTimer *timer;//倒计时验证码发送
    NSInteger counting;//倒计时秒数
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UITextField *againTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YFForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    counting = 60;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x004197);
    SKViewsBorder(self.saveBtn, 3, 0, NavColor);
    self.view.backgroundColor        = UIColorFromRGB(0xF7F7F7);
    [self showNavBar];
    [self.view sendSubviewToBack:self.bgView];
    
    self.phoneTF.text                = ([NSString isBlankString:[UserData userInfo].phone] || [[UserData userInfo].phone isEqualToString:@"<null>"]) ? @"" : [UserData userInfo].phone;
    
    @weakify(self)
    [[self.phoneTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *phoneText          = [NSString stringWithFormat:@"%@",x];
        if (phoneText.length > 11) {
            self.phoneTF.text        = [phoneText substringWithRange:NSMakeRange(0, 11)];
        }
        //验证发送验证码颜色
        if ([NSString validateMobile:self.phoneTF.text]) {
            self.codeBtn.enabled = YES;
            [self.codeBtn setTitleColor:OrangeBtnColor forState:0];
        }else{
            self.codeBtn.enabled = NO;
            [self.codeBtn setTitleColor:GrayColor forState:0];
        }
    }];
}
#pragma mark 忘记密码提交
- (IBAction)clickSaveBtn:(id)sender {
    NSString *alertMsg;
    if ([NSString isBlankString:self.firstTF.text]){
        alertMsg                    = @"请输入6-15位字母 + 数字";
    }else if ([NSString isBlankString:self.againTF.text]){
        alertMsg                    = @"请输入6-15位字母 + 数字";
    }else if (![self.firstTF.text isEqualToString:self.againTF.text]){
        alertMsg                    = @"两次密码不一致";
    }else if (![self.firstTF.text weakPswd]){
        alertMsg                    = @"请输入6-15位字母 + 数字";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms       = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.phoneTF.text forKey:@"mobile"];
    [parms safeSetObject:self.firstTF.text forKey:@"password"];
    [parms safeSetObject:self.codeTF.text forKey:@"valicode"];
    [WKRequest postWithURLString:@"resetPwd.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            [YFToast showMessage:@"修改成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)clickFirstBtn:(UIButton *)sender {
    sender.selected                  = !sender.selected;
    self.firstTF.secureTextEntry     = !sender.selected;
}
- (IBAction)clickAgainBtn:(UIButton *)sender {
    sender.selected                  = !sender.selected;
    self.againTF.secureTextEntry     = !sender.selected;
}
- (IBAction)clickCodeBtn:(id)sender {
    [self.view endEditing:YES];
    if (![NSString validateMobile:self.phoneTF.text]) {
        [YFToast showMessage:@"请输入正确的手机号" inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms       = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.phoneTF.text forKey:@"mobile"];
    [WKRequest postWithURLString:@"getResetPwdSms.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
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
-(void)startTime{
    if (timer == nil){
        timer                        = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeCounting) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    self.codeBtn.userInteractionEnabled = NO;
    [timer fire];
}


#pragma mark - 定时器倒计时
- (void)TimeCounting
{
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

#pragma mark 输入验证
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if ((textField == self.firstTF || textField == self.againTF) && textField.text.length > 15) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 15)];
    }
    if ([NSString validateMobile:self.phoneTF.text] && ![NSString isBlankString:self.codeTF.text] && ![NSString isBlankString:self.firstTF.text] && ![NSString isBlankString:self.againTF.text]) {
        self.saveBtn.enabled = YES;
        self.saveBtn.alpha = 1;
    }else{
        self.saveBtn.enabled = NO;
        self.saveBtn.alpha = 0.6;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //离开界面销毁定时器
    [timer invalidate];
    timer = nil;
    
}



@end
