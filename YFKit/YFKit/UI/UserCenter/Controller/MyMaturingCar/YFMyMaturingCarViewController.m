//
//  YFMyMaturingCarViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFMyMaturingCarViewController.h"
#import "YFChooseDriverHeadView.h"
#import "YFMyMaturingCarTableViewCell.h"

@interface YFMyMaturingCarViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFChooseDriverHeadView *headView;
@end

@implementation YFMyMaturingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    self.title                          = @"我的熟车";
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFMyMaturingCarTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFMyMaturingCarTableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.maxY, ScreenWidth, ScreenHeight-NavHeight-self.headView.height) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedRowHeight           = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight                    = 100.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFMyMaturingCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFMyMaturingCarTableViewCell"];
//        @weakify(self)
        _tableView.mj_header                    = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//            @strongify(self)
//            self.page                           = 1;
//            [self netWork];
        }];
        _tableView.mj_footer                    = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
//            @strongify(self)
//            self.page++;
//            [self netWork];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 搜索头
-(YFChooseDriverHeadView *)headView{
    if (!_headView) {
        _headView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFChooseDriverHeadView" owner:nil options:nil] lastObject];
        _headView.frame                          = CGRectMake(0, 0, ScreenWidth, 60);
        _headView.autoresizingMask               = 0;
        @weakify(self)
        _headView.clickSearchCallBackBlock       = ^{
            @strongify(self)
            [self.view endEditing:YES];
//            self.page                            = 1;
//            [self.dataArr removeAllObjects];
//            [self netWork];
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

@end
