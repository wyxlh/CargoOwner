//
//  YFAllOrderViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAllOrderViewController.h"
#import "YFPlaceOrderViewController.h"
#import "YFOrderListViewController.h"
#import "TitleScrollView.h"
@interface YFAllOrderViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong)TitleScrollView *titleScroll;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong) UILabel *numLbl;
@end

@implementation YFAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                                   = @"订单";
    self.titleArr                                = @[@"未完成",@"已完成",@"已取消"];
    [self setupChildViewControllers];
    [self setupContentView];
    @weakify(self)
    [[YFNotificationCenter rac_addObserverForName:@"OrderCompletion" object:nil] subscribeNext:^(NSNotification  *x) {
        @strongify(self)
        [self.titleScroll setSelectedIndex:1];
        [self titleClick:1];
    }];
}

-(void)backButtonClick:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark TitleScrollView
-(TitleScrollView *)titleScroll{
    if (!_titleScroll) {
        @weakify(self)
        _titleScroll                             = [[TitleScrollView alloc]initWithEqualFrame:CGRectMake(0, 0, ScreenWidth, 45) TitleArray:self.titleArr selectedIndex:self.selectedIndex titleFontSize:16 scrollEnable:NO lineEqualWidth:YES selectColor:[UIColor whiteColor] defaultColor:UIColorFromRGB(0xC6D5E6) SelectBlock:^(NSInteger index) {
            @strongify(self)
            if (index == 2) {
                [self zeroAndHiddenNumLbl];
            }
            [self titleClick:index];
        }];
        _titleScroll.backgroundColor             = [UIColor colorWithPatternImage:[UIImage imageNamed:ISIPHONEX ? @"titleViewBgX" : @"titleViewBg"]];
        [_titleScroll addSubview:self.numLbl];
        [self.view addSubview:_titleScroll];
    }
    return _titleScroll;
}

//小圆点
- (UILabel *)numLbl {
    if (!_numLbl) {
        _numLbl                                  = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-35, 10, 15, 15)];
        _numLbl.backgroundColor                  = [UIColor redColor];
        _numLbl.layer.masksToBounds              = YES;
        _numLbl.layer.cornerRadius               = 7.5;
        _numLbl.hidden                           = [YFOfferData shareInstace].cancelOrderSuccessCount == 0;
        _numLbl.text                             = [NSString stringWithFormat:@"%ld",(long)[YFOfferData shareInstace].cancelOrderSuccessCount];
        _numLbl.textAlignment                    = NSTextAlignmentCenter;
        _numLbl.textColor                        = [UIColor whiteColor];
        _numLbl.adjustsFontSizeToFitWidth        = YES;
        _numLbl.font                             = [UIFont systemFontOfSize:10];
    }
    return _numLbl;
}

- (void)zeroAndHiddenNumLbl{
    self.numLbl.hidden                = YES;
    [YFOfferData shareInstace].cancelOrderSuccessCount = 0;
}

#pragma mark  初始化子控制器
-(void)setupChildViewControllers {
    
    for (int i =0 ; i < self.titleArr.count; i ++) {
        YFOrderListViewController *list           = [YFOrderListViewController new];
        list.type                                 = 1 + i;
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
    self.contentView.contentOffset               = CGPointMake(self.selectedIndex*ScreenWidth, 0);
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
    NSInteger index                              = scrollView.contentOffset.x / scrollView.width;
    if (index == 2) {
        [self zeroAndHiddenNumLbl];
    }
    //取出子控制器
    YFOrderListViewController *vc                = self.childViewControllers[index];
    [vc refreshData];
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

-(void)rightTitleButtonClick:(UIButton *)sender{
    YFPlaceOrderViewController *release         = [YFPlaceOrderViewController new];
    [self.navigationController pushViewController:release animated:YES];
}

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}


@end
