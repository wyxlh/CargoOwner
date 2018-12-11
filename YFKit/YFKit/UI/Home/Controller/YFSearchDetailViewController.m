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
#import "YFLogisticsTrackViewController.h"
#import "YFSearchDetailModel.h"
#import "YFLookSignInViewController.h"

@interface YFSearchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFSearchDetailModel *mainModel;
@end

@implementation YFSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWork];
}

#pragma mark 获取订单详情
- (void)netWork {
    NSMutableDictionary *parms      = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.billId forKey:@"billId"];
    [parms safeSetObject:self.syscode forKey:@"sysCode"];
    [parms safeSetObject:self.type forKey:@"type"];
    [parms safeSetObject:self.Id forKey:@"Id"];
    @weakify(self)
    [WKRequest getWithURLString:@"bill/v114/search/bill/info.do?" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self netWorkSuccessWithModel:baseModel];
        }else{
            [YFToast showMessage:@"暂无详情" inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)netWorkSuccessWithModel:(WKBaseModel *)baseModel {
    self.mainModel    = [YFSearchDetailModel mj_objectWithKeyValues:[baseModel.mDictionary safeJsonObjForKey:@"data"]];
    self.mainModel.isShowMap = self.mainModel.driverLatitude == 0 ? NO : YES;
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainModel.isShowMap ?  3 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.mainModel.isShowMap) {
        //最多显示50条记录
        return section == 2 ? (self.mainModel.details.count > 50 ? 0 : self.mainModel.details.count) : 1;
    }
    return section == 1 ? (self.mainModel.details.count > 50 ? 0 : self.mainModel.details.count) : 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //货物信息
        YFSearchGoodsItemTableViewCell *cell   = [YFSearchGoodsItemTableViewCell cellWithTableView:tableView];
        cell.model                             = self.mainModel;
        return cell;
    }else if (indexPath.section == 1 && self.mainModel.isShowMap) {
        //地图
        YFSearchDetailMapTableViewCell *cell   = [YFSearchDetailMapTableViewCell cellWithTableView:tableView];
        cell.model                             = self.mainModel;
        return cell;
    }else {
        //物流轨迹
        YFSearceDetailTimeTableViewCell *cell  = [YFSearceDetailTimeTableViewCell cellWithTableView:tableView];
        cell.index                             = indexPath.row;
        cell.creator                           = self.mainModel.creator;
        cell.model                             = self.mainModel.details[indexPath.row];
        cell.bottomLine.hidden                 = indexPath.row == self.mainModel.details.count - 1;
        @weakify(self)
        [[[cell.lookBtn rac_signalForControlEvents:UIControlEventTouchUpInside]     takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self)
            YFLookSignInViewController *look   = [YFLookSignInViewController new];
            look.isSearchLookType              = YES;
            look.orderNum(self.mainModel.billWRId).typeId(self.mainModel.billWRType).sysCodeId(self.syscode);
            [self.navigationController pushViewController:look animated:YES];
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && self.mainModel.isShowMap) {
        YFLogisticsTrackViewController *track = [YFLogisticsTrackViewController new];
        track.mainModel                       = self.mainModel;
        [self.navigationController pushViewController:track animated:YES];
    }
}

#pragma mark 上个页面传值
- (YFSearchDetailViewController * _Nonnull (^)(NSString * _Nonnull))billIdBlock {
    @weakify(self)
    return ^(NSString *billId){
        @strongify(self)
        self.title = self.billId = billId;
        return self;
    };
}

- (YFSearchDetailViewController * _Nonnull (^)(NSString * _Nonnull))syscodeBlock {
    @weakify(self)
    return ^(NSString *syscode){
        @strongify(self)
        self.syscode = syscode;
        return self;
    };
}

- (YFSearchDetailViewController * _Nonnull (^)(NSString * _Nonnull))typeBlock {
    @weakify(self)
    return ^(NSString *type){
        @strongify(self)
        self.type = type;
        return self;
    };
}

- (YFSearchDetailViewController * _Nonnull (^)(NSString * _Nonnull))IdBlock {
    @weakify(self)
    return ^(NSString *Id){
        @strongify(self)
        self.Id = Id;
        return self;
    };
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
