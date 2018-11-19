//
//  YFSpecialLineListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineListViewController.h"
#import "YFSpecialListService.h"
#import "YFSpecialListViewModel.h"
#import "YFCarSourceHeadView.h"
#import "YFSourceAddressScreeneView.h"

@interface YFSpecialLineListViewController ()
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFSpecialListService *service;
@property (nonatomic, strong, nullable) YFSpecialListViewModel *viewModel;
@property (nonatomic, strong, nullable) YFCarSourceHeadView *headView;
@property (nonatomic, strong, nullable) YFSourceAddressScreeneView *addressScreeneView;//出发地和目的地
@property (nonatomic, assign)           NSInteger selectIndex;//当前选择的是车型还是车长 10 出发地, 20 目的地
@property (nonatomic, strong, nullable) NSString *selectStartSite;//出发地
@property (nonatomic, strong, nullable) NSMutableArray *endAddressArr;//选中的目的地
@property (nonatomic, strong, nullable) YFNullView *nullView;
@end

@implementation YFSpecialLineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.viewModel.refreshBlock = ^{
        @strongify(self)
        [self.nullView removeFromSuperview];
        self.nullView                          = nil;
        //空视图的时候
        if (self.viewModel.dataArr.count == 0) {
            self.nullView.hidden               = NO;
        }
        [self endRefresh];
        [self needRefresh];
        
    };
    
    self.viewModel.failureBlock = ^{
        @strongify(self)
        [self endRefresh];
    };
    
    //监听当前这个状态下的订单 是否多余10条数据
    [RACObserve(self.viewModel, isShowFooter) subscribeNext:^(id x) {
        @strongify(self)
        BOOL isShowfooter                      = [x boolValue];
        
        self.tableView.mj_footer.hidden        = isShowfooter;
    }];
    
    [[YFNotificationCenter rac_addObserverForName:@"JumpSpecialLineKeys" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.page                    = 1;
        [self.viewModel netWork];
    }];
}

/**
 刷新数据
 */
-(void)refreshData{
    //因为展示没有数据
    if ([self.type isEqualToString:@"wcy"] || [NSString isBlankString:self.type] || [self.type isEqualToString:@"ycy"] ) {
        self.tableView.scrollEnabled           = NO;
        self.nullView.hidden                   = NO;
        return;
    }
    self.viewModel.page                 = 1;
    [self.viewModel netWork];
}

#pragma mark 是否需要刷新
- (void)needRefresh{
    if (self.viewModel.isNeedRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark 出发地和目的地筛选的显示与隐藏
- (void)showAddressView{
    [self.addressScreeneView showView];
    //隐藏导航栏
    [self hidenTabBar];
}

- (void)hideAddressView{
    [self.addressScreeneView disappear];
    //显示导航栏
    [self showTabBar];
}

/**
 结束刷新
 */
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

#pragma mark TableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.maxY, ScreenWidth, ScreenHeight -NavHeight - TabbarHeight - 45 - self.headView.height) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self.service;
        _tableView.dataSource                   = self.service;
        _tableView.estimatedRowHeight           = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        _tableView.rowHeight                    = 116.0f;
        _tableView.backgroundColor              = UIColorFromRGB(0xF7F7F7);
        [_tableView registerNib:[UINib nibWithNibName:@"YFSpecialLineListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSpecialLineListTableViewCell"];
        [self.view addSubview:_tableView];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.viewModel.page                 = 1;
            [WKRequest isHiddenActivityView:YES];
            [self.viewModel netWork];
        }];
        _tableView.mj_footer                    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.viewModel.page ++;
            [self.viewModel netWork];
        }];
    }
    return _tableView;
}

#pragma mark service 和 viewModel
- (YFSpecialListService *)service{
    if (!_service) {
        _service                                  = [[YFSpecialListService alloc]init];
        _service.viewModel                        = self.viewModel;
    }
    return _service;
}

- (YFSpecialListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                                = [[YFSpecialListViewModel alloc]init];
        _viewModel.shipStatue                     = self.type;
        _viewModel.superVC                        = self;
        @weakify(self)
        _viewModel.jumpBlock                      = ^(UIViewController *ctrl){
            @strongify(self)
            [self.navigationController pushViewController:ctrl animated:YES];
        };
    }
    return _viewModel;
}

#pragma mark headView
- (YFCarSourceHeadView *)headView{
    if (!_headView) {
        _headView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFCarSourceHeadView" owner:nil options:nil] lastObject];
        _headView.autoresizingMask              = 0;
        [_headView setButtonTitltWithButtonTitleType:AddressTitleType];
        _headView.frame                         = CGRectMake(0, 0, ScreenWidth, 35.0f);
        @weakify(self)
        _headView.callBackBlock                 = ^(NSInteger index, BOOL isShow){
            @strongify(self)
            //选择车型车长的时候需要结束编辑
            [YFNotificationCenter postNotificationName:@"ChooseCarMsgkeys" object:nil];
            if (index == 10) {
                //初始地
                self.selectIndex                = index;
                self.addressScreeneView.isStart = YES;
                isShow ? [self showAddressView] : [self hideAddressView];
            }else if (index == 20){
                //目的地
                self.selectIndex                = index;
                self.addressScreeneView.isStart = NO;
                isShow ? [self showAddressView] : [self hideAddressView];
            }
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

#pragma mark  起始地 目的地筛选
- (YFSourceAddressScreeneView *)addressScreeneView{
    if (!_addressScreeneView) {
        _addressScreeneView                      = [[[NSBundle mainBundle] loadNibNamed:@"YFSourceAddressScreeneView" owner:nil options:nil] lastObject];
        _addressScreeneView.frame                = CGRectMake(0, self.headView.maxY, ScreenWidth, 0);
        @weakify(self)
        _addressScreeneView.resetSelectTypeBlock = ^(NSString *address,NSMutableArray *completeEndArr) {
            @strongify(self)
            [self showTabBar];
            [self.headView setButtonSelectType:NO];
            if (self.selectIndex == 10) {
                //出发地
                self.selectStartSite             = address;
                [self.headView.carTypeBtn setTitle:[NSString isBlankString:address] ? @"全国" : [NSString getAddressAraeString:address] forState:0];
                [self.headView.carTypeBtn setTitleColor:[NSString isBlankString:address] ? UIColorFromRGB(0x6C6D6E) : NavColor  forState:0];
                self.viewModel.sendSite          = address;
            }else if (self.selectIndex == 20){
                //目的地
                NSString *endDetail              = completeEndArr.count == 0 ? @"目的地" : completeEndArr[0];
                [self.headView.carLengthBtn setTitle:[NSString isBlankString:address] ? @"全国" : [NSString getAddressAraeString:endDetail] forState:0];
                [self.headView.carLengthBtn setTitleColor:[NSString isBlankString:endDetail] ? UIColorFromRGB(0x6C6D6E) : NavColor  forState:0];
                if (completeEndArr.count == 0) {
                    [self.headView.carLengthBtn setTitleColor:UIColorFromRGB(0x6C6D6E) forState:0];
                }
                self.viewModel.recvSites         = completeEndArr;
            }
        };
        [self.view addSubview:_addressScreeneView];
    }
    return _addressScreeneView;
}

#pragma mark  nullView
-(YFNullView *)nullView{
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, self.tableView.height);
        _nullView.imgView.image                  = [UIImage imageNamed:@"noSourceGoods"];
        [_nullView.noMoreBtn setTitle:@"暂无货源" forState:0];
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}

@end
