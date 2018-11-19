//
//  YFLoginModel.h
//  YFKit
//
//  Created by 王宇 on 2018/10/16.
//  Copyright © 2018 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLoginModel : NSObject

/**
 登录方法
 @param loginModeType 登录类型
 @param loginSuccess 登录成功
 */
+ (void)loginWithLoginModeType:(NSInteger )loginModeType
                  loginSuccess:(void (^)(void))loginSuccess
                  loginFailure:(void (^)(void))loginFailure;

/**
 验证用户信息是否完整
 */
+ (void)verifyInformationIntegrity;

@end

NS_ASSUME_NONNULL_END
