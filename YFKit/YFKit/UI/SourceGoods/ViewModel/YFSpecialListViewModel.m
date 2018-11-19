//
//  YFSpecialListViewModel.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialListViewModel.h"
#import "YFSpecialLineDetailViewController.h"
#import "YFSpecialLineListModel.h"
#import "YFSpeciallinePlanOrderViewController.h"

@implementation YFSpecialListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr                                = [[NSMutableArray alloc]initWithCapacity:0];
        self.page                                   = 1;
    }
    return self;
}

#pragma mark 获取专线列表数据 type:0列表，1详情
- (void)netWork{
    NSMutableDictionary *dict                       = [NSMutableDictionary dictionary];
    [dict safeSetObject:@"0" forKey:@"type"];
    [dict safeSetObject:self.shipStatue forKey:@"shipStatus"];
    [dict safeSetObject:self.recvSites forKey:@"recvSites"];
    [dict safeSetObject:self.sendSite forKey:@"sendSite"];
    [dict safeSetObject:@(self.page) forKey:@"page"];
    [dict safeSetObject:@(20) forKey:@"rows"];
    NSMutableDictionary *parms                      = [NSMutableDictionary dictionary];
    [parms safeSetObject:[NSString dictionTransformationJson:dict] forKey:@"condition"];
    @weakify(self)
    [WKRequest postWithURLString:@"app/special/getOrders.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        NSMutableArray *array                       = [NSMutableArray array];
        if (CODE_ZERO) {
            if (self.page == 1) {
                self.dataArr                        = [YFSpecialLineListModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }else{
                array                               = [YFSpecialLineListModel mj_objectArrayWithKeyValuesArray:baseModel.data];
                [self.dataArr addObjectsFromArray:array];
            }
            
        }else{

        }
        //是否需要展示(隐藏) tableviewfooter
        self.isShowFooter                     = self.dataArr.count < 20;

        //是否还能继续刷新
        if (array.count == 0 & self.dataArr.count != 0 & self.page == 1) {
            self.isNeedRefresh                = NO;
        } else {
            self.isNeedRefresh                = self.dataArr.count < 20 ? NO : YES;
        }
        !self.refreshBlock ? : self.refreshBlock();
        
    } failure:^(NSError *error) {
        !self.failureBlock ? : self.failureBlock();
    }];
}


/**
 初始地 位置筛选
 */
- (void)setSendSite:(NSString *)sendSite{
    _sendSite                                       = sendSite;
    self.page                                       = 1;
    [self netWork];
}

/**
 目的地位置筛选
 */
- (void)setRecvSites:(NSMutableArray *)recvSites{
    _recvSites                                      = recvSites;
    self.page                                       = 1;
    [self netWork];
}

#pragma mark 进入专线详情
- (void)jumpCtrlWithSelectSection:(NSInteger)section{
    YFSpecialLineDetailViewController *detail       = [YFSpecialLineDetailViewController new];
    detail.hidesBottomBarWhenPushed                 = YES;
    detail.mainModel                                = self.dataArr[section];
    !self.jumpBlock ? : self.jumpBlock(detail);
}

#pragma mark 专线订单按钮处理方法
- (void)handleSpecialLineOrderWithtTitle:(NSString *)title section:(NSInteger)section{
    WS(weakSelf)
    if ([title isEqualToString:@"取消"]) {
        //取消订单
        [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"您确定要取消该订单吗?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            NSString *shipId                            = [weakSelf.dataArr[section] shipId];
            [weakSelf cancelOrderWithShipId:shipId];
        }];
    }else if ([title isEqualToString:@"再来一单"]){
        //再来一单
        YFSpeciallinePlanOrderViewController *plan      = [[YFSpeciallinePlanOrderViewController alloc]init];
        plan.hidesBottomBarWhenPushed                   = YES;
        plan.itemModel                                  = self.dataArr[section];
        !self.jumpBlock ? : self.jumpBlock(plan);
    }
}

#pragma mark 取消订单
- (void)cancelOrderWithShipId:(NSString *)shipId{
    NSMutableDictionary *parms                      = [NSMutableDictionary dictionary];
    [parms safeSetObject:shipId forKey:@"id"];
    [parms safeSetObject:@"zzf" forKey:@"status"];
    @weakify(self)
    [WKRequest postWithURLString:@"app/special/cancelOrdered.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.page                               = 1;
            [self netWork];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
