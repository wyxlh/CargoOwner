//
//  YFLoginViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

typedef NS_ENUM(NSInteger, YFLoginModeType) {
    YFLoginModeNormalType,//正常返回
    YFLoginModeSpecialType,//返回到首页
};

@interface YFLoginViewController : YFBaseViewController
/**
 上层控制器 如果为 YFLoginModeViewController 则直接执行 dismiss方法
 */
@property (nonatomic, strong) UIViewController *upViewController;
/**
 是否退出登录
 */
@property (nonatomic, assign) BOOL isLoginOut;
/**
 跳转返回
 */
@property (nonatomic, assign) YFLoginModeType modeType;
/**
 登录成功
 */
@property (nonatomic, copy) void (^loginSuccessBlock)(void);
/**
 登录失败
 */
@property (nonatomic, copy) void (^loginFailureBlock)(void);
@end
