//
//  YFSpecialLineDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineDetailViewController.h"
#import "YFOrderDetailOrderNumHeadView.h"
#import "YFSpecialDetailAddressTableViewCell.h"
#import "YFSpecialDetailGoodsTableViewCell.h"
#import "YFSpecialDetailOtherFeeTableViewCell.h"
#import "YFSpecialDetailPaymentTableViewCell.h"
#import "YFSpecialLineSectionView.h"
#import "YFSpecialLineListModel.h"

@interface YFSpecialLineDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFOrderDetailOrderNumHeadView *headView;
@property (nonatomic, assign) BOOL isSelect;//判断火车信息的显示与隐藏
@end

@implementation YFSpecialLineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                              = @"专线详情";
    self.isSelect                           = YES;
//    [self netWork];
    [self.tableView reloadData];
}

//因为列表的数据和详情是一模一样的所以数据直接从上一个页面传下来即可
//- (void)netWork{
//    NSMutableDictionary *dict                       = [NSMutableDictionary dictionary];
//    [dict safeSetObject:@"1" forKey:@"type"];
//    [dict safeSetObject:self.Id forKey:@"id"];
//    NSMutableDictionary *parms                      = [NSMutableDictionary dictionary];
//    [parms safeSetObject:[NSString dictionTransformationJson:dict] forKey:@"condition"];
//    @weakify(self)
//    [WKRequest postWithURLString:@"app/special/getOrders.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
//        @strongify(self)
//        if (CODE_ZERO) {
//            self.mainModel                          = [YFSpecialLineListModel mj_objectWithKeyValues:baseModel.data];
//            [self.tableView reloadData];
//        }else{
//            [YFToast showMessage:baseModel.message inView:self.view];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        //货品信息
        return self.mainModel.goodsModel.count;
    }else if (section == 2){
        //其他费用
        return self.isSelect ? 1 : 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //地址
        YFSpecialDetailAddressTableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"YFSpecialDetailAddressTableViewCell" forIndexPath:indexPath];
        cell.model                                     = self.mainModel;
        cell.superVC                                   = self;
        return cell;
    }else if (indexPath.section == 1){
        //货品信息
        YFSpecialDetailGoodsTableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:@"YFSpecialDetailGoodsTableViewCell" forIndexPath:indexPath];
        cell.numLbl.text                                = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        cell.model                                      = self.mainModel.goodsModel[indexPath.row];
        return cell;
    }else if (indexPath.section == 2){
        //其他费用
        YFSpecialDetailOtherFeeTableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"YFSpecialDetailOtherFeeTableViewCell" forIndexPath:indexPath];
        cell.model                                      = self.mainModel;
        return cell;
    }else{
        //付款方式
        YFSpecialDetailPaymentTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFSpecialDetailPaymentTableViewCell" forIndexPath:indexPath];
        cell.model                                      = self.mainModel;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YFSpecialLineSectionView *sectionView                = [[[NSBundle mainBundle] loadNibNamed:@"YFSpecialLineSectionView" owner:nil options:nil] lastObject];
    sectionView.index                                    = section;
    [sectionView.showBtn setImage:self.isSelect ? [UIImage imageNamed:@"bottom"] : [UIImage imageNamed:@"top"] forState:0];
    sectionView.logo.image                               = [UIImage imageNamed:section == 1 ? @"goodName" : @"free"];
    @weakify(self)
    sectionView.showCarMsgBlock                          = ^{
        @strongify(self)
        self.isSelect                                    = !self.isSelect;
        NSIndexSet *indexSetA = [[NSIndexSet alloc]initWithIndex:2];    //刷新第2段
        [tableView reloadSections:indexSetA withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    return (section == 1 || section == 2) ? sectionView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section == 1 || section == 2) ? 40.0f : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 1 ? CGFLOAT_MIN : 5.0f;
}

#pragma mark TableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 100.0f;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        _tableView.tableHeaderView              = self.headView;
        _tableView.backgroundColor              = UIColorFromRGB(0xF7F7F7);
        [_tableView registerNib:[UINib nibWithNibName:@"YFSpecialDetailAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSpecialDetailAddressTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFSpecialDetailGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSpecialDetailGoodsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFSpecialDetailOtherFeeTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSpecialDetailOtherFeeTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFSpecialDetailPaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFSpecialDetailPaymentTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (YFOrderDetailOrderNumHeadView *)headView{
    if (!_headView) {
        _headView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFOrderDetailOrderNumHeadView" owner:nil options:nil] lastObject];
        _headView.sModel                        = self.mainModel;
    }
    return _headView;
}


@end
