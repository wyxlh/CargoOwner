//
//  YFPlaceOrderViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
@class YFReleseDetailModel;
@class YFDriverListModel;
@interface YFPlaceOrderViewController : YFBaseViewController
@property (nonatomic, strong) YFReleseDetailModel *detailModel;
/**
 司机 model
 */
@property (nonatomic, strong) YFDriverListModel *driverListModel;
/**
 直接下单跳转订单列表 YFDriverListModel
 */
@property (nonatomic, assign) BOOL isNewOrder;

/**
 确认报价 和重新下单的 :1 表示确认报价 2 表示 重新下单
 */
@property (nonatomic,assign) NSInteger oldOrderType;
@end
