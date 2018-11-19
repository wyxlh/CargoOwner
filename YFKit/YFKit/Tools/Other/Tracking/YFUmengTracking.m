//
//  YFUmengTracking.m
//  YFKit
//
//  Created by 王宇 on 2018/10/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUmengTracking.h"
#import <UMAnalytics/MobClick.h>

@implementation YFUmengTracking


/**
 自定义事件,数量统计.
 */
+ (void)umengEvent:(NSString *)eventId
{
    [MobClick event:eventId];
}

/**
 自定义事件,数量统计.
 */
+ (void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    [MobClick event:eventId attributes:attributes];
}

@end
