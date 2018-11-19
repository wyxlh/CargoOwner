//
//  YFAllSpecialLineViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAllSpecialLineViewController.h"
#import "YFSpecialLineListViewController.h"
#import "TitleScrollView.h"

@interface YFAllSpecialLineViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong)TitleScrollView *titleScroll;
@property (nonatomic, strong)NSArray *titleArr;
@end

@implementation YFAllSpecialLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    @weakify(self)
    [[YFNotificationCenter rac_addObserverForName:@"JumpSpecialLineKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.titleScroll setSelectedIndex:0];
        [self titleClick:0];
    }];
}

#pragma mark  setUI
-(void)setUI{
    self.titleArr                                = @[@"已开单",@"未承运",@"已承运",@"已取消"];
    [self setupChildViewControllers];
    [self setupContentView];
}

#pragma mark TitleScrollView
-(TitleScrollView *)titleScroll{
    if (!_titleScroll) {
        @weakify(self)
        _titleScroll                             = [[TitleScrollView alloc]initWithEqualFrame:CGRectMake(0, 0, ScreenWidth, 45) TitleArray:self.titleArr selectedIndex:0 titleFontSize:16 scrollEnable:NO lineEqualWidth:YES selectColor:[UIColor whiteColor] defaultColor:UIColorFromRGB(0xC6D5E6) SelectBlock:^(NSInteger index) {
            @strongify(self)
            [self titleClick:index];
        }];
        _titleScroll.backgroundColor             = [UIColor colorWithPatternImage:[UIImage imageNamed:ISIPHONEX ? @"titleViewBgX" : @"titleViewBg"]];
        [self.view addSubview:_titleScroll];
    }
    return _titleScroll;
}

#pragma mark  初始化子控制器
-(void)setupChildViewControllers {
    for (int i = 0; i < self.titleArr.count; i ++) {
        YFSpecialLineListViewController *list     = [YFSpecialLineListViewController new];
        if (i == 0) {
            list.type                             = @"zkd";//发布中
        }else if (i == 1){
            list.type                             = @"wcy";//未承运
        }else if(i == 2){
            list.type                             = @"ycy";//已承运
        }else{
            list.type                             = @"zzf";//已取消
        }
        [self addChildViewController:list];
    }
}

#pragma mark 底部的scrollview
-(void)setupContentView {
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets    = NO;
    
    UIScrollView *contentView                    = [[UIScrollView alloc] init];
    contentView.frame                            = CGRectMake(0, self.titleScroll.mj_h, ScreenWidth, ScreenHeight);
    contentView.delegate                         = self;
    contentView.contentSize                      = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    contentView.pagingEnabled                    = YES;
    [self.view insertSubview:contentView atIndex:0];
    
    self.contentView                             = contentView;
    self.contentView.contentOffset               = CGPointMake(0*ScreenWidth, 0);
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
    
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
    NSInteger index                                  = scrollView.contentOffset.x / scrollView.width;
    //取出子控制器
    YFSpecialLineListViewController *vc              = self.childViewControllers[index];
    [vc refreshData];
    vc.view.x                                        = scrollView.contentOffset.x;
    vc.view.y                                        = 0;//设置控制器的y值为0(默认为20)
    vc.view.height                                   = scrollView.height;//设置控制器的view的height值为整个屏幕的高度（默认是比屏幕少20）
    [scrollView addSubview:vc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //当前索引
    NSInteger index                             = scrollView.contentOffset.x / scrollView.width;
    //点击butto
    [self.titleScroll setSelectedIndex:index];
}

-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}

@end
