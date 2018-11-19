//
//  YFHistoryListFooterView.h
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFReleseListModel;
@class YFOrderListModel;
@interface YFReleaseListFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *freeBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@property (nonatomic, strong) YFBaseViewController *superVC;
/**
 货源
 */
@property (nonatomic, strong) YFReleseListModel *Rmodel;
/**
 为了判断下单已完成的订单状态 特意传下来的
 */
@property (nonatomic, assign) NSInteger type;
/**
 订单
 */
@property (nonatomic, strong) YFOrderListModel *Omodel;
/**
 刷新
 */
@property (nonatomic, copy) void (^refreshDataBlock)(void);
/**
 确认收货
 */
@property (nonatomic, copy) void (^confirmCollectGoodsBlock)(YFOrderListModel *);
@end
