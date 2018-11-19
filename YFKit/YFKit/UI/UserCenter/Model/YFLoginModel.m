//
//  YFLoginModel.m
//  YFKit
//
//  Created by 王宇 on 2018/10/16.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFLoginModel.h"
#import "YFLoginViewController.h"
#import "WKNavigationController.h"
#import "YFPersonalMsgViewController.h"

@implementation YFLoginModel

#pragma mark 登录
+ (void)loginWithLoginModeType:(NSInteger )loginModeType
                  loginSuccess:(void (^)(void))loginSuccess
                  loginFailure:(void (^)(void))loginFailure
{
    //是否是组织用户
    if (!isLogin) {
        //用户没有登录
        YFLoginViewController *login            = [YFLoginViewController new];
        login.isLoginOut                        = YES;
        login.modeType                          = loginModeType;
        @weakify(self)
        login.loginSuccessBlock                 = ^(){
            @strongify(self)
            [self verifyInformationIntegrity];
            loginSuccess();
        };
        login.loginFailureBlock                 = ^(){
            loginFailure();
        };
        WKNavigationController *navUserlogin    = [[WKNavigationController alloc]initWithRootViewController:login];
        [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:navUserlogin animated:YES completion:nil];
    }
}

#pragma mark 验证用户的信息是否完整
+ (void)verifyInformationIntegrity{
    //如果货主会员为008 需要完善资料
    if (IS_CARGO_OWNER && ![[UserData userInfo].userInfoStatus boolValue]) {
        @weakify(self)
        [WKRequest isHiddenActivityView:YES];
        [WKRequest getWithURLString:@"user/have/not/user/info.do" parameters:nil success:^(WKBaseModel *baseModel) {
            @strongify(self)
            if (CODE_ZERO) {
                BOOL isNotHave = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"isNotHave"] boolValue];
                [UserData setUserInfoStatus:isNotHave ? @"1" : @"0"];
                if (!isNotHave) {
                    [self showAlertViewControllerTitle:wenxinTitle Message:@"请完善个人资料,否则无法下单!" CancelTitle:@"暂不完善" CancelTextColor:ConfirmColor ConfirmTitle:@"去完善" ConfirmTextColor:CancelColor cancelBlock:^{
                        
                    } confirmBlock:^{
                        YFPersonalMsgViewController *person = [YFPersonalMsgViewController new];
                        WKNavigationController *nav = [[WKNavigationController alloc]initWithRootViewController:person];
                        [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:nav animated:YES completion:nil];
                    }];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

+ (void)showAlertViewControllerTitle:(NSString *)title
                            Message:(NSString *)message
                        CancelTitle:(NSString *)cancelTitle
                    CancelTextColor:(UIColor *)cancelTextColor
                       ConfirmTitle:(NSString *)confirmTitle
                   ConfirmTextColor:(UIColor *)confirmTextColor
                        cancelBlock:(void (^)(void))cancelBlock
                       confirmBlock:(void (^)(void))confirmBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x747474) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    NSMutableAttributedString *messages = [[NSMutableAttributedString alloc] initWithString:message];
    [messages addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [[messages string] length])];
    [messages addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x747474) range:NSMakeRange(0, [[messages string] length])];
    [alert setValue:messages forKey:@"attributedMessage"];
    
    [cancel setValue:cancelTextColor forKey:@"_titleTextColor"];
    [confirm setValue:confirmTextColor forKey:@"_titleTextColor"];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

@end
