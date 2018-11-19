//
//  WKTabbarController.m
//  WKKit
//
//  Created by 王宇 on 16/9/13.
//  Copyright © 2016年 王宇. All rights reserved.
//
#import "WKTabbarController.h"
#import "YFHomeViewController.h"
#import "YFAllOrderViewController.h"
#import "YFUserCenterViewController.h"
#import "WKNavigationController.h"
#import "YFGoodsAndSpecialLineViewController.h"
#import "YFFindCarFatherViewController.h"

@interface WKTabbarController ()<UITabBarControllerDelegate>

@end

@implementation WKTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.tintColor                           =UIColorFromRGB(0x004197);
    self.delegate                                   = self;
    [self addChildViewControllers];
}

- (void) addChildViewControllers {
    
    YFHomeViewController *homeVC                    = [[YFHomeViewController alloc] init];
    
    YFFindCarFatherViewController *findVC           = [[YFFindCarFatherViewController alloc]init];
    
    YFGoodsAndSpecialLineViewController *Source     = [[YFGoodsAndSpecialLineViewController alloc] init];
    
    YFUserCenterViewController *usercenterVC        = [[YFUserCenterViewController alloc] init];
    
    
    [self addChildVC:homeVC normalImageName:@"TabbarUnHome" selectedImageName:@"TabbarSelectHome" title:@"首页"];
    
    [self addChildVC:findVC normalImageName:@"TabbarUnCar" selectedImageName:@"TabbarSelectCar" title:@"车场"];
    
    [self addChildVC:Source normalImageName:@"TabbarUnSource" selectedImageName:@"TabbarSelectSource" title:@"货源"];
    
    [self addChildVC:usercenterVC normalImageName:@"TabbarUnUserCenter" selectedImageName:@"TabbarSelectUserCenter" title:@"我的"];
}

+ (void)initialize {
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x9FA0A1),NSFontAttributeName : [UIFont systemFontOfSize:11.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x0074E6),NSFontAttributeName : [UIFont systemFontOfSize:11.0f]} forState:UIControlStateSelected];
    
}

/**
 添加子控制器
 
 @param vc                子控制器
 @param normalImageName   普通状态下图片
 @param selectedImageName 选中图片
 */
- (void)addChildVC: (UIViewController *)vc normalImageName: (NSString *)normalImageName selectedImageName:(NSString *)selectedImageName  title:(NSString *)title {
    
    WKNavigationController *nav             = [[WKNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem                          = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:normalImageName] selectedImage:[UIImage imageNamed:selectedImageName]];
    nav.tabBarItem.titlePositionAdjustment  = UIOffsetMake(0.0f, -3.0f);
    [self addChildViewController:nav];
    
}

/**
 *  指定选中这个Tabbar
 *
 */
-(void)appointTabbarIndex:(NSInteger)index{
    
    NSInteger number = self.viewControllers.count;
    if (index >= number|| index<0) {
    }else{
        [self setSelectedIndex:index];
        //        UIViewController *vc    = self.viewControllers[index];
        //        _tb.postImageBtn.hidden = ![self isPostMessageVC:vc];
    }
    
}

/**
 *  指定哪一个Tabbar上面有一个小红点。为0 就不显示了
 *
 *  @param badgeValue 数量
 *  @param index      index
 */
-(void)appointbadgeValue:(NSInteger)badgeValue toIndex:(NSInteger)index{
    
    if (badgeValue!=0) {
        NSInteger number = self.viewControllers.count;
        if (index<number) {
            UIViewController *VC = [self.viewControllers objectAtIndex:index];
            VC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)badgeValue];
        }
    } else {
        NSInteger number = self.viewControllers.count;
        if (index<number) {
            UIViewController *VC = [self.viewControllers objectAtIndex:index];
            VC.tabBarItem.badgeValue = nil;
        }
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"货源"]) {
        [YFLoginModel loginWithLoginModeType:1 loginSuccess:^{} loginFailure:^{}];
    }
}



@end
