//
//  YFOtherLogin.h
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSingle.h"

@interface YFOtherLogin : NSObject
SKSingleH(YFOtherLogin)

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
                      loginFailure:(void (^)(NSError *error))loginFailure;
@end
