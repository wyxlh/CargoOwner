//
//  UIControl+Tracking.m
//  YFKit
//
//  Created by 王宇 on 2018/10/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "UIControl+Tracking.h"
#import <objc/runtime.h>
#import <UMAnalytics/MobClick.h>

@implementation UIControl (Tracking)

//+ (void)load
//{
//    method_exchangeImplementations(class_getInstanceMethod(self, @selector(sendAction:to:forEvent:)), class_getInstanceMethod(self, @selector(tracking_sendAction:to:forEvent:)));
//}
//
//- (void)tracking_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
//
//{
//    [self tracking_sendAction:action to:target forEvent:event];
//    if ( [self isKindOfClass:[UIButton class]]) {
//        UIButton *TrackingBtn = (UIButton *)self;
//        if([TrackingBtn.titleLabel.text isEqualToString:@"查看签收单"]){
//            [MobClick event:@"LOOKORDER"];
//        }else if ([TrackingBtn.titleLabel.text isEqualToString:@"确认发布"]) {
//            [MobClick event:@"PostSourceOfGoods"];
//        }else if ([TrackingBtn.titleLabel.text isEqualToString:@"确认下单"]) {
//            [MobClick event:@"AssignOrders"];
//        }else if ([TrackingBtn.titleLabel.text isEqualToString:@"新建"]){
//            [MobClick event:@"NEWCREATE" attributes:@{@"new":@"isNew"}];
//        }
//
//    }
//}

@end
