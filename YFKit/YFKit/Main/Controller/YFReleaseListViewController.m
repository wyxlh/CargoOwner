//
//  YFReleaseListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseListViewController.h"
#import "YFReleaseListTableViewCell.h"
#import "YFReleaseListFooterView.h"
#import "YFGoodsSourceDetailViewController.h"
#import "YFReleseListModel.h"
@interface YFReleaseListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) NSMutableArray <YFReleseListModel *> *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation YFReleaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.page                                 = 1;
    self.dataArr                              = [NSMutableArray new];
    [self netWork];
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms                 = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.page) forKey:@"page"];
    [parms safeSetObject:@(10) forKey:@"rows"];
    [parms safeSetObject:@(1) forKey:@"type"];
    NSString *path                             = [NSString stringWithFormat:@"goods/%ld/list.do",self.type];
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            if (self.page == 1) {
                self.dataArr                    = [YFReleseListModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }else{
                [self.dataArr addObjectsFromArray:[YFReleseListModel mj_objectArrayWithKeyValuesArray:baseModel.data]];
            }
            [self.tableView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFReleaseListTableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseListTableViewCell" forIndexPath:indexPath];
    cell.amount.hidden                          = NO;
    cell.model                                  = self.dataArr[indexPath.section];
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
    footerView.index                            = 1;
    footerView.Rmodel                           = self.dataArr[section];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFGoodsSourceDetailViewController *detail   = [YFGoodsSourceDetailViewController new];
    detail.hidesBottomBarWhenPushed             = YES;
    detail.type                                 = 1;
    detail.Id                                   = [self.dataArr[indexPath.section] Id];
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
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.page                           = 1;
            [self netWork];
        }];
        _tableView.mj_footer                    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self netWork];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
