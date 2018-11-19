//
//  UserInfoData.m
//  YFKit
//
//  Created by 王宇 on 2018/5/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "UserInfoData.h"

@implementation UserInfoData

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"mobile"]] forKey:@"mobile"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"memberType"]] forKey:@"memberType"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"token"]] forKey:@"token"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"userInfoStatus"]] forKey:@"userInfoStatus"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"phoneStatus"]] forKey:@"phoneStatus"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"account"]] forKey:@"account"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"age"]] forKey:@"age"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"companyId"]] forKey:@"companyId"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"companyPid"]] forKey:@"companyPid"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"createTime"]] forKey:@"createTime"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"creator"]] forKey:@"creator"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"mobileStatus"]] forKey:@"mobileStatus"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"orgId"]] forKey:@"orgId"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"organizationId"]] forKey:@"organizationId"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"password"]] forKey:@"password"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"phone"]] forKey:@"phone"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"username"]] forKey:@"username"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"userId"]] forKey:@"userId"];
        [self setValue:[NSString stringWithFormat:@"%@",dic[@"user"][@"userType"]] forKey:@"userType"];
    }
    
    return self;
}

@end
