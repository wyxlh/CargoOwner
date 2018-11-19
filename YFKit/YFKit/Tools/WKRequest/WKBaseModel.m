//
//  WKbaseModel.m
//  YukiFramework
//
//  Created by 王宇 on 2017/11/13.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "WKBaseModel.h"

@implementation WKBaseModel

-(instancetype)initWithJsonObject:(NSDictionary *)aJson{
    self = [super init];
    
    if (self) {
        if (aJson && [aJson isKindOfClass:[NSDictionary class]]) {
            self.mDictionary = [NSMutableDictionary dictionaryWithDictionary:aJson];
            self.data        = [aJson objectForKey:@"data"];
            self.message     = [aJson objectForKey:@"message"];
            self.code        = [aJson objectForKey:@"code"];
        }
    }
    
    return self;
}

//-(NSString *)result{
//    return [self.mDictionary objectForKey:@"data"];
//}
//
//-(NSString *)message{
//    return [self.mDictionary objectForKey:@"message"];
//}
//
//-(NSString *)errorCode{
//    return [self.mDictionary objectForKey:@"code"];
//
//}

@end
