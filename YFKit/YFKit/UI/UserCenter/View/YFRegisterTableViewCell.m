//
//  YFRegisterTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFRegisterTableViewCell.h"
#import "YFUserProtocolViewController.h"
@implementation YFRegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    counting = 60;
    SKViewsBorder(self.rgisterBtn, 3, 0, NavColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark  验证码
- (IBAction)clickCodeBtn:(id)sender {
    [self.superVC.view endEditing:YES];
    if (![NSString validateMobile:self.phoneTF.text]) {
        [YFToast showMessage:@"请输入正确的手机号" inView:self.superVC.view];
        return;
    }
    
    @weakify(self)
    [WKRequest postWithURLString:@"register/getRegSms.do" parameters:@{@"mobile":self.phoneTF.text} isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"短信发送成功" inView:self.superVC.view];
            [self startTime];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  倒计时开始
-(void)startTime{
    if (self.timer  == nil){
        self.timer                        = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeCounting) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer  forMode:NSRunLoopCommonModes];
    }
    self.codeBtn.userInteractionEnabled = NO;
    [self.timer  fire];
}


#pragma mark - 定时器倒计时
- (void)TimeCounting
{
    counting--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)counting] forState:UIControlStateNormal];
    
    if (counting == 0)
    {
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
        [self.timer  invalidate];
        self.timer  = nil;
        counting = 60;
    }
    
}
#pragma mark  阅读并同意
- (IBAction)clickSelectBtn:(UIButton *)sender {
    sender.selected                     = !sender.selected;
    [self textFieldDidChange:nil];
}

#pragma mark 协议
- (IBAction)clickAgreeBtn:(id)sender {
    YFUserProtocolViewController *agree    = [[YFUserProtocolViewController alloc]initWithNibName:@"YFUserProtocolViewController" bundle:nil];
    [self.superVC.navigationController pushViewController:agree animated:YES];
}
#pragma mark  注册
- (IBAction)clickRegisterBtn:(id)sender {
    NSString *alertMsg;
    if (![self.passWordTF.text isEqualToString:self.savePswTF.text]){
        alertMsg                        = @"两次密码不一致";
    }else if (![self.passWordTF.text weakPswd]){
        alertMsg                        = @"请输入6-15位字母 + 数字";
    }else if ([NSString isBlankString:self.companyTF.text]){
        alertMsg                        = @"请输入公司名称或个人姓名";
    }else if (![NSString isBlankString:self.InviterPhone.text] && ![NSString validateMobile:self.InviterPhone.text]){
        alertMsg                        = @"请输入正确的邀请人手机号";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.superVC.view];
        return;
    }
    
    NSMutableDictionary *parms          = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.phoneTF.text forKey:@"mobile"];
    [parms safeSetObject:self.codeTF.text forKey:@"valicode"];
    [parms safeSetObject:self.passWordTF.text forKey:@"password"];
    [parms safeSetObject:self.savePswTF.text forKey:@"repwd"];
    [parms safeSetObject:self.InviterPhone.text forKey:@"recommTel"];
    [parms safeSetObject:self.companyTF.text forKey:@"companyName"];
    @weakify(self)
    [WKRequest postWithURLString:@"register/regBase.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self userLogin];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 登录
- (void)userLogin{
    NSMutableDictionary *parms               = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.phoneTF.text forKey:@"username"];
    [parms safeSetObject:self.passWordTF.text forKey:@"password"];
    @weakify(self)
    [WKRequest postWithURLString:@"login.do?" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            // 存储用户信息
            [UserData userInfo:[baseModel.mDictionary safeJsonObjForKey:@"data"]];
            [YFUserDefaults setObject:self.phoneTF.text forKey:@"USERPHONE"];
            !self.registerSuccessBlock ? : self.registerSuccessBlock();
        }else{
//            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 校验输入框
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.phoneTF) {
        //如果大于11位 只去11位
        if (textField.text.length > 11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        }
        //判断是否是正确的手机号
        if ([NSString validateMobile:textField.text]) {
            self.codeBtn.enabled = YES;
            [self.codeBtn setTitleColor:OrangeBtnColor forState:0];
        }else{
            self.codeBtn.enabled = NO;
            [self.codeBtn setTitleColor:GrayColor forState:0];
        }
    }
    //邀请人
    if (textField == self.InviterPhone) {
        //如果大于11位 只去11位
        if (textField.text.length > 11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        }
    }
    
    //验证密码
    if ((textField == self.passWordTF || textField == self.savePswTF) && textField.text.length > 15) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 15)];
    }
    
    //验证各个输入框
    if ([NSString validateMobile:self.phoneTF.text] && ![NSString isBlankString:self.codeTF.text] && ![NSString isBlankString:self.passWordTF.text] && ![NSString isBlankString:self.savePswTF.text] && ![NSString isBlankString:self.companyTF.text] && self.readBtn.selected) {
        self.rgisterBtn.enabled = YES;
        self.rgisterBtn.alpha = 1;
    }else{
        self.rgisterBtn.enabled = NO;
        self.rgisterBtn.alpha = 0.6;
    }
}

#pragma mark 密码的显示与隐藏
- (IBAction)clickPswBtn:(UIButton *)sender {
    sender.selected                     = !sender.selected;
    self.passWordTF.secureTextEntry     = !sender.selected;
}
- (IBAction)clickAgainBtn:(UIButton *)sender {
    sender.selected                     = !sender.selected;
    self.savePswTF.secureTextEntry      = !sender.selected;
}
@end
