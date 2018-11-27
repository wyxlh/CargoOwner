//
//  YFKeyWindow.m
//  YFKit
//
//  Created by 王宇 on 2018/5/16.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFKeyWindow.h"
#import "AppDelegate.h"
#import "WKTabbarController.h"
#import "WKNavigationController.h"
#import "YFLoginViewController.h"

static YFKeyWindow *_instance = nil;

@implementation YFKeyWindow

-(void)keyWindowRootController{
    
    AppDelegate *Delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WKTabbarController *wkTabbar = Delegate.tabbar;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if ([window.rootViewController isKindOfClass:[WKTabbarController class]]) {
        if (window.rootViewController.navigationController.childViewControllers>0) {
            [window.rootViewController.navigationController popToRootViewControllerAnimated:YES];
        }
        [window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        window.backgroundColor = [UIColor whiteColor];
        [window resignKeyWindow];
        window.rootViewController = wkTabbar;
    }
}

#pragma mark 登录
-(void)login {
    YFLoginViewController *userLogin            = [YFLoginViewController new];
    userLogin.isLoginOut                        = YES;
    AppDelegate *Delegate                       = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WKTabbarController *wkTabbar                = Delegate.tabbar;
    WKNavigationController *navUserlogin        = [[WKNavigationController alloc]initWithRootViewController:userLogin];
    [wkTabbar.selectedViewController presentViewController:navUserlogin animated:YES completion:nil];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [YFKeyWindow shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [YFKeyWindow shareInstance] ;
}

@end
