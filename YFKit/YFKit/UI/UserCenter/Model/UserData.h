//
//  UserData.h
//  YFKit
//
//  Created by 王宇 on 2018/5/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoData.h"

@interface UserData : NSObject
@property (retain, nonatomic) UserInfoData * userInfo;       //登录的用户资料
+ (UserInfoData *)userInfo;
+ (void)userInfo:(NSDictionary *)userInfo;
+ (BOOL)isUserLogin;
/**
 修改用户名

 @param UserName UserName
 */
+ (void)setUserName:(NSString *)UserName;

/**
 修改 token

 @param token token description
 */
+ (void)setToken:(NSString *)token;

/**
  修改信息完整字段

 @param userInfoStatus userInfoStatus description
 */
+ (void)setUserInfoStatus:(NSString *)userInfoStatus;
@end
