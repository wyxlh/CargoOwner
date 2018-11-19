//
//  YFToast.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFToast : NSObject
+ (void)showMessage:(NSString *)msg;
+ (void)showMessage:(NSString *)msg inView:(UIView *)view;
+ (void)showMessage:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration;
@end
