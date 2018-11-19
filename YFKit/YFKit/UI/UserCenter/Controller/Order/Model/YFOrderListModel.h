//
//  YFOrderListModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YFOrderListModel : NSObject
/**
 单号
 */
@property (nonatomic, copy) NSString *refId;
@property (nonatomic, copy) NSString *creatorTime;
@property (nonatomic, copy) NSString *publishedTime;
/**
 //订单下发时间、任务下发时间
 
 */
@property (nonatomic, copy) NSString *taskTime;
@property (nonatomic, copy) NSString *startSite;
@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, copy) NSString *endSite;
@property (nonatomic, copy) NSString *endAddress;
/**
 货品名称
 */
@property (nonatomic, copy) NSString *goodsName;
/**
 货品数量
 */
@property (nonatomic, copy) NSString *goodsTotalNumber;
/**
 货品体积
 */
@property (nonatomic, copy) NSString *goodsTotalVolume;
/**
 货品重量
 */
@property (nonatomic, copy) NSString *goodsTotalWeight;
/**
 货源单系统id
 */
@property (nonatomic, copy) NSString *Id;
/**
 如果为2 则为调整运费中
 */
@property (nonatomic, strong) NSNumber *addAmountComfirmStatus;

/**
 任务单编号
 */
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, assign) NSNumber *taskFee;
@property (nonatomic, assign) NSNumber *addAmount;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carSize;

/**
 司机电话
 */
@property (nonatomic, copy) NSString *driverMobile;

@property (nonatomic, assign) NSInteger taskStatus;

/**
 //货主确认状态(0=未确认,1=已确认）
 */
@property (nonatomic, assign) NSInteger confirmStatus;

/**
 ,//推送状态(1=正常,2=货主承取消,3=承运商删除)
 */
@property (nonatomic, assign) NSInteger taskFlag;

@end

@interface YFListTaskFeeAdjustVoModel : NSObject
/**
 单号
 */
@property (nonatomic, copy) NSString *taskId;
/**
 是否调整成功
 */
@property (nonatomic, assign) BOOL comfirStatus;
/**
 手机号
 */
@property (nonatomic, copy) NSString *mobile;
@end

NS_ASSUME_NONNULL_END
