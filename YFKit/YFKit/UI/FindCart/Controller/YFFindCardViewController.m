//
//  YFFindCardViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCardViewController.h"
#import "YFFindCartService.h"
#import "YFFindCardViewModel.h"
#import "YFCarSourceHeadView.h"
#import "YFFindCarSortView.h"

@interface YFFindCardViewController ()
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFCarSourceHeadView *headView;
@property (nonatomic, strong, nullable) YFFindCartService *service;
@property (nonatomic, strong, nullable) YFFindCardViewModel *viewModel;
@property (nonatomic, strong, nullable) YFFindCarSortView *sortView;//筛选 View
@property (nonatomic, assign)           NSInteger selectIndex;//当前选择的是车型还是车长 10 车型, 20 车长
@property (nonatomic, strong, nullable) NSMutableArray *selectTypeArr,*selectLengthArr;//选中的车型车长
@property (nonatomic, copy, nullable)   NSString *carMsg;//车型车长的数据
@property (nonatomic, strong, nullable) YFNullView *nullView;
@end

@implementation YFFindCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 获取数据 如果没有关注的数据 即dataArr没有数据 那么显示空页面 和可能关注的数据 
 */
- (void)netWork{
    
    [self.viewModel netWorkLike];
    @weakify(self)
    self.viewModel.refreshBlock = ^{
        @strongify(self)
        [self.nullView removeFromSuperview];
        self.nullView            = nil;
        if (self.viewModel.dataArr.count == 0) {
            self.headView.height = 0;
            self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight-NavHeight);
        }else{
            self.headView.height = 35;
            self.tableView.frame = CGRectMake(0, 35, ScreenWidth, ScreenHeight-TabbarHeight-NavHeight-35);
        }
        [self endRefresh];
        
    };
    
    self.viewModel.failureBlock = ^{
        @strongify(self)
        [self endRefresh];
        //空视图的时候
        if (self.viewModel.dataArr.count == 0) {
            self.nullView.hidden                   = NO;
        }
    };
}

/**
 刷新数据
 */
- (void)refreshData{
    if (_sortView) {
        self.headView.carTypeBtn.selected      = NO;
        self.headView.carLengthBtn.selected    = NO;
        [self.headView.carTypeBtn setTitle:@"车型" forState:0];
        [self.headView.carLengthBtn setTitle:@"车长" forState:0];
        [self.sortView disappear];
    }
    //显示工具栏
    [self showTabBar];
    self.viewModel.isSort                      = NO;
    self.viewModel.condition                   = self.condition;
    [self netWork];
}

/**
 隐藏筛选View
 */
-(void)dissmissSortView{
    if (_sortView) {
        for (UIButton *btn in self.headView.btnArr) {
            btn.selected                        = NO;
        }
        [self.sortView disappear];
        //显示工具栏
        [self showTabBar];
    }
}

#pragma mark 结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

/**
 显示筛选 View
 */
- (void)showSortView{
    [self.sortView showView];
}


#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.maxY, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-self.headView.height) style:UITableViewStylePlain];
        _tableView.delegate                     = self.service;
        _tableView.dataSource                   = self.service;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedRowHeight           = 100.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor              = UIColorFromRGB(0xF7F7F7);
        [_tableView registerNib:[UINib nibWithNibName:@"YFMyMaturingCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFMyMaturingCarTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFFindNoCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFFindNoCarTableViewCell"];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.viewModel.page                 = 1;
            self.viewModel.condition            = self.condition = @"";
            [YFNotificationCenter postNotificationName:@"HiddenSearchKeys" object:nil];
            [self.headView.carTypeBtn setTitle:@"车型" forState:0];
            [self.headView.carLengthBtn setTitle:@"车长" forState:0];
            [WKRequest isHiddenActivityView:YES];
            [self netWork];
            
        }];      
//        _tableView.mj_footer                    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self)
//            self.viewModel.page ++;
//            [self netWork];
//        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark  nullView
-(YFNullView *)nullView{
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, self.tableView.height);
        _nullView.imgView.image                  = [UIImage imageNamed:@"noCar"];
        [_nullView.noMoreBtn setTitle:@"暂无车辆" forState:0];
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}

