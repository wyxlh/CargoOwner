//
//  NSTimer+addition.h
//  YukiFramework
//
//  Created by 王宇 on 2018/1/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (addition)
/** 暂停时间 */
- (void)pauseTime;
/** 获取内容所在当前时间 */
- (void)webPageTime;
/** 当前时间 time 秒后的时间 */
- (void)webPageTimeWithTimeInterval:(NSTimeInterval)time;
@end
