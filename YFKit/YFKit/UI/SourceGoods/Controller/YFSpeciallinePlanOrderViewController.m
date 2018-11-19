//
//  YFSpeciallinePlanOrderViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpeciallinePlanOrderViewController.h"
#import "YFReleaseFooterView.h"
#import "YFSpecialLineService.h"
#import "YFSpecialLineViewModel.h"
#import "AESCommonCrypto.h"
#import "YFSpecialLineListModel.h"

@interface YFSpeciallinePlanOrderViewController ()
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFReleaseFooterView *footerView;//底部 View
@property (nonatomic, strong, nullable) YFSpecialLineService *service;
@property (nonatomic, strong, nullable) YFSpecialLineViewModel *viewModel;
@end

@implementation YFSpeciallinePlanOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                                  = @"专线下单";
    [self.tableView reloadData];
}

#pragma mark TableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self.service;
        _tableView.dataSource                   = self.service;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        _tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView              = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseItemTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFPlaceOrderItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFPlaceOrderItemTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFSpecialLineGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSpecialLineGoodsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFGoodsHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFGoodsHeadTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 确认发布
- (YFReleaseFooterView *)footerView{
    if (!_footerView) {
        _footerView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseFooterView" owner:nil options:nil] lastObject];
        _footerView.autoresizingMask            = 0;
        [_footerView.submitBtn setTitle:@"确认下单" forState:0];
        @weakify(self)
        [[_footerView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel postSpecialLineData];
        }];
    }
    return _footerView;
}

#pragma mark service 和 viewModel
- (YFSpecialLineService *)service{
    if (!_service) {
        _service                                  = [[YFSpecialLineService alloc]init];
        _service.viewModel                        = self.viewModel;
    }
    return _service;
}

- (YFSpecialLineViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                                = [[YFSpecialLineViewModel alloc]init];
        _viewModel.superVC                        = self;
        _viewModel.itemModel                      = self.itemModel;
        @weakify(self)
        _viewModel.operationSuccessBlock          = ^(NSInteger section,NSInteger row){
            @strongify(self)
            if (section == 0 || section == 1) {
                //地址 和货品名
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }else if (section == 0 && row == 0){
                //这么写是刷新整个 tableView
                [self.tableView reloadData];
            }else{
                //其他信息
                [self reloadTableItemCell:section row:row];
            }
        };
    }
    return _viewModel;
}

#pragma mark 刷新单个cell
-(void)reloadTableItemCell:(NSInteger )section row:(NSInteger )row{
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}



@end
