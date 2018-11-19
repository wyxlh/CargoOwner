//
//  YFToast.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFToast.h"
#import <objc/runtime.h>
@implementation YFToast

+ (void)showMessage:(NSString *)msg{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [YFToast showMessage:msg inView:window.rootViewController.view duration:2.0f];
}

+ (void)showMessage:(NSString *)msg inView:(UIView *)view
{
    [YFToast showMessage:msg inView:view duration:2.0f];
}

+ (void)showMessage:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration
{
    if(view && msg && duration > 0)
    {
        UILabel *lb = (UILabel *)objc_getAssociatedObject(view, @"Message");
        if(!lb)
        {
            lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260.0f, 2000.0f)];
            lb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95f];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont boldSystemFontOfSize:14];
            lb.numberOfLines = 0;
            lb.layer.masksToBounds = YES;
            lb.layer.cornerRadius = 3.0f;
            lb.layer.shouldRasterize = YES;
            
            [view addSubview:lb];
            objc_setAssociatedObject(view, @"Message", lb, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            __block UILabel *blockLabel = lb;
            double delayInSeconds = duration;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [blockLabel removeFromSuperview];
                objc_setAssociatedObject(view, @"Message", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            });
        }
        
        [view bringSubviewToFront:lb];
        
        CGSize vwSize = view.bounds.size;
        CGSize lbSize =  [msg boundingRectWithSize:CGSizeMake(ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        lbSize.width = MIN(260.0f, MAX(60.0f, lbSize.width + 20.0f));
        lbSize.height = MIN(120.0f, MAX(30.0f, lbSize.height + 20.0f));
        lb.frame = CGRectMake(0, 0, lbSize.width, lbSize.height);
        lb.center = CGPointMake(vwSize.width / 2.0f, vwSize.height * 0.45);
        lb.text = msg;
        
    }
}


@end
