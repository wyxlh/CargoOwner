//
//  YFOrderListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderListViewController.h"
#import "YFReleaseListTableViewCell.h"
#import "YFReleaseListFooterView.h"
#import "YFOrderDetailViewController.h"
@interface YFOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation YFOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFReleaseListTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseListTableViewCell" forIndexPath:indexPath];
    cell.orderState.hidden                      = NO;
    cell.orderState.text                        = self.type == 3 ? @"未接单" : @"已完成";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 54.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YFReleaseListFooterView *footerView         = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseListFooterView" owner:nil options:nil] lastObject];
    footerView.superVC                          = self;
    footerView.index                            = self.type;
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFOrderDetailViewController *detail         = [YFOrderDetailViewController new];
    detail.hidesBottomBarWhenPushed             = YES;
    [self.navigationController pushViewController:detail animated:YES];
}



#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-45) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = YES;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight                    = 140.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseListTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