#pragma mark headView
- (YFCarSourceHeadView *)headView{
    if (!_headView) {
        _headView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFCarSourceHeadView" owner:nil options:nil] lastObject];
        _headView.autoresizingMask              = 0;
        _headView.frame                         = CGRectMake(0, 0, ScreenWidth, 35.0f);
        @weakify(self)
        _headView.callBackBlock                 = ^(NSInteger index, BOOL isShow){
            @strongify(self)
            //选择车型车长的时候需要结束编辑
            [YFNotificationCenter postNotificationName:@"ChooseCarMsgkeys" object:nil];
            if (index == 10) {
                //车型
                self.selectIndex                = index;
                if (isShow) {
                    self.sortView.isCarType     = YES;
                    [self showSortView];
                    //隐藏工具栏
                    [self hidenTabBar];
                }else{
                    [self.sortView disappear];
                    //显示工具栏
                    [self showTabBar];
                }
            }else if (index == 20){
                //车长
                self.selectIndex                = index;
                if (isShow) {
                    self.sortView.isCarType     = NO;
                    [self showSortView];
                    //隐藏工具栏
                    [self hidenTabBar];
                }else{
                    [self.sortView disappear];
                    //显示工具栏
                    [self showTabBar];
                }
            }
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

#pragma mark  service
- (YFFindCartService *)service{
    if (!_service) {
        _service                                = [[YFFindCartService alloc]init];
        _service.viewModel                      = self.viewModel;
    }
    return _service;
}

#pragma mark viewModel
- (YFFindCardViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                              = [[YFFindCardViewModel alloc]init];
        _viewModel.superVC                      = self;
        @weakify(self)
        _viewModel.jumpBlock                    = ^(UIViewController *ctrl){
            @strongify(self)
            [self.navigationController pushViewController:ctrl animated:YES];
        };
    }
    return _viewModel;
}

#pragma mark  筛选
- (YFFindCarSortView *)sortView{
    if (!_sortView) {
        _sortView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFFindCarSortView" owner:nil options:nil] lastObject];
        _sortView.frame                          = CGRectMake(0, self.headView.maxY, ScreenWidth, 0);
        @weakify(self)
        _sortView.resetSelectTypeBlock           = ^(NSMutableArray *selectArr){
            @strongify(self)
            self.headView.carTypeBtn.selected    = NO;
            self.headView.carLengthBtn.selected  = NO;
            //显示工具栏
            [self showTabBar];
            //重置 headView 的选中状态 
            if (selectArr.count == 0) {
                if (self.selectIndex == 10) {
                    self.selectTypeArr           = [NSMutableArray new];
                    [self.headView.carTypeBtn setTitleColor:UIColorFromRGB(0x6C6D6E) forState:0];
                    [self.headView.carTypeBtn setTitle:@"车型" forState:0];
                }else{
                    self.selectLengthArr         = [NSMutableArray new];
                    [self.headView.carLengthBtn setTitleColor:UIColorFromRGB(0x6C6D6E) forState:0];
                    [self.headView.carLengthBtn setTitle:@"车长" forState:0];
                }
            }else{
                YFCarTypeModel *model            = [selectArr lastObject];
                if (self.selectIndex == 10) {
                    self.selectTypeArr           = [NSMutableArray new];
                    [self.headView.carTypeBtn setTitleColor:NavColor forState:0];
                    [self.headView.carTypeBtn setTitle:model.name forState:0];
                }else{
                    self.selectLengthArr         = [NSMutableArray new];
                    [self.headView.carLengthBtn setTitleColor:NavColor forState:0];
                    [self.headView.carLengthBtn setTitle:model.name forState:0];
                }
            }
            
            //把选中的数据name 取出来添加到数组中
            if (self.selectIndex == 10 && selectArr.count != 0) {
                for (YFCarTypeModel *model in selectArr) {
                    [self.selectTypeArr addObject:model.name];
                }
            }else if (self.selectIndex == 20 && selectArr.count != 0){
                for (YFCarTypeModel *model in selectArr) {
                    [self.selectLengthArr addObject:model.name];
                }
            }
            //获取筛选数据
            [self getCarMsg];
        };
        [self.view addSubview:_sortView];
    }
    return _sortView;
}

#pragma mark 车型车长筛选结果查询 
- (void)getCarMsg{
    NSMutableDictionary *parms                     = [NSMutableDictionary dictionary];
    if (self.selectTypeArr.count == 0) {
        [parms safeSetObject:@[] forKey:@"carModelList"];
    }else{
        [parms safeSetObject:self.selectTypeArr forKey:@"carModelList"];
    }
    if (self.selectLengthArr.count == 0) {
        [parms safeSetObject:@[] forKey:@"carLengthList"];
    }else{
        [parms safeSetObject:self.selectLengthArr forKey:@"carLengthList"];
    }
    if (self.selectTypeArr.count == 0 && self.selectLengthArr.count == 0) {
        self.viewModel.isSort                     = NO;
    }else{
        self.viewModel.isSort                     = YES;
    }
    
    self.carMsg                                   = [NSString dictionTransformationJson:parms];
    self.viewModel.page                           = 1;
    self.viewModel.conditionDic                   = parms;
    
    [self.viewModel netWorkLike];
}

-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}

@end
