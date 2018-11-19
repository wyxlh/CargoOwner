
//  AppDelegate.m
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

 #define  key  @"CFBundleShortVersionString"

#import "AppDelegate.h"
#import "YFLoginViewController.h"
#import "SKAppUpdaterView.h"
#import "YFNewFeaturesViewController.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self configureAPIKey];
    [self createTabbar];
    [self configureKeyboardManager];
    [self configBugly];
    [self updataVersion];
    [self configureUmengKeyManger];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//禁用第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self applicationOpenURL:url];
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    return [self applicationOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [self applicationOpenURL:url];
}

- (BOOL)applicationOpenURL:(NSURL *)url
{
//    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",WXAppId]].location == 0) {
//        //微信支付
////        return [WXApi handleOpenURL:url delegate:self];
//    }else if ([[url absoluteString] containsString:@"safepay"]){
//        //支付宝
////        [self configureForAliPay:url];
//    }else{
        //友盟
        return [[UMSocialManager defaultManager] handleOpenURL:url];
//    }
}

#pragma mark 创建tabbar
-(void)createTabbar{
    //去掉导航栏的黑线
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //创建window
    UIWindow *window                         = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window                              = window;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    if (!self.tabbar) {
        self.tabbar                          = [[WKTabbarController alloc] init];
        self.tabbar.delegate                 = (id)self;
    }
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults                 = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion                    = [defaults stringForKey:key];
    // 获得当前软件的版本号
    NSString *currentVersion                 = [NSString getAppVersion];
    
    if ([lastVersion isEqualToString:currentVersion]){
        //如果没有登录
//        if ([UserData isUserLogin]) {
            [self.window setRootViewController:self.tabbar];
//        }else{
//            YFLoginViewController *login     = [YFLoginViewController new];
//            self.window.rootViewController   = [[UINavigationController alloc]initWithRootViewController:login];
//        }
    }else{
        self.window.rootViewController       = [[YFNewFeaturesViewController alloc] init];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
    
    [self.window makeKeyAndVisible];
    
}

#pragma mark 高德地图
- (void)configureAPIKey
{
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

#pragma mark - 键盘管理对象
- (void)configureKeyboardManager{
    // 获取类库的单例变量
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    keyboardManager.enable = YES;
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    // 设置工具条颜色
    keyboardManager.toolbarTintColor = NavColor;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = YES;
    // 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder = YES;
}

#pragma mark  bugly
-(void)configBugly{
    [Bugly startWithAppId:BuglyAppId];
}

#pragma mark - 注册友盟分享
-(void)configureUmengKeyManger{
    
    [UMConfigure initWithAppkey:UmengAppKey channel:@"App Store"]; // required
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppId appSecret:WXappSecret redirectURL:nil];
    
}

#pragma mark  版本更新
-(void)updataVersion{
    [WKRequest isHiddenActivityView:YES];
    @weakify(self)
    [WKRequest getWithURLString:@"system/2/version.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSString *version          = [NSString stringWithFormat:@"%@",[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"version"]];
            NSString *remark           = [NSString stringWithFormat:@"%@",[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"remark"]];
            // 1 是强制更新  2 是非强制更新
            NSInteger upgradeType      = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"upgradeType"] integerValue];
            if ([self AppVersion:[NSString getAppVersion]] < [self AppVersion:version]) {
                BOOL compulsory        = upgradeType == 2 ? YES : NO;
                [self compulsoryRenewal:compulsory message:remark];
            }
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark  版本更新
-(void)compulsoryRenewal:(BOOL)compulsory message:(NSString *)msg{
    if (compulsory) {
        //强制更新
        SKAppUpdaterView *updateview   = [[[NSBundle mainBundle]loadNibNamed:@"SKAppUpdaterView" owner:self options:nil] lastObject];
        updateview.oneUpdataBtn.hidden = NO;
        updateview.cancel.hidden       = updateview.UpdateButton.hidden = YES;
        updateview.frame               = YFWindow.bounds;
        updateview.center              = YFWindow.center;
        updateview.tag                 = 123456;
        [AttributedLbl setRiChLineSpacing:updateview.contentLabel titleString:msg textColor:UIColorFromRGB(0x6A6A6A) colorRang:NSMakeRange(0, msg.length) LineSpacing:10];
        [YFWindow addSubview:updateview];
    }else{
        //非强制更新
        SKAppUpdaterView * updateview  = [[[NSBundle mainBundle]loadNibNamed:@"SKAppUpdaterView" owner:self options:nil] lastObject];
        updateview.oneUpdataBtn.hidden = YES;
        updateview.frame               = YFWindow.bounds;
        updateview.center              = YFWindow.center;
        updateview.tag                 = 123456;
        [AttributedLbl setRiChLineSpacing:updateview.contentLabel titleString:msg textColor:UIColorFromRGB(0x6A6A6A) colorRang:NSMakeRange(0, msg.length) LineSpacing:10];
        updateview.contentLabel.text   = msg;
        [YFWindow addSubview:updateview];
    }
}

#pragma mark  去除版本号的. 得到版本号
-(NSInteger )AppVersion:(NSString *)version{
    NSString *appVersion = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [appVersion integerValue];
}

@end
