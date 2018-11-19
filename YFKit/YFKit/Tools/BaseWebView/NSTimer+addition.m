//
//  NSTimer+addition.m
//  YukiFramework
//
//  Created by 王宇 on 2018/1/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "NSTimer+addition.h"

@implementation NSTimer (addition)
- (void)pauseTime{
    //判断定时器是否有效
    if (!self.isValid)  {
        return;
    }
    //停止计时器
    [self  setFireDate:[NSDate distantFuture]];
}
- (void)webPageTime{
    //判断定时器是否有效
    if (!self.isValid)  {
        return;
    }
    //返回当期时间
    [self setFireDate:[NSDate date]];
}
- (void)webPageTimeWithTimeInterval:(NSTimeInterval)time{
    //判断定时器是否有效
    if (!self.isValid)  {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
}
@end
