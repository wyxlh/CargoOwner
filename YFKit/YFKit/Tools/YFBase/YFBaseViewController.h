//
//  YFBaseViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WKTabbarController.h"
#import "YFNoNetView.h"

@interface YFBaseViewController : UIViewController
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic,strong) WKTabbarController *tabbar;
/**
 网络异常
 */
@property (nonatomic, strong, nullable) YFNoNetView *noNetView;
/**
 返回按钮
 */
@property (nonatomic, strong) UIButton *backItem;

/**
 加载返回按钮,在第一层的时候就不需要加调用
 */
- (void)addBackItem;

/**
 左边的按钮 传Title的时候
 */
@property (nonatomic, strong) UIButton *leftTitleBtn;

/**
 用的时候需要重写此方法
 
 @param leftTitleBtnName 填你需要的文字
 */
-(void)addLeftTitleBtn:(NSString *)leftTitleBtnName;

/**
 左边的按钮 传图片名的时候
 */
@property (nonatomic, strong) UIButton *leftImageBtn;

/**
 用的时候需要重写此方法
 
 @param leftImageBtnName 填你需要的图片名
 */
-(void)addLeftImageBtn:(NSString *)leftImageBtnName;

/**
 右边的按钮 传 Title的时候
 */
@property (nonatomic,strong) UIButton *rightTitleBtn;

/**
 用的时候需要重写此方法
 
 @param rightTitleBtnName 填你需要的文字
 */
-(void)addRightTitleBtn:(NSString *)rightTitleBtnName;

/**
 右边的按钮 传 图片名字的时候
 */
@property (nonatomic,strong) UIButton *rightImageBtn;

/**
 用的时候需要重写此方法
 
 @param rightImageBtnName 填你需要的图片名
 */
-(void)addRightImageBtn:(NSString *)rightImageBtnName;

#pragma mark 右边按钮

@property (nonatomic, strong) UIButton *rightItem1;

@property (nonatomic, strong) UIButton *rightItem2;

/**
 添加右边的按钮
 
 @param items 你需要在右边添加几个按钮 这里最多只能添加2个
 @param rightItem1Name 第一个按钮
 @param isImage1 是否是图片
 @param rightItem2Name 第二个按钮
 @param isImage2 是否是图片
 */
-(void)addRightItems:(NSInteger )items rightItem1Name:(NSString *)rightItem1Name isImage1:(BOOL )isImage1 rightItem2:(NSString *)rightItem2Name isImage2:(BOOL ) isImage2;

#pragma mark 几种按钮的点击方法

-(void)backButtonClick:(UIButton *)sender;

-(void)leftTitleButtonClick:(UIButton *)sender;

-(void)leftImageButtonClick:(UIButton *)sender;

-(void)rightTitleButtonClick:(UIButton *)sender;

-(void)rightImageButtonClick:(UIButton *)sender;

-(void)rightItem1ButtonClick:(UIButton *)sender;

-(void)rightItem2ButtonClick:(UIButton *)sender;

/**
 *  返回
 */
- (void)goBack;

/**
 隐藏导航栏
 */
-(void)hiddenNavBar;

/**
 显示导航栏
 */
-(void)showNavBar;

/**
 *  隐藏Tabbar
 */
-(void)hidenTabBar;

/**
 *  显示Tabbar
 */
-(void)showTabBar;
/**
 设置根视图
 */
-(void)setRootViewController;

/**
 选的那个 tabbar
 
 @param index 选中第几个
 */
-(void)selectTabbarIndex:(NSInteger )index;

/**
 *  指定哪一个Tabbar上面有一个小红点。为0 就不显示了
 *
 *  @param badgeValue 数量
 *  @param index      index
 */
-(void)selectBadgeValue:(NSInteger)badgeValue toIndex:(NSInteger)index;

/**
 AlertViewController
 因为需求的原因 取消和确认换了位置
 @param title title
 @param message  内容
 @param cancelTitle 取消 Title
 @param cancelTextColor 取消 颜色
 @param confirmTitle  确认 Title
 @param confirmTextColor  确认  颜色
 @param cancelBlock cancelBlock description
 @param confirmBlock confirmBlock description
 */
-(void)showAlertViewControllerTitle:(NSString *)title
                            Message:(NSString *)message
                        CancelTitle:(NSString *)cancelTitle
                    CancelTextColor:(UIColor *)cancelTextColor
                       ConfirmTitle:(NSString *)confirmTitle
                   ConfirmTextColor:(UIColor *)confirmTextColor
                        cancelBlock:(void (^)(void))cancelBlock
                       confirmBlock:(void (^)(void))confirmBlock;

-(void)showActionViewControllerTitle:(NSString *)title
                             Message:(NSString *)message
                         CancelTitle:(NSString *)cancelTitle
                          FirstTitle:(NSString *)firstTitle
                         SecondTitle:(NSString *)secondTitle
                         cancelBlock:(void (^)(void))cancelBlock
                          FirstBlock:(void (^)(void))firstBlock
                         SecondBlock:(void (^)(void))secondBlock;

NS_ASSUME_NONNULL_END
@end
