//
//  UserData.m
//  YFKit
//
//  Created by 王宇 on 2018/5/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+(UserInfoData *)userInfo{
    
    NSString *dicStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Info"];
    if ([NSString isBlankString:dicStr]) {
        return nil;
    }
    NSData *data = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    UserInfoData *infodata = nil;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        infodata = [[UserInfoData alloc]initWithDictionary:dic];
    }else{
        return nil;
    }
    return infodata;
}

+(void)userInfo:(NSDictionary *)userInfo{
    
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        NSString *userInfoStr = [NSString dictionTransformationJson:userInfo];
        [YFUserDefaults setObject:userInfoStr forKey:@"Info"];
        [YFUserDefaults synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Info"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"HistoryLengthArr"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"HistoryTypeArr"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"historyAddressStartArr"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"historyAddressEndArr"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

+ (BOOL)isUserLogin{
    NSString *dicStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Info"];
    if ([NSString isBlankString:dicStr]) {
        return NO;
    }
    NSData *data = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *token = [dic stringObjectForKey:@"token"];
            if (![NSString isBlankString:token]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)setUserName:(NSString *)UserName{
    NSString *dicStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Info"];
    if ([NSString isBlankString:dicStr]) {
        return;
    }
    NSData *data = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [dict setObject:UserName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"Info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dict = nil;
}

+ (void)setToken:(NSString *)token{
    NSString *dicStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Info"];
    if ([NSString isBlankString:dicStr]) {
        return;
    }
    NSData *data = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
    [dict safeSetObject:token forKey:@"token"];
    NSString *userInfoStr = [NSString dictionTransformationJson:dict];
    [YFUserDefaults setObject:userInfoStr forKey:@"Info"];
    [YFUserDefaults synchronize];
    dict = nil;
}

+ (void)setUserInfoStatus:(NSString *)userInfoStatus{
    NSString *dicStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Info"];
    if ([NSString isBlankString:dicStr]) {
        return;
    }
    NSData *data = [dicStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
    [dict safeSetObject:userInfoStatus forKey:@"userInfoStatus"];
    NSString *userInfoStr = [NSString dictionTransformationJson:dict];
    [YFUserDefaults setObject:userInfoStr forKey:@"Info"];
    [YFUserDefaults synchronize];
    dict = nil;
}




@end
