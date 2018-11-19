//
//  YFFindCarFatherViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCarFatherViewController.h"
#import "YFFindCardViewController.h"
#import "YFCarSourceViewController.h"
#import "YFPlatformEmptyCarViewController.h"
#import "YFFindCarSearchBarView.h"
#import "TitleScrollView.h"
@interface YFFindCarFatherViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) TitleScrollView *titleScroll;
@property (nonatomic, strong) YFFindCarSearchBarView *searchView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger selectIndex;//当前选中的是第几个;
@end

@implementation YFFindCarFatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark  setUI ,@"平台空车"
-(void)setUI{
    self.titleArr                                = @[@"我的熟车",@"平台车源"];
    self.selectIndex                             = 1;
    [self addRightImageBtn:@"searchDriver"];
    
    //没有熟车的时候添加熟车
    @weakify(self)
    [[YFNotificationCenter rac_addObserverForName:@"addCarKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.titleScroll setSelectedIndex:1];
        [self titleClick:1];
        
    }];
    // 添加关注
    [[YFNotificationCenter rac_addObserverForName:@"AddLikeCarKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.titleScroll.hidden                   = self.rightImageBtn.hidden = NO;
        self.searchView.hidden                    = YES;
        [self.searchView.searchBar resignFirstResponder];
        [self.titleScroll setSelectedIndex:0];
        [self titleClick:0];
    }];
    //子视图刷新的时候 需要把 searchView 隐藏掉
    [[YFNotificationCenter rac_addObserverForName:@"HiddenSearchKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.titleScroll.hidden                   = self.rightImageBtn.hidden = NO;
        self.searchView.hidden                    = YES;
        self.searchView.searchBar.text            = @"";
        [self.searchView.searchBar resignFirstResponder];
    }];
    
    [[YFNotificationCenter rac_addObserverForName:@"ChooseCarMsgkeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.titleScroll.hidden                   = self.rightImageBtn.hidden = NO;
        self.searchView.hidden                    = YES;
        [self.searchView.searchBar resignFirstResponder];
    }];
    
    [self setupChildViewControllers];
    [self setupContentView];
    
}

-(void)rightImageButtonClick:(UIButton *)sender{
    [self.searchView.searchBar becomeFirstResponder];
    self.searchView.hidden                      = NO;
    self.titleScroll.hidden                     = self.rightImageBtn.hidden = YES;
    //点击右键的时候需要隐藏 sortView
    if (self.selectIndex == 0) {
         YFFindCardViewController *vc           = self.childViewControllers[self.selectIndex];
        [vc dissmissSortView];
    }else if(self.selectIndex == 1){
        YFCarSourceViewController *vc           = self.childViewControllers[self.selectIndex];
        [vc dissmissSortView];
    }
    
}

#pragma mark TitleScrollView  UIColorFromRGB(0x116ED0)
-(TitleScrollView *)titleScroll{
    if (!_titleScroll) {
        @weakify(self)
        _titleScroll                             = [[TitleScrollView alloc]initWithBGColorEqualFrame:CGRectMake(ScreenWidth/2-100, 5, 200, 30) TitleArray:self.titleArr selectedIndex:1 titleFontSize:16 scrollEnable:NO lineEqualWidth:YES selectColor:UIColorFromRGB(0x0C59B3) defaultColor:[UIColor whiteColor] SelectBlock:^(NSInteger index) {
            @strongify(self)
            if (!isLogin && index == 0) {
                [YFLoginModel loginWithLoginModeType:0 loginSuccess:^{
                    [self selectTitleScrollAndContentWithIndex:index];
                } loginFailure:^{
                    [self selectTitleScrollAndContentWithIndex:1];
                }];
                return;
            }
            [self selectTitleScrollAndContentWithIndex:index];
        }];
        _titleScroll.line.hidden                 = YES;
        _titleScroll.backgroundColor             = [UIColor clearColor];
        SKViewsBorder(_titleScroll, 3, 0.8, [UIColor whiteColor]);
        [self.navigationController.navigationBar addSubview:_titleScroll];
    }
    return _titleScroll;
}

//选中第几个页面
- (void)selectTitleScrollAndContentWithIndex:(NSInteger)index{
    self.selectIndex                              = index;
    [self.titleScroll setSelectedIndex:index];
    [self titleClick:index];
}

