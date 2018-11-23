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

@interface YFSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFSearchHeadView *searchHeadView;
@property (nonatomic, strong, nullable) YFSearchHistoryModel *searchModel;
@end

@implementation YFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.searchModel readData] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YFSearchListTableViewCell *cell             = [YFSearchListTableViewCell cellWithTableView:tableView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YFSearchSectionHeadView *sectionView        = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"YFSearchSectionHeadView" owner:nil options:nil] firstObject];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
            [self.navigationController popViewControllerAnimated:NO];
        }];
        _searchHeadView.searchClickBlock = ^(NSString * _Nonnull searchText) {
            @strongify(self)
            [self.searchModel saveData:searchText];
        };
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
