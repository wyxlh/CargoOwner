//
//  YFPrivacyViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/10/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPrivacyViewController.h"

@interface YFPrivacyViewController ()

@end

@implementation YFPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title              = @"隐私政策";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.yuanfusc.com/privacyPolicy/consignor.html"]]];
    self.progressColor      = NavColor;
}

@end
