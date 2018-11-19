//
//  YFBaseViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
#import "YFLoginViewController.h"
#import <UMAnalytics/MobClick.h>

@interface YFBaseViewController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation YFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.navigationController viewControllers].count>1) {
        [self addBackItem];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",self.class]];
    if (![WKRequest YFNetWorkReachability]) {
        [self.view addSubview:self.noNetView];
        [self.view bringSubviewToFront:self.noNetView];
    }else{
        [self.noNetView removeFromSuperview];
    }
    //设置导航栏颜色 白色 UIBarStyleDefault 黑色 UIBarStyleBlack 白色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",self.class]];
}

/**
 加载返回按钮,在第一层的时候就不需要加调用
 */
-(void)addBackItem{
    [self.backItem setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
}
/**
 返回按钮
 */
-(UIButton *)backItem{
    if (!_backItem) {
        _backItem                                = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backItem addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backItem.width                          = _backItem.height = 30;
        UIBarButtonItem *leftItem                = [[UIBarButtonItem alloc]initWithCustomView:_backItem];
        self.navigationItem.leftBarButtonItem    = leftItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    return _backItem;
}

/**
 没有网络的情况
 */
- (YFNoNetView *)noNetView{
    if (!_noNetView) {
        _noNetView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNoNetView" owner:nil options:nil] lastObject];
        _noNetView.frame                          = CGRectMake(0, 0, ScreenWidth, 45);
        _noNetView.autoresizingMask               = 0;
    }
    return _noNetView;
}

/**
 返回
 */
-(void)backButtonClick:(UIButton *)sender{
    [self goBack];
}

-(UIButton *)leftTitleBtn{
    if (!_leftTitleBtn) {
        _leftTitleBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftTitleBtn addTarget:self action:@selector(leftTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *titleItem                = [[UIBarButtonItem alloc]initWithCustomView:_leftTitleBtn];
        self.navigationItem.leftBarButtonItem     = titleItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    return _leftTitleBtn;
}

/**
 传入你需要的文字
 
 @param leftTitleBtnName leftTitleBtnName
 */
-(void)addLeftTitleBtn:(NSString *)leftTitleBtnName{
    if (leftTitleBtnName.length != 0)
    {
        if (_backItem != nil) {
            [_backItem removeFromSuperview];
        }
        [self.leftTitleBtn setTitle:leftTitleBtnName forState:UIControlStateNormal];
    }
}

-(UIButton *)leftImageBtn{
    if (!_leftImageBtn) {
        _leftImageBtn                              = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftImageBtn addTarget:self action:@selector(leftImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *titleItem                 = [[UIBarButtonItem alloc]initWithCustomView:_leftImageBtn];
        self.navigationItem.leftBarButtonItem      = titleItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    return _leftImageBtn;
}

/**
 传入你的图片名字
 
 @param leftImageBtnName leftImageBtnName
 */
-(void)addLeftImageBtn:(NSString *)leftImageBtnName{
    if (leftImageBtnName.length != 0)
    {
        if (_backItem != nil) {
            [_backItem removeFromSuperview];
        }
        [self.leftImageBtn setImage:[UIImage imageNamed:leftImageBtnName] forState:UIControlStateNormal];
    }
}

-(UIButton *)rightTitleBtn{
    if (!_rightTitleBtn) {
        _rightTitleBtn                                = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightTitleBtn.titleLabel.font                = BTNFONT;
        [_rightTitleBtn addTarget:self action:@selector(rightTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *titleItem                    = [[UIBarButtonItem alloc]initWithCustomView:_rightTitleBtn];
        self.navigationItem.rightBarButtonItem        = titleItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    return _rightTitleBtn;
}

/**
 传入你需要的文字
 
 @param rightTitleBtnName rightTitleBtnName
 */
-(void)addRightTitleBtn:(NSString *)rightTitleBtnName{
    if (rightTitleBtnName.length != 0) {
        [self.rightTitleBtn setTitle:rightTitleBtnName forState:UIControlStateNormal];
    }
}

-(UIButton *)rightImageBtn{
    if (!_rightImageBtn) {
        _rightImageBtn                                = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightImageBtn addTarget:self action:@selector(rightImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *titleItem                    = [[UIBarButtonItem alloc]initWithCustomView:_rightImageBtn];
        self.navigationItem.rightBarButtonItem        = titleItem;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    return _rightImageBtn;
}

/**
 传入图片名字
 
 @param rightImageBtnName rightImageBtnName
 */
-(void)addRightImageBtn:(NSString *)rightImageBtnName{
    if (rightImageBtnName.length != 0) {
        [self.rightImageBtn setImage:[UIImage imageNamed:rightImageBtnName] forState:UIControlStateNormal];
    }
}

#pragma mark  右边的按钮

-(UIButton *)rightItem1{
    if (!_rightItem1) {
        _rightItem1                                      = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightItem1 addTarget:self action:@selector(rightItem1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem1;
}

-(UIButton *)rightItem2{
    if (!_rightItem2) {
        _rightItem2                                      = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightItem2 addTarget:self action:@selector(rightItem2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightItem2;
}

/**
 添加右边的按钮
 
 @param items 你需要在右边添加几个按钮 这里最多只能添加2个
 @param rightItem1Name 第一个按钮
 @param isImage1 是否是图片
 @param rightItem2Name 第二个按钮
 @param isImage2 是否是图片
 */
-(void)addRightItems:(NSInteger )items rightItem1Name:(NSString *)rightItem1Name isImage1:(BOOL)isImage1 rightItem2:(NSString *)rightItem2Name isImage2:(BOOL)isImage2{
    if (rightItem1Name.length != 0) {
        if (isImage1) {
            [self.rightItem1 setImage:[UIImage imageNamed:rightItem1Name] forState:UIControlStateNormal];
        }else{
            [self.rightItem1 setTitle:rightItem1Name forState:UIControlStateNormal];
        }
    }
    if (rightItem2Name.length != 0) {
        if (isImage2) {
            [self.rightItem2 setImage:[UIImage imageNamed:rightItem2Name] forState:UIControlStateNormal];
        }else{
            [self.rightItem2 setTitle:rightItem2Name forState:UIControlStateNormal];
        }
    }
    if (items == 2) {
        UIBarButtonItem *rightItem1                       = [[UIBarButtonItem alloc]initWithCustomView:self.rightItem1];
        UIBarButtonItem *rightItem2                       = [[UIBarButtonItem alloc]initWithCustomView:self.rightItem2];
        self.navigationItem.rightBarButtonItems           = @[rightItem1,rightItem2];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }else{
        UIBarButtonItem *rightItem1                       = [[UIBarButtonItem alloc]initWithCustomView:self.rightItem1];
        self.navigationItem.rightBarButtonItem            = rightItem1;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
}

/**
 返回
 */
-(void)goBack{
    NSArray* vcarr = [self.navigationController viewControllers];
    if (vcarr.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

/**
 隐藏导航栏
 */
-(void)hiddenNavBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 显示导航栏
 */
-(void)showNavBar{
    [self.navigationController setNavigationBarHidden: NO animated:YES];
}

/**
 *  隐藏Tabbar
 */
-(void)hidenTabBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:1];
        AppDelegate *Delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _tabbar = Delegate.tabbar;
        _tabbar.tabBar.frame = CGRectMake(-ScreenWidth, _tabbar.tabBar.frame.origin.y, _tabbar.tabBar.frame.size.width, TabbarHeight);
    }];
}

/**
 *  显示Tabbar
 */
-(void)showTabBar{
    
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:1];
        AppDelegate *Delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _tabbar = Delegate.tabbar;
        _tabbar.tabBar.frame=CGRectMake(0, _tabbar.tabBar.frame.origin.y, _tabbar.tabBar.frame.size.width, TabbarHeight);
        
    }];
}

/**
 设置根视图
 */
-(void)setRootViewController{
//    if (!isLogin) {
//        YFLoginViewController *login        = [YFLoginViewController new];
//        [UIApplication sharedApplication].keyWindow.rootViewController   = [[UINavigationController alloc]initWithRootViewController:login];
//        CATransition *anim = [CATransition animation];
//        ////转场动画持续时间
//        anim.duration = 0.5;//reveal rippleEffect fade oglFlip
//        ////转场动画类型 @"cube"---立方体   @"suckEffect"  吸走的效果  @"oglFlip" 前后翻转效果  @"rippleEffect" 波纹效果  @"pageCurl" 翻页起来  @"pageUnCurl" 翻页下来   @"cameraIrisHollowOpen " 镜头开 @"cameraIrisHollowClose " 镜头关
//        anim.type = @"rippleEffect";
//        //转场动画将去的方向
//        anim.subtype = kCATransitionFromRight;
//        [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
//    }else{
        //创建window
        UIWindow *window                        = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window                             = window;
        [self.window setBackgroundColor:[UIColor whiteColor]];
        if (!self.tabbar) {
            AppDelegate *Delegate               = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.tabbar                         = [[WKTabbarController alloc] init];
            self.tabbar.delegate                = (id)self;
            [UIApplication sharedApplication].keyWindow.rootViewController = self.tabbar;
            Delegate.tabbar                     = self.tabbar;
        }
        CATransition *anim = [CATransition animation];
        ////转场动画持续时间
        anim.duration = 0.5;//reveal rippleEffect fade oglFlip
        anim.type = @"cube";
        //转场动画将去的方向
        anim.subtype = kCATransitionFromRight;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
//    }
   
}

-(void)leftTitleButtonClick:(UIButton *)sender{
    DLog(@"用到文字的时候重写leftTitleButtonClick方法");
}

-(void)leftImageButtonClick:(UIButton *)sender{
    DLog(@"用到图片的时候重写leftImageButtonClick方法");
}

-(void)rightTitleButtonClick:(UIButton *)sender{
    DLog(@"用到图片的时候重写rightTitleButtonClick方法");
}

-(void)rightImageButtonClick:(UIButton *)sender{
    DLog(@"用到图片的时候重写rightImageButtonClick方法");
}

-(void)rightItem1ButtonClick:(UIButton *)sender{
    DLog(@"调用同时添加两个的按钮的时候第一个按钮点击事件");
}

-(void)rightItem2ButtonClick:(UIButton *)sender{
    DLog(@"调用同时添加两个的按钮的时候第二个按钮点击事件");
}
/**
 选中的 tabbar
 
 @param index  第几个
 */
-(void)selectTabbarIndex:(NSInteger )index{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.tabbar appointTabbarIndex:index];
}

/**
 *  指定哪一个Tabbar上面有一个小红点。为0 就不显示了
 *
 *  @param badgeValue 数量
 *  @param index      index
 */
-(void)selectBadgeValue:(NSInteger)badgeValue toIndex:(NSInteger)index{
    AppDelegate *Delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [Delegate.tabbar appointbadgeValue:badgeValue toIndex:index];
}

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
                       confirmBlock:(void (^)(void))confirmBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x747474) range:NSMakeRange(0, [[hogan string] length])];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    NSMutableAttributedString *messages = [[NSMutableAttributedString alloc] initWithString:message];
    [messages addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [[messages string] length])];
    [messages addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x747474) range:NSMakeRange(0, [[messages string] length])];
    [alert setValue:messages forKey:@"attributedMessage"];
    
    [cancel setValue:cancelTextColor forKey:@"_titleTextColor"];
    [confirm setValue:confirmTextColor forKey:@"_titleTextColor"];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showActionViewControllerTitle:(NSString *)title
                             Message:(NSString *)message
                         CancelTitle:(NSString *)cancelTitle
                          FirstTitle:(NSString *)firstTitle
                         SecondTitle:(NSString *)secondTitle
                         cancelBlock:(void (^)(void))cancelBlock
                          FirstBlock:(void (^)(void))firstBlock
                         SecondBlock:(void (^)(void))secondBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *first = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (firstBlock) {
            firstBlock();
        }
    }];
    
    UIAlertAction *second = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (secondBlock) {
            secondBlock();
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:first];
    [alert addAction:second];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
