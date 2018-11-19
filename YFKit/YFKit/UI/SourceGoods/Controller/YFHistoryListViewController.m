//
//  YFHistoryListViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHistoryListViewController.h"
#import "YFReleaseListTableViewCell.h"
#import "YFReleaseListFooterView.h"
#import "YFGoodsSourceDetailViewController.h"
#import "YFReleseListModel.h"

@interface YFHistoryListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) NSMutableArray <YFReleseListModel *> *dataArr;
@property (nonatomic, strong, nullable) NSArray <YFSupplyGoodsIdsModel *> *cancelDataArr;
@property (nonatomic, strong, nullable) YFNullView *nullView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isReload;//在refreshData 调用了之后不在调用viewWillAppear
@end

@implementation YFHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI {
    self.page                                 = 1;
    self.dataArr                              = [NSMutableArray new];
    self.noNetView.hidden                     = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isReload && ([YFOfferData shareInstace].selectCtrl == self.selectIndex)) {
        [self refreshData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isReload                              = NO;
}

#pragma mark netWork
-(void)netWork {
    if (!isLogin) {
        return;
    }
    NSMutableDictionary *parms                 = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.page) forKey:@"page"];
    [parms safeSetObject:@(20) forKey:@"rows"];
    [parms safeSetObject:@(2) forKey:@"type"];
    [parms safeSetObject:[NSString getAppVersion] forKey:@"Version"];
    NSString *path                             = [NSString stringWithFormat:@"v1/goods/%ld/list.do",self.type];
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        
        [self requestSuccess:baseModel];
        
    } failure:^(NSError *error) {
        @strongify(self)
        [self endRefresh];
        [self netAnomaly];
    }];
}

-(void)requestSuccess:(WKBaseModel *)baseModel{
    [self.nullView removeFromSuperview];
    self.nullView                               = nil;
    [self endRefresh];
    NSMutableArray *array                       = [NSMutableArray array];
    if (CODE_ZERO) {
        if (self.page == 1) {
            self.dataArr                        = [YFReleseListModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"data"]];
        }else{
            array                               = [YFReleseListModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"data"]];
            [self.dataArr addObjectsFromArray:array];
        }
        self.cancelDataArr                      = [YFSupplyGoodsIdsModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"supplyGoodsIds"]];
        
        //遍历司机取消或者成功的数据
        self.cancelDataArr.count > 0 ? [self showDriverOrderMsg] : nil;
        
        //成功取消货源数
        [self sendChangeWithData:baseModel];
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

/**
 如果获取的次数有改变, 那么久重新赋值 并发布一个通知 改变父类的值
 */
- (void)sendChangeWithData:(WKBaseModel *)model{
    NSInteger count                         = [[[model.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"count"] integerValue];
    if ([YFOfferData shareInstace].cancelOrderSuccessCount != count) {
        [YFOfferData shareInstace].cancelOrderSuccessCount = count;
    }
}

/**
 如果司机拒绝了,那么需要弹框 联系司机
 */
- (void)showDriverOrderMsg{
    for (YFSupplyGoodsIdsModel *model in self.cancelDataArr) {
        if (!model.comfirStatus) {
            [self showAlertViewControllerTitle:wenxinTitle Message:[NSString stringWithFormat:@"货源单号:%@\n取消货源失败!", model.supplyGoodsId] CancelTitle:@"联系司机" CancelTextColor:CancelColor ConfirmTitle:@"确认" ConfirmTextColor:ConfirmColor cancelBlock:^{
                NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",model.mobile];
                if (![NSString isBlankString:model.mobile]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
                }else{
                    [YFToast showMessage:@"该司机电话号码为空" inView:self.view];
                }
            } confirmBlock:^{
                
            }];
        }
    }
}

/**
 刷新数据
 */
-(void)refreshData {
//    [self.tableView.mj_header beginRefreshing];
    self.isReload                       = YES;
    self.page                           = 1;
    [self netWork];
    
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
    cell.model                                  = self.dataArr[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 4.0f : 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 57.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YFReleaseListFooterView *footerView         = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseListFooterView" owner:nil options:nil] lastObject];
    footerView.superVC                          = self;
    footerView.type                             = self.type;
    footerView.Rmodel                           = self.dataArr[section];
    @weakify(self)
    footerView.refreshDataBlock                 = ^{
        @strongify(self)
        [self refreshData];
    };
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YFGoodsSourceDetailViewController *detail   = [YFGoodsSourceDetailViewController new];
    detail.hidesBottomBarWhenPushed             = YES;
    detail.type                                 = 2;
    detail.orderType                            = self.type;
    detail.Id                                   = [self.dataArr[indexPath.section] Id];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-45) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 0;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight                    = 140.0f;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseListTableViewCell"];
        @weakify(self)
        _tableView.mj_header                    = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.page                           = 1;
            [WKRequest isHiddenActivityView:YES];
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

#pragma mark 结束刷新
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark 网络异常
-(void)netAnomaly{
    if (![WKRequest YFNetWorkReachability]) {
        self.nullView.imgView.image              = [UIImage imageNamed:@"netAnomaly"];
        [self.nullView.noMoreBtn setTitle:@"网络异常,请检查网络" forState:0];
    }
}

#pragma mark  nullView
-(YFNullView *)nullView{
    if (!_nullView) {
        _nullView                                = [[[NSBundle mainBundle] loadNibNamed:@"YFNullView" owner:nil options:nil] lastObject];
        _nullView.imgView.image                  = [UIImage imageNamed:@"noSourceGoods"];
        [_nullView.noMoreBtn setTitle:@"暂无货源" forState:0];
        _nullView.frame                          = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-45);
        [self.tableView addSubview:_nullView];
    }
    return _nullView;
}

@end
