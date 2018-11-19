//
//  UserInfoData.h
//  YFKit
//
//  Created by 王宇 on 2018/5/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoData : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyPid;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *mobileStatus;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *organizationId;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userId;
/**
 手机是否绑定状态
 */
@property (nonatomic, copy) NSString *phoneStatus;
/**
 该用户个人信息是否完整
 */
@property (nonatomic, copy) NSString *userInfoStatus;
/**
 2表示app注册用户 1表示tms注册用户
 */
@property (nonatomic, copy) NSString *userType;
/**
 008为货主会员
 */
@property (nonatomic, copy) NSString *memberType;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
NS_ASSUME_NONNULL_END
@end