#pragma mark searchView 
- (YFFindCarSearchBarView *)searchView{
    if (!_searchView) {
        _searchView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFFindCarSearchBarView" owner:nil options:nil] lastObject];
        _searchView.autoresizingMask              = 0;
        _searchView.backgroundColor               = [UIColor clearColor];
        _searchView.frame                         = CGRectMake(0, 5, ScreenWidth, 30);
        @weakify(self)
        [[_searchView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.titleScroll.hidden               = self.rightImageBtn.hidden = NO;
            self.searchView.hidden                = YES;
            [self.searchView.searchBar resignFirstResponder];
            if (self.selectIndex == 0) {
                YFFindCardViewController *vc      = self.childViewControllers[0];
                if (![NSString isBlankString:self.searchView.searchBar.text]) {
                    vc.condition                  = @"";
                    [vc refreshData];
                }
            }else if(self.selectIndex ==1){
                YFCarSourceViewController *vc     = self.childViewControllers[1];
                if (![NSString isBlankString:self.searchView.searchBar.text]) {
                    vc.condition                  = @"";
                    vc.onLine                     = YES;
                    [vc refreshData];
                }
            }
            self.searchView.searchBar.text        = @"";
        }];
        _searchView.searchCarSourceBlock          = ^(NSString *content){
            @strongify(self)
            [self.searchView.searchBar resignFirstResponder];
            if (self.selectIndex == 0) {
                YFFindCardViewController *vc      = self.childViewControllers[0];
                vc.condition                      = content;
                [vc refreshData];
            }else{
                YFCarSourceViewController *vc     = self.childViewControllers[1];
                vc.condition                      = content;
                vc.onLine                         = [NSString isBlankString:content] ? YES : NO;
                [vc refreshData];
            }
            
        };
        [self.navigationController.navigationBar addSubview:self.searchView];
    }
    return _searchView;
}

#pragma mark  初始化子控制器
-(void)setupChildViewControllers {
    
    YFFindCardViewController *findCar              = [YFFindCardViewController new];
    [self addChildViewController:findCar];
    
    YFCarSourceViewController *carSource           = [YFCarSourceViewController new];
    carSource.onLine                               = YES;
    [self addChildViewController:carSource];
    
}

#pragma mark 底部的scrollview
-(void)setupContentView {
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets    = NO;
    
    UIScrollView *contentView                    = [[UIScrollView alloc] init];
    contentView.frame                            = CGRectMake(0, self.titleScroll.mj_h-30, ScreenWidth, ScreenHeight);
    contentView.delegate                         = self;
    contentView.contentSize                      = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    contentView.pagingEnabled                    = YES;
    [self.view insertSubview:contentView atIndex:0];
    
    self.contentView                             = contentView;
    self.contentView.contentOffset               = CGPointMake(0*ScreenWidth, 0);
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
    [self titleClick:1];
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
    if (index == 0){
        //取出子控制器
        YFFindCardViewController *vc             = self.childViewControllers[index];
        [vc refreshData];
        vc.view.x                                = scrollView.contentOffset.x;
        vc.view.y                                = 0;//设置控制器的y值为0(默认为20)
        vc.view.height                           = scrollView.height;//设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
        [scrollView addSubview:vc.view];
    }else if(index == 1){
        //取出子控制器
        YFCarSourceViewController *vc            = self.childViewControllers[index];
        vc.onLine                                = YES;
        [vc refreshData];
        vc.view.x                                = scrollView.contentOffset.x;
        vc.view.y                                = 0;//设置控制器的y值为0(默认为20)
        vc.view.height                           = scrollView.height;//设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
        [scrollView addSubview:vc.view];
    }else{
        //取出子控制器
        YFPlatformEmptyCarViewController *vc     = self.childViewControllers[index];
//        [vc refreshData];
        vc.view.x                                = scrollView.contentOffset.x;
        vc.view.y                                = 0;//设置控制器的y值为0(默认为20)
        vc.view.height                           = scrollView.height;//设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
        [scrollView addSubview:vc.view];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //当前索引
    NSInteger index                             = scrollView.contentOffset.x / scrollView.width;
    //点击butto
    [self.titleScroll setSelectedIndex:index];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.titleScroll.hidden                      = YES;
    self.searchView.hidden                       = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titleScroll.hidden                      = self.rightImageBtn.hidden = NO;
    if (self.selectIndex == 0 && !isLogin) {
        [self.titleScroll setSelectedIndex:1];
        [self titleClick:1];
    }
}

-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}

@end
