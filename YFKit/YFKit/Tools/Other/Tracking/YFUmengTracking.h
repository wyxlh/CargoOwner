//
//  YFUmengTracking.h
//  YFKit
//
//  Created by 王宇 on 2018/10/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFUmengTracking : NSObject

/**
 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 */
+ (void)umengEvent:(NSString *)eventId;

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
+ (void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
