//
//  YFReleseListModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFReleseListModel : NSObject
NS_ASSUME_NONNULL_BEGIN
/**
 创建时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
 创建人
 */
@property (nonatomic, copy) NSString *creator;
/**
 目的地详细地址
 */
@property (nonatomic, copy) NSString *endAddress;
/**
 目的地地址
 */
@property (nonatomic, copy) NSString *endSite;
/**
 期望报价价格
 */
@property (nonatomic, copy) NSString *expectPrice;
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
 是否竞价
 */
@property (nonatomic, assign) BOOL  isBid;
/**
 报价数目
 */
@property (nonatomic, copy) NSString *priceCount;
/**
 预期提货日期
 */
@property (nonatomic, copy) NSString *pickGoodsDate;
/**
货源发布时间
 */
@property (nonatomic, copy) NSString *publishedTime;
/**
 报价金额
 */
@property (nonatomic, copy) NSString *quotedPrice;
/**
 
 */
@property (nonatomic, copy) NSString *remark;
/**
 起始地详细地址
 */
@property (nonatomic, copy) NSString *startAddress;
/**
 起始地
 */
@property (nonatomic, copy) NSString *startSite;
/**
 货源单号
 */
@property (nonatomic, copy) NSString *supplyGoodsId;
/**
 货源状态
 */
@property (nonatomic, copy) NSString *supplyGoodsStatus;
/**
 需求车辆长度
 */
@property (nonatomic, copy) NSString *vehicleCarLength;

@property (nonatomic, copy) NSString *vehicleCarType;
/**
 期望车辆数
 */
@property (nonatomic, copy) NSString *vehicleCarNum;
NS_ASSUME_NONNULL_END
@end
