//
//  YFCancelSourceViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class YFReleseListModel;

typedef NS_ENUM(NSInteger, YFCancelSourceStateType) {
    YFCancelSourceStateReleaseType,//货源发布中
    YFCancelSourceStateNonCarrierType,//货源未承运
};

@interface YFCancelSourceViewController : YFBaseViewController
/**
 判断是发布中的货源还是历史货源 1发布中 --> 2历史货源
 */
@property (nonatomic, assign)NSInteger type;
/**
 货源 model
 */
@property (nonatomic, strong) YFReleseListModel *rModel;
/**
 未承运能取消的订单的次数
 */
@property (nonatomic, assign) NSInteger times;
/**
 取消货源 或者取消订单成功成功
 */
@property (nonatomic, copy) void(^cancelSuccessBlock)(void);

/**
 取消货源或者订单的状态
 */
@property (nonatomic, assign) YFCancelSourceStateType cancelType;

@end

NS_ASSUME_NONNULL_END
