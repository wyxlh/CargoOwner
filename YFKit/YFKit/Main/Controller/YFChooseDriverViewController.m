//
//  YFChooseDriverViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFChooseDriverViewController.h"
#import "YFChooseDriverTableViewCell.h"
#import "YFChooseDriverHeadView.h"
#import "YFDriverDetailViewController.h"
#import "YFDriverListModel.h"
@interface YFChooseDriverViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFChooseDriverHeadView *headView;
@property (nonatomic, strong, nonnull) NSMutableArray <YFDriverListModel *> *dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation YFChooseDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                                  = @"选择司机";
    self.page                                   = 1;
    self.dataArr                                = [NSMutableArray new];
    [self netWork];
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms                  = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.page) forKey:@"page"];
    [parms safeSetObject:@"10" forKey:@"rows"];
    [parms safeSetObject:self.headView.textField.text forKey:@"condition"];
    WS(weakSelf)
    [WKRequest getWithURLString:@"goods/driver/list.do" parameters:parms success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            if (weakSelf.page == 1) {
                weakSelf.dataArr                = [YFDriverListModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }else{
                [weakSelf.dataArr addObjectsFromArray:[YFDriverListModel mj_objectArrayWithKeyValuesArray:baseModel.data]];
            }
            [weakSelf.tableView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:weakSelf.view];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFChooseDriverTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFChooseDriverTableViewCell" forIndexPath:indexPath];
    cell.model                                  = self.dataArr[indexPath.row];
    @weakify(self)
    cell.callBackImgBlock                       = ^{
        @strongify(self)
        YFDriverDetailViewController *detail    = [YFDriverDetailViewController new];
        [self.navigationController pushViewController:detail animated:YES];
    };
    return cell;
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.maxY, ScreenWidth, ScreenHeight-NavHeight-self.headView.height) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedRowHeight           = YES;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight                    = 75.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFChooseDriverTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFChooseDriverTableViewCell"];
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
            self.page                            = 1;
            [self netWork];
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}



@end
