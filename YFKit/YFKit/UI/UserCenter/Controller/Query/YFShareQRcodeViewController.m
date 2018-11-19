//
//  YFShareQRcodeViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/10/22.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFShareQRcodeViewController.h"

@interface YFShareQRcodeViewController ()

@end

@implementation YFShareQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NavColor;
    self.backItem.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = NavColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)clickDisapper:(id)sender {
    [self goBack];
}

#pragma mark 设置导航栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
