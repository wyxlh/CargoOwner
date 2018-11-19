//
//  YFGoodsAndSpecialLineViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsAndSpecialLineViewController.h"
#import "YFAllSourceGoodsViewController.h"
#import "YFAllSpecialLineViewController.h"
#import "YFReleaseViewController.h"
#import "YFSpeciallinePlanOrderViewController.h"
#import "TitleScrollView.h"

@interface YFGoodsAndSpecialLineViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) TitleScrollView *titleScroll;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger selectIndex;//当前选中的是第几个;
@end

@implementation YFGoodsAndSpecialLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    [[YFNotificationCenter rac_addObserverForName:@"JumpSpecialLineKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.titleScroll setSelectedIndex:1];
        [self titleClick:1];
    }];
    [[YFNotificationCenter rac_addObserverForName:@"JumpPostKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.titleScroll setSelectedIndex:0];
        [self titleClick:0];
    }];
}

#pragma mark  货源 专线
- (void)setUI{
    self.selectIndex                             = 0;
    [self addRightImageBtn:@"addSource"];
    [self setupChildViewControllers];
    [self setupContentView];
}

#pragma mark TitleScrollView )
-(TitleScrollView *)titleScroll{
    if (!_titleScroll) {
        @weakify(self)
        self.titleArr                            = @[@"货源",@"专线"];
        _titleScroll                             = [[TitleScrollView alloc]initWithBGColorEqualFrame:CGRectMake(ScreenWidth/2-100, 5, 200, 30) TitleArray:self.titleArr selectedIndex:0 titleFontSize:16 scrollEnable:NO lineEqualWidth:YES selectColor:UIColorFromRGB(0x0C59B3) defaultColor:[UIColor whiteColor] SelectBlock:^(NSInteger index) {
            @strongify(self)
            [self showTabBar];
            self.selectIndex                     = index;
            [self titleClick:index];
        }];
        _titleScroll.line.hidden                 = YES;
        _titleScroll.backgroundColor             = [UIColor clearColor];
        SKViewsBorder(_titleScroll, 3, 0.8, [UIColor whiteColor]);
        [self.navigationController.navigationBar addSubview:_titleScroll];
    }
    return _titleScroll;
}

#pragma mark  初始化子控制器
-(void)setupChildViewControllers {
    DLog(@"%ld",self.childViewControllers.count);
    if (self.childViewControllers.count != 0) {
        return;
    }
    
    if (isLogin) {
        YFAllSourceGoodsViewController *SourceGoods  = [YFAllSourceGoodsViewController new];
        [self addChildViewController:SourceGoods];
        
        YFAllSpecialLineViewController *Special      = [YFAllSpecialLineViewController new];
        [self addChildViewController:Special];
    }
}

#pragma mark 底部的scrollview
-(void)setupContentView {
    //不要自动调整inset
//    self.automaticallyAdjustsScrollViewInsets    = NO;
//
//    UIScrollView *contentView                    = [[UIScrollView alloc] init];
//    contentView.frame                            = CGRectMake(0, self.titleScroll.mj_h-30, ScreenWidth, ScreenHeight);
//    contentView.delegate                         = self;
//    contentView.contentSize                      = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
//    contentView.pagingEnabled                    = YES;
//    [self.view insertSubview:contentView atIndex:0];
//
//    self.contentView                             = contentView;
//    self.contentView.contentOffset               = CGPointMake(0*ScreenWidth, 0);
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:self.contentView];
    
}

- (UIScrollView *)contentView{
    if (!_contentView) {
        _contentView                             = [[UIScrollView alloc]init];
        _contentView.frame                       = CGRectMake(0, self.titleScroll.mj_h-30, ScreenWidth, ScreenHeight);
        _contentView.delegate                    = self;
        _contentView.contentSize                 = CGSizeMake(_contentView.width * self.childViewControllers.count, 0);
        _contentView.pagingEnabled               = YES;
        [self.view insertSubview:_contentView atIndex:0];
        _contentView.contentOffset               = CGPointMake(0*ScreenWidth, 0);
        
    }
    return _contentView;
}

#pragma mark 便签栏按钮点击
-(void)titleClick:(NSInteger)index {
    //滚动,切换子控制器
    CGPoint offset                               = self.contentView.contentOffset;
    offset.x                                     = index * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //添加子控制器的view
    //当前索引
    NSInteger index                              = scrollView.contentOffset.x / scrollView.width;
    self.selectIndex                             = index;
    //取出子控制器
    UIViewController *vc                         = self.childViewControllers[index];
    vc.view.x                                    = scrollView.contentOffset.x;
    vc.view.y                                    = 0;//设置控制器的y值为0(默认为20)
    vc.view.height                               = scrollView.height;//设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
    [scrollView addSubview:vc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //当前索引
    NSInteger index                             = scrollView.contentOffset.x / scrollView.width;
    //点击butto
    [self.titleScroll setSelectedIndex:index];
}

-(void)rightImageButtonClick:(UIButton *)sender{
    if (self.selectIndex == 0) {
        YFReleaseViewController *release            = [YFReleaseViewController new];
        release.hidesBottomBarWhenPushed            = YES;
        [self.navigationController pushViewController:release animated:YES];
    }else{
        WS(weakSelf)
        [self authorityWithSuccessBlock:^{
            YFSpeciallinePlanOrderViewController *plan  = [YFSpeciallinePlanOrderViewController new];
            plan.hidesBottomBarWhenPushed               = YES;
            [self.navigationController pushViewController:plan animated:YES];
        } failBlock:^{
            [YFToast showMessage:@"暂无权限" inView:weakSelf.view];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (isLogin)
    self.titleScroll.hidden                         = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isLogin){
        self.titleScroll.hidden                         = NO;
        [self setUI];
    }
    
    
    
}

-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}

/**
 验证用户是否能发专线
 */
- (void)authorityWithSuccessBlock:(void (^)(void))success failBlock:(void (^)(void))failbBlock{
    [WKRequest isHiddenActivityView:YES];
    @weakify(self)
    [WKRequest postWithURLString:@"app/special/authority.do" parameters:nil isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSString *jurisdiction = [[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"count"];
            [jurisdiction integerValue] > 0 ? success() : failbBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
            failbBlock();
        }
    } failure:^(NSError *error) {
        failbBlock();
    }];
}

@end
