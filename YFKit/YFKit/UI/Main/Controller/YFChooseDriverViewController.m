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
@interface YFChooseDriverViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFChooseDriverHeadView *headView;
@property (nonatomic, strong, nonnull) NSMutableArray <YFDriverListModel *> *dataArr;
@property (nonatomic, strong, nullable) YFNullView *nullView;
@property (nonatomic, assign) NSInteger page;
@end

@implementation YFChooseDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                                  = self.isChooseDriver ? @"选择司机" : @"常用司机";
    self.page                                   = 1;
    self.dataArr                                = [NSMutableArray new];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms                  = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.page) forKey:@"page"];
    [parms safeSetObject:@"20" forKey:@"rows"];
    [parms safeSetObject:self.headView.textField.text forKey:@"condition"];
    NSString *path = self.isChooseDriver ? @"v1/goods/driver/list.do" : @"base/user/frequentDriver.do";
    WS(weakSelf)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        
        [self requestSuccess:baseModel];
        
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
    }];
}

-(void)requestSuccess:(WKBaseModel *)baseModel{
    [self.nullView removeFromSuperview];
    self.nullView                               = nil;
    [self endRefresh];
    NSMutableArray *array                       = [NSMutableArray array];
    if (CODE_ZERO) {
        if (self.page == 1) {
            self.dataArr                        = [YFDriverListModel mj_objectArrayWithKeyValuesArray:baseModel.data];
        }else{
            array                               = [YFDriverListModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            [self.dataArr addObjectsFromArray:array];
        }
    }else{
        [YFToast showMessage:baseModel.message inView:self.view];
        
    }
    
    self.tableView.mj_footer.hidden              = self.dataArr.count < 10 ? YES : NO;
    
    if (array.count == 0 & self.dataArr.count != 0 & self.page != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    [self.tableView reloadData];
    
    if (self.dataArr.count == 0) {
        self.nullView.hidden                      = NO;
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFChooseDriverTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFChooseDriverTableViewCell" forIndexPath:indexPath];
    cell.model                                  = self.dataArr[indexPath.row];
    @weakify(self)
    [[[cell.PlaceOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (self.isChooseDriver) {
            !self.backDriverMsgBlock ? : self.backDriverMsgBlock(self.dataArr[indexPath.row]);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self selectTabbarIndex:1];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [YFNotificationCenter postNotificationName:@"ChooseDriver" object:self.dataArr[indexPath.row]];
                    [self.navigationController popViewControllerAnimated:NO];
                }];
            }];
            
            
        }
        
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFDriverDetailViewController *detail        = [YFDriverDetailViewController new];
    detail.driveId                              = [self.dataArr[indexPath.row] driverId];
    [self.navigationController pushViewController:detail animated:YES];
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
        _tableView.rowHeight                    = 75.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFChooseDriverTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFChooseDriverTableViewCell"];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.page                           = 1;
            [self netWork];
        }];
        _tableView.mj_footer                    = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
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
            [self.dataArr removeAllObjects];
            [self netWork];
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

#pragma mark 结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark  nullView
-(YFNullView *)nullView{
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-45);
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}


@end
