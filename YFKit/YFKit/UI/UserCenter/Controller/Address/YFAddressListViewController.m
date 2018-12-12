//
//  YFAddressListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAddressListViewController.h"
#import "YFEditAddressViewController.h"
#import "YFAddressListTableViewCell.h"
#import "YFAddressFooterView.h"
#import "YFCreateAddressView.h"
#import "YFAddressModel.h"
#import "YFAddressDataTool.h"
#import "YFAddressPresenter.h"

@interface YFAddressListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFCreateAddressView *rfooterView;
@property (nonatomic, strong, nullable) NSArray <YFAddressPresenter *> *presenterMs;
@property (nonatomic, strong, nullable) YFNullView *nullView;
@end

@implementation YFAddressListViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                              = self.isConsignor ? @"发货地址管理" : @"收货地址管理";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark 私有方法
- (void)loadData {
    if (self.isConsignor) {
        @weakify(self)
        [[YFAddressDataTool shareInstance] getSendAddress:^(NSArray<YFAddressModel *> * _Nonnull models) {
            @strongify(self)
            NSMutableArray *ps = [NSMutableArray array];
            for (YFAddressModel *model in models) {
                YFAddressPresenter *p = [[YFAddressPresenter alloc] init];
                p.model = model;
                [ps addObject:p];
            }
            self.presenterMs = ps;
        }];
    }else {
        [[YFAddressDataTool shareInstance] getReceiverAddress:^(NSArray<YFAddressModel *> * _Nonnull models) {
            NSMutableArray *ps = [NSMutableArray array];
            for (YFAddressModel *model in models) {
                YFAddressPresenter *p = [[YFAddressPresenter alloc] init];
                p.model = model;
                [ps addObject:p];
            }
            self.presenterMs = ps;
        }];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.nullView.hidden = self.presenterMs.count == 0 ? NO : YES;
    return self.presenterMs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFAddressListTableViewCell *cell            = [YFAddressListTableViewCell cellWithTableView:tableView];
    YFAddressPresenter *p                       = self.presenterMs[indexPath.section];
    
    //绑定 cell
    [p bindToCell:cell];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YFAddressFooterView *footerView = [YFAddressFooterView loadFooterView];
    YFAddressPresenter *p = self.presenterMs[section];
    
    [p bindToFooterView:footerView];
    @weakify(self)
    footerView.refreshBlock = ^(NSString *titleString){
        @strongify(self)
        [p handleFooterViewButton:self buttonTitleString:titleString isConsignor:self.isConsignor resultBlock:^{
            [self loadData];
        }];
        
    };
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01f : 4.0f;
}

#pragma mark get  set
- (void)setPresenterMs:(NSArray<YFAddressPresenter *> *)presenterMs {
    _presenterMs = presenterMs;
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-self.rfooterView.height) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 70.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (YFCreateAddressView *)rfooterView {
    if (!_rfooterView) {
        _rfooterView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFCreateAddressView" owner:nil options:nil] lastObject];
        _rfooterView.frame                       = CGRectMake(0, ScreenHeight-NavHeight-50, ScreenWidth, 50);
        [_rfooterView.submitBtn setTitle:@"新建" forState:UIControlStateNormal];
        _rfooterView.autoresizingMask            = 0;
        @weakify(self)
        [[_rfooterView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            YFEditAddressViewController *edit    = [YFEditAddressViewController new];
            edit.isConsignor                     = self.isConsignor;
            [self.navigationController pushViewController:edit animated:YES];
        }];
        [self.view addSubview:_rfooterView];
    }
    return _rfooterView;
}

- (YFNullView *)nullView {
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, self.tableView.height);
        _nullView.imgView.image                  = [UIImage imageNamed:@"noAddress"];
        [_nullView.noMoreBtn setTitle:@"暂无地址" forState:0];
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}

@end
