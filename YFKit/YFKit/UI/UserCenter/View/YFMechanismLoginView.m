//
//  YFMechanismLoginView.m
//  YFKit
//
//  Created by 王宇 on 2018/11/1.
//  Copyright © 2018 wy. All rights reserved.
//
#define MechanismCode [YFUserDefaults objectForKey:@"MechanismCode"]
#define MechanismUserName [YFUserDefaults objectForKey:@"MechanismUserName"]

#import "YFMechanismLoginView.h"
#import "YFModeBindViewController.h"
#import "YFForgetPassWordViewController.h"

@implementation YFMechanismLoginView

- (void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.loginBtn, 3, 0, NavColor);
    self.mechanismNumTF.text         = [NSString isBlankString:MechanismCode] ? @"" : MechanismCode;
    self.userNameTF.text             = [NSString isBlankString:MechanismUserName] ? @"" : MechanismUserName;
    [self textFieldDidChange:nil];
}

#pragma mark 登录
- (IBAction)clickLoginBtn:(id)sender {
    NSMutableDictionary *parms               = [NSMutableDictionary dictionary];
    
    [parms safeSetObject:self.userNameTF.text forKey:@"username"];
    [parms safeSetObject:self.passWordTF.text forKey:@"password"];
    [parms safeSetObject:self.mechanismNumTF.text forKey:@"sysCode"];
    [parms safeSetObject:@"1" forKey:@"type"];
    @weakify(self)
    [WKRequest postWithURLString:@"login.do?" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self loginSuccessWithModel:baseModel];
        }else{
             [YFToast showMessage:baseModel.message inView:self.superVC.view];
             !self.mechanismLoginFailureBlock ? : self.mechanismLoginFailureBlock();
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginSuccessWithModel:(WKBaseModel *)baseModel{
    // 存储用户信息
    [UserData userInfo:[baseModel.mDictionary safeJsonObjForKey:@"data"]];
    //存储用户账号信息
    [self storageUserAccountMessage];
    //如果是组织账号 并且没有绑定 那么需要去绑定手机号
    if ([[UserData userInfo].phoneStatus boolValue]) {
        YFModeBindViewController *bind = [YFModeBindViewController new];
        bind.sourceType                = BindPhoneByTMSAccountType;
        [self.superVC.navigationController pushViewController:bind animated:YES];
        return;
    }
    //返回需要做的操作
    !self.mechanismLoginSuccessBlock ? :self.mechanismLoginSuccessBlock();
}

/**
 存储用户的账户信息
 */
- (void)storageUserAccountMessage{
    [YFUserDefaults setObject:self.mechanismNumTF.text forKey:@"MechanismCode"];
    [YFUserDefaults setObject:self.userNameTF.text forKey:@"MechanismUserName"];
}

#pragma mark 忘记密码
- (IBAction)clickForgetBtn:(id)sender {
    YFForgetPassWordViewController *forget   = [YFForgetPassWordViewController new];
    forget.title                             = @"忘记密码";
    [self.superVC.navigationController pushViewController:forget animated:YES];
}

- (IBAction)clickSecure:(UIButton *)sender {
    sender.selected                          = !sender.selected;
    self.passWordTF.secureTextEntry          = !sender.selected;
}

#pragma mark 验证输入框
- (IBAction)textFieldDidChange:(UITextField *)sender {
    if (![NSString isBlankString:self.mechanismNumTF.text] && ![NSString isBlankString:self.userNameTF.text] && ![NSString isBlankString:self.passWordTF.text]) {
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.alpha = 0.6;
    }
}
@end

