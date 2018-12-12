//
//  YukiWebViewController.h
//  YukiFramework
//
//  Created by 王宇 on 2018/1/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
#import <WebKit/WebKit.h>
#import "YukiWebProgressLayer.h"

@interface YukiWebViewController : YFBaseViewController
/**
 进度条
 */
@property (nonatomic, strong)YukiWebProgressLayer *webProgressLayer;
/**
 webView
 */
@property (nonatomic, strong) WKWebView *webView;
/**
 网址链接
 */
@property (nonatomic, copy)   NSString  *urlString;
/**
 进度条颜色
 */
@property (nonatomic, strong) UIColor   *progressColor;

@end
