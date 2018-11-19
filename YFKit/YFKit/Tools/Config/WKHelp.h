//
//  WKHelp.h
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#ifndef WKHelp_h
#define WKHelp_h

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
// Tabbar 高度
#define TabbarHeight (ScreenHeight == 812.0 ? 83.0f : 49.0f)

//导航栏高度
#define NavHeight (ScreenHeight == 812.0 ? 88.0f : 64.0f)

#define ISIPHONEX   (ScreenHeight == 812.0 ? YES : NO)

#define XHEIGHT     24

#define BTNFONT     [UIFont systemFontOfSize:16]

//高德地图
#define APIKey  @"42b538796dbed8a67a7cc039ba65e5a3"

//Bugly
#define BuglyAppId   @"4c48d87c88"

//友盟APPKey 新:5baf2858f1f556b84300026c  旧:5b04c2bdf43e4858b8000157
#define UmengAppKey   @"5baf2858f1f556b84300026c"
#define UmengURL      @"http://www.umeng.com/social"

//微信的Key
#define WXAppId       @"wxc0c909b2c7115c26"
#define WXappSecret   @"417ad431b751bf366c5bcdabadf8d367"

//自定义颜色
#define CustomColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define YFWindow        [UIApplication sharedApplication].keyWindow

// 设置view的圆角和边框
#define SKViewsBorder(View,radius,width,color)\
\
[View.layer setCornerRadius:(radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(width)];\
[View.layer setBorderColor:[color CGColor]];

#pragma mark ---------------------------------LOG--------------------------------------------------
//打印Log
#ifdef DEBUG
#define DLog( s, ... )                          NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#pragma mark --------------------------------------Notification and UserDefaults-------------------

#define  YFNotificationCenter [NSNotificationCenter defaultCenter]
#define  YFUserDefaults       [NSUserDefaults  standardUserDefaults]

#pragma mark ------------------------------Bolck Self--------------------------------------------------
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//常用的宏
#define CODE_ZERO baseModel.code.integerValue == 0

//用户登录账号重复
#define CODE_REPEAT baseModel.code.integerValue == 2501

//token失效
#define CODE_TOKEN baseModel.code.integerValue == 2100

//是否是组织登录
#define isMode [[YFUserDefaults objectForKey:@"isModel"] boolValue]

//判断登录
#define isLogin [UserData isUserLogin]

//是否是货主会员
#define IS_CARGO_OWNER [[UserData userInfo].memberType isEqualToString:@"008"]

#define USERPHONE [YFUserDefaults objectForKey:@"USERPHONE"]

//主题色
#define NavColor UIColorFromRGB(0x0078E5)

//AlertContrller 确认按钮颜色
#define ConfirmColor  UIColorFromRGB(0xff6600)

//AlertController 取消按钮颜色
#define CancelColor   UIColorFromRGB(0x03a9f4)

//蓝色按钮颜色
#define BlueBtnColor  UIColorFromRGB(0x0078E5)

//橙色按钮颜色
#define OrangeBtnColor  UIColorFromRGB(0xF16623)

//灰色
#define GrayColor   UIColorFromRGB(0xBFBFC3)

//alert Title 提示语
#define wenxinTitle @""

// 用户没有登录
#define KUSERNOTLOGIN if (![UserData isUserLogin]) {\
[YFLoginModel loginWithLoginModeType:0 loginSuccess:^{} loginFailure:^{}];\
return ;\
}

#pragma mark ----------------------------------尺寸---------------------------------------------
#define IS_IPHONE6P         CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(1242, 2208))
#define IS_IPHONE6          CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(750, 1334))
#define IS_IPHONE5          CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))
#define IS_IPHONE4          CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 960))

#endif /* WKHelp_h */
