//
//  YFSearchDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchDetailViewController.h"
#import "YFSearchGoodsItemTableViewCell.h"
#import "YFSearceDetailTimeTableViewCell.h"
#import "YFSearchDetailMapTableViewCell.h"

@interface YFSearchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong ,nullable) UITableView *tableView;
@end

@implementation YFSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单号";
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 5 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //货物信息
        YFSearchGoodsItemTableViewCell *cell   = [YFSearchGoodsItemTableViewCell cellWithTableView:tableView];
        return cell;
    }else if (indexPath.section == 1) {
        //地图
        YFSearchDetailMapTableViewCell *cell   = [YFSearchDetailMapTableViewCell cellWithTableView:tableView];
        return cell;
    }else {
        //物流轨迹
        YFSearceDetailTimeTableViewCell *cell  = [YFSearceDetailTimeTableViewCell cellWithTableView:tableView];
        cell.index                             = indexPath.row;
        return cell;
    }
}

#pragma mark tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedRowHeight           = 72.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
