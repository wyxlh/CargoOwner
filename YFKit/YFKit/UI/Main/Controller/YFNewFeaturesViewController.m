//
//  YFNewFeaturesViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/22.
//  Copyright © 2018年 wy. All rights reserved.
//
#define SKImageCount 3

#import "YFNewFeaturesViewController.h"
#import "WKTabbarController.h"
#import "AppDelegate.h"
#import "YFLoginViewController.h"
@interface YFNewFeaturesViewController ()<UIScrollViewDelegate>
@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, weak)UIPageControl *pageControll;
@end

@implementation YFNewFeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化scrollView
    [self setupScrollView];
    
    // 初始化UIPageControl
    [self setupPageControl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnY = 20;
    CGFloat btnX = self.view.frame.size.width - btnW;
    btn.frame = CGRectMake(btnX, ISIPHONEX ? btnY + XHEIGHT: btnY , btnW, btnH);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"点击跳过" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(changeControll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

// 初始化ScrollView
- (void)setupScrollView
{
    UIScrollView *scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroView.contentSize = CGSizeMake(SKImageCount*self.view.frame.size.width, 0);
    scroView.pagingEnabled = YES;
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.delegate = self;
    scroView.bounces = NO;
    [self.view addSubview:scroView];
    self.scrollView = scroView;
    
    for (int i = 0 ; i< SKImageCount; i ++) {
        NSString *name;
        if (ISIPHONEX) {
            name = [NSString stringWithFormat:@"beginX%d",i+1];
        }else{
            name = [NSString stringWithFormat:@"begin%d",i+1];
        }
        UIImage *image = [UIImage imageNamed:name];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageview.image = image;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [scroView addSubview:imageview];
        imageview.userInteractionEnabled = YES;
        if (i == SKImageCount-1) {
            [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeControll)]];
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.backgroundColor = UIColorFromRGB(0x0C76FF);
            btn2.layer.cornerRadius = 5;
            CGFloat btn2W = 150;
            CGFloat btn2H = 35;
            CGFloat btn2Y = self.view.frame.size.height-100;
            CGFloat btn2X = self.view.frame.size.width*(SKImageCount-1)+(self.view.frame.size.width-btn2W)*0.5;
            [btn2 setTitle:@"立即体验" forState:UIControlStateNormal];
            btn2.frame = CGRectMake(btn2X, btn2Y, btn2W, btn2H);
            [btn2 addTarget:self action:@selector(changeControll) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:btn2];
        }
    }
}

// 初始化pageController
- (void)setupPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, self.view.frame.size.height-20, self.view.frame.size.width, 20);
    pageControl.numberOfPages = SKImageCount;
    pageControl.currentPageIndicatorTintColor = NavColor;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    self.pageControll = pageControl;
}


#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControll.currentPage = (scrollView.contentOffset.x+self.view.frame.size.width/2)/self.view.frame.size.width;
}

- (void)changeControll
{
    //如果没有登录
    [self setRootViewController];

    
}


#pragma mark 设置导航栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
