//
//  YFOtherLogin.m
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOtherLogin.h"

@implementation YFOtherLogin
SKSingleM(YFOtherLogin)

/**
 *  第三方登录
 *  @param platformType 平台类型 @see UMSocialPlatformType
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param loginSuccess   成功回调
 *  @param loginFailure   失败回调
 */
+ (void)otherLoginWithPlatformType:(UMSocialPlatformType)platformType
             currentViewController:(id)currentViewController
                      loginSuccess:(void (^)(UMSocialUserInfoResponse *resp))loginSuccess
                      loginFailure:(void (^)(NSError *error))loginFailure{
    // 在需要进行获取用户信息的UIViewController中加入如下代码
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:currentViewController completion:^(id result, NSError *error) {
        if (error) {
            loginFailure(error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            loginSuccess(resp);
        }
    }];
}

@end
