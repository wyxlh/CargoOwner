//
//  YFSearchViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchViewController.h"
#import "YFSearchHeadView.h"
#import "YFSearchListTableViewCell.h"
#import "YFSearchHistoryModel.h"
#import "YFSearchSectionHeadView.h"
#import "YFSearchDetailViewController.h"
#import "YFSearchListModel.h"

@interface YFSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFSearchHeadView *searchHeadView;
@property (nonatomic, strong, nullable) YFSearchHistoryModel *searchModel;
@property (nonatomic, strong, nullable) NSMutableArray <YFSearchListModel *> *dataArr;//搜索数据
@property (nonatomic, strong, nullable) NSMutableArray <YFSearchListModel *> *historyArr;//历史数据
@end

@implementation YFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchType == YFSearchOrderShowHistoryType ? [[self.searchModel readData] count] : self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFSearchListTableViewCell *cell             = [YFSearchListTableViewCell cellWithTableView:tableView];
    cell.model                                  = self.searchType == YFSearchOrderShowResultType ? self.dataArr[indexPath.row] : self.historyArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YFSearchSectionHeadView *sectionView        = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"YFSearchSectionHeadView" owner:nil options:nil] firstObject];
    return self.searchType == YFSearchOrderShowHistoryType ? sectionView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.searchType == YFSearchOrderShowHistoryType ? 36.0f : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //存为历史数据
    [self.searchModel saveData:[self reorSearchData:self.searchType == YFSearchOrderShowResultType ? self.dataArr[indexPath.row] : self.historyArr[indexPath.row]]];
    //跳转到详情
    YFSearchDetailViewController *detail        = [YFSearchDetailViewController new];
    YFSearchListModel *model                    = self.searchType == YFSearchOrderShowResultType ? self.dataArr[indexPath.row] : self.historyArr[indexPath.row];
    detail.billIdBlock(model.orderNum).syscodeBlock(model.syscode).typeBlock(model.type);
    [self.navigationController pushViewController:detail animated:YES];
}

/**
 搜索订单信息

 @param keyWords 搜索关键字
 */
- (void)netSearchOrderMessageWithKeyWords:(NSString *)keyWords {
    NSMutableDictionary *parms                  = [NSMutableDictionary dictionary];
    [parms safeSetObject:keyWords forKey:@"billId"];
    @weakify(self)
    [WKRequest getWithURLString:@"bill/v114/search/bill.do?" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self netSuccessWithModel:baseModel AndKeyWords:keyWords];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)netSuccessWithModel:(WKBaseModel *)baseModel AndKeyWords:(NSString *)keyWords{
    self.dataArr                               = [YFSearchListModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"companyInfos"]];
    
    if (self.dataArr.count == 0) {
        //当没有数据的时候
        [YFToast showMessage:@"暂无数据" inView:self.view];
//        [self.dataArr removeAllObjects];
//        [self.tableView reloadData];
    }else{
        //改变状态
        self.searchType                            = YFSearchOrderShowResultType;
        
        for (YFSearchListModel *model in self.dataArr) {
            model.orderNum                         = keyWords;
        }
        if (self.dataArr.count == 1) {
            //如果只搜索出来一条数据 就直接存起来 如果是多条数据那么需要 在点击的时候在存
            [self.searchModel saveData:[self reorSearchData:[self.dataArr firstObject]]];
            YFSearchDetailViewController *detail        = [YFSearchDetailViewController new];
            YFSearchListModel *model                    = [self.dataArr firstObject];
            detail.billIdBlock(model.orderNum).syscodeBlock(model.syscode).typeBlock(model.type);
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            [self.tableView reloadData];
        }
    }
}

/**
 重组搜索的数据
 */
- (NSMutableArray *)reorSearchData:(YFSearchListModel *)searhModel {
    NSMutableArray *searchArray                 = [NSMutableArray new];
    NSMutableDictionary *dict                   = [NSMutableDictionary dictionary];
    [dict safeSetObject:searhModel.orderNum forKey:@"orderNum"];
    [dict safeSetObject:searhModel.companyname forKey:@"companyname"];
    [dict safeSetObject:searhModel.type forKey:@"type"];
    [dict safeSetObject:searhModel.syscode forKey:@"syscode"];
    [dict safeSetObject:searhModel.Id forKey:@"id"];
    [searchArray addObject:dict];
    return searchArray;
}

#pragma mark TableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchHeadView.maxY, ScreenWidth, ScreenHeight - self.searchHeadView.height) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.rowHeight                    = 72.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark searchHeadView
- (YFSearchHeadView *)searchHeadView {
    if (!_searchHeadView) {
        _searchHeadView                 = [[[NSBundle mainBundle] loadNibNamed:@"YFSearchHeadView" owner:nil options:nil] firstObject];
        _searchHeadView.frame           = CGRectMake(0, 0, ScreenWidth, ISIPHONEX ? NavHeight : NavHeight + 5);
        [_searchHeadView.searchTF becomeFirstResponder];
        @weakify(self)
        [[_searchHeadView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:NO];
        }];
        _searchHeadView.searchClickBlock = ^(NSString * _Nonnull searchText) {
            @strongify(self)
            [self netSearchOrderMessageWithKeyWords:searchText];
        };
        [[_searchHeadView.searchTF rac_textSignal] subscribeNext:^(id x) {
            @strongify(self)
            NSString *searchTest        = [NSString stringWithFormat:@"%@",x];
            if (searchTest.length == 0) {
                self.searchType         = YFSearchOrderShowHistoryType;
                [self.tableView reloadData];
            }
        }];
        [self.view addSubview:_searchHeadView];
    }
    return _searchHeadView;
}

-(YFSearchHistoryModel *)searchModel{
    if (!_searchModel) {
        _searchModel = [[YFSearchHistoryModel alloc]init];
    }
    return _searchModel;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.searchType = YFSearchOrderShowHistoryType;
    self.historyArr = [YFSearchListModel mj_objectArrayWithKeyValuesArray:[self.searchModel readData]];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
