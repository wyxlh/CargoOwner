//
//  YukiWebViewController.m
//  YukiFramework
//
//  Created by 王宇 on 2018/1/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YukiWebViewController.h"
@interface YukiWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@end

@implementation YukiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
}

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.webProgressLayer startLoad];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.webProgressLayer finishedLoadWithError:nil];
}
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
     [self.webProgressLayer finishedLoadWithError:error];
}
#pragma mark webView
-(WKWebView *)webView{
    if (!_webView) {
        _webView                                = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight)];
        _webView.navigationDelegate             = self;
        _webView.UIDelegate                     = self;
        _webView.backgroundColor                = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark webProgressLayer

-(YukiWebProgressLayer *)webProgressLayer{
    if (!_webProgressLayer) {
        _webProgressLayer                        = [[YukiWebProgressLayer alloc]init];
        _webProgressLayer.frame                  =CGRectMake(0, 42, ScreenWidth, 3);
        _webProgressLayer.strokeColor            = self.progressColor == nil ? [UIColor blueColor].CGColor : self.progressColor.CGColor;
    }
    return _webProgressLayer;
}

-(void)setProgressColor:(UIColor *)progressColor{
    self.webProgressLayer.strokeColor            = progressColor == nil ? NavColor.CGColor : progressColor.CGColor;
}

-(void)backButtonClick:(UIButton *)sender{
    [self.webView canGoBack] ? [self.webView goBack] : [self goBack];
}


- (void)dealloc {
    [self.webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}


@end
