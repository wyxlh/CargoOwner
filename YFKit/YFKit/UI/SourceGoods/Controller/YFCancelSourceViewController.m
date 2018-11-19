//
//  YFCancelSourceViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFCancelSourceViewController.h"
#import "YFCancelSourceMsgTableViewCell.h"
#import "YFCancelReasonTableViewCell.h"
#import "YFCancelOtherReasonTableViewCell.h"
#import "YFReleaseFooterView.h"
#import "YFCarTypeModel.h"
#import "YFReleseDetailModel.h"
#import "UITableView+Extension.h"
#import "YFOrderDetailModel.h"
#import "YFReleseListModel.h"

@interface YFCancelSourceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) YFReleaseFooterView *footerView;
@property (nonatomic, strong, nullable) NSArray <YFCarTypeModel *> *dataArr;
@property (nonatomic, strong, nullable) YFReleseDetailModel *sourceModel;
@property (nonatomic, strong, nullable) YFOrderDetailModel *orderModel;
@property (nonatomic, strong, nullable) UITextView *otherTextView;
@end

@implementation YFCancelSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                              = @"取消货源";
    self.dataArr                            = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray cancelSourceReasonData]];
    [self netWorkWithSource];
}

#pragma mark network 货源详情
-(void)netWorkWithSource{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.type) forKey:@"type"];
    [parms safeSetObject:self.rModel.Id forKey:@"id"];
    NSString *path                          = [NSString stringWithFormat:@"v1/goods/%ld/get.do",(long)self.type];
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.sourceModel                = [YFReleseDetailModel mj_objectWithKeyValues:baseModel.data];
            [self.tableView reloadData];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 取消货源或者取消订单
- (void)cancelSourceOrOrder{
    //拿到取消的原因
    NSString *cancelReason = @"";
    for (YFCarTypeModel *model in self.dataArr) {
        if (model.isSelect) {
            cancelReason = model.name;
        }
    }
    if ([NSString isBlankString:cancelReason]) {
        [YFToast showMessage:@"请选择取消原因" inView:self.view];
        return;
    }else if ([cancelReason isEqualToString:@"其他"] && [NSString isBlankString:self.otherTextView.text]) {
        //如果取消原因选择了其他 那么就必须填写原因
        [YFToast showMessage:@"请填写您要取消的原因" inView:self.view];
        return;
    }
    
    if (self.cancelType == YFCancelSourceStateNonCarrierType) {
        //货源未承运 taskStatus YES为司机已接单 taskFlag == 4 表示待司机确认
        if (!self.rModel.taskStatus) {
            //司机未接单
            [self goodsCancelWithRemark:cancelReason Unanswered:YES];
        }else if (self.rModel.taskStatus && self.rModel.taskFlag.integerValue != 4) {
            //司机已接单
            [self goodsWaitCancelWithRemark:cancelReason];
        }
    }else{
        //发布中
        [self goodsCancelWithRemark:cancelReason Unanswered:NO];
    }
}

/**
 货源取消

 @param remark 取消原因
 @param unanswered 货源接单转态 NO 未接单, YES 已接单
 */
- (void)goodsCancelWithRemark:(NSString *)remark Unanswered:(BOOL)unanswered{
    NSMutableDictionary *parms                        = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.rModel.Id forKey:@"id"];
    NSString *reason                                  = [remark isEqualToString:@"其他"] ? self.otherTextView.text : [NSString stringWithFormat:@"%@%@",remark,self.otherTextView.text];
    [parms safeSetObject:reason forKey:@"remark"];
    if (unanswered) {
        [parms safeSetObject:@"4" forKey:@"status"];
    }
    @weakify(self)
    [WKRequest postWithURLString:@"v1/goods/post/cancle.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self cancelSuccess];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 取消货源, 等待司机确认  taskFlag 不为4 和 taskStatus为 YES 的时候

 @param remark 取消原因
 */
-(void)goodsWaitCancelWithRemark:(NSString *)remark {
    NSMutableDictionary *parms                        = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.rModel.taskId forKey:@"taskId"];
    [parms safeSetObject:self.rModel.Id forKey:@"id"];
    [parms safeSetObject:self.rModel.supplyGoodsId forKey:@"supplyGoodsId"];
    NSString *reason                                  = [remark isEqualToString:@"其他"] ? self.otherTextView.text : [NSString stringWithFormat:@"%@%@",remark,self.otherTextView.text];
    [parms safeSetObject:reason forKey:@"remark"];
    @weakify(self)
    [WKRequest postWithURLString:@"v1/goods/cancle/wait.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self cancelSuccess];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 取消成功
 */
- (void)cancelSuccess{
    !self.cancelSuccessBlock ? : self.cancelSuccessBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 1 ? 4 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFCancelSourceMsgTableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"YFCancelSourceMsgTableViewCell" forIndexPath:indexPath];
        cell.sourceModel                        = self.sourceModel;
        return cell;
    }else if (indexPath.section == 1){
        YFCancelReasonTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFCancelReasonTableViewCell" forIndexPath:indexPath];
        cell.model                                  = self.dataArr[indexPath.row];
        return cell;
    }
    YFCancelOtherReasonTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFCancelOtherReasonTableViewCell" forIndexPath:indexPath];
    self.otherTextView                              = cell.textView;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView                           = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50.0f)];
    headView.backgroundColor                   = [UIColor whiteColor];
    UILabel *cancelTitle                       = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 200, 18)];
    cancelTitle.textColor                      = UIColorFromRGB(0x0073E7);
    if (self.cancelType == YFCancelSourceStateNonCarrierType && !self.rModel.taskStatus) {
        cancelTitle.font                           = [UIFont systemFontOfSize:14];
        NSString *title                        = [NSString stringWithFormat:@"取消原因（还剩余%ld次）",self.times];
        [AttributedLbl setRichText:cancelTitle titleString:title textFont:[UIFont systemFontOfSize:16] fontRang:NSMakeRange(0, 4) textColor:OrangeBtnColor colorRang:NSMakeRange(4, 7)];
    }else{
        cancelTitle.text                       = @"取消原因";
        cancelTitle.font                           = [UIFont systemFontOfSize:16];
    }
    [headView addSubview:cancelTitle];
    return section == 1 ? headView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 50.0f : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        for (YFCarTypeModel *model in self.dataArr) {
            model.isSelect                      = NO;
        }
        YFCarTypeModel *model                   = self.dataArr[indexPath.row];
        model.isSelect                          = YES;
    }
    [tableView refreshTableViewWithSection:1];
}

#pragma mark TableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.separatorStyle               = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight           = 100.0f;
        _tableView.backgroundColor              = UIColorFromRGB(0xF0F3F9);
        _tableView.tableFooterView              = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:@"YFCancelSourceMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFCancelSourceMsgTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFCancelReasonTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFCancelReasonTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFCancelOtherReasonTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFCancelOtherReasonTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 确认发布
-(YFReleaseFooterView *)footerView{
    if (!_footerView) {
        _footerView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseFooterView" owner:nil options:nil] lastObject];
        _footerView.autoresizingMask            = 0;
        _footerView.backgroundColor             = UIColorFromRGB(0xF0F3F9);
        [_footerView.submitBtn setTitle:@"提交" forState:0];
        @weakify(self)
        [[_footerView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self cancelSourceOrOrder];
        }];
    }
    return _footerView;
}

@end
