//
//  YFOrderDetailModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFOrderDetailModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *refId;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *creatorTime;
@property (nonatomic, copy) NSString *taskTime;
@property (nonatomic, copy) NSString *startSite;
@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, copy) NSString *endSite;
@property (nonatomic, copy) NSString *endAddress;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carSize;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *unloadWay;
@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *receiverMobile;
/**
 装货时间
 */
@property (nonatomic, copy) NSString *pickGoodsDate;
@property (nonatomic, copy) NSString *pickGoodsDateEnd;
@property (nonatomic, copy) NSString *pickGoodsDateStart;
@property (nonatomic, copy) NSString *driverMobile;
@property (nonatomic, copy) NSString *taskFee;
@property (nonatomic, copy) NSArray  *goodsItem;
@property (nonatomic, strong) NSArray *details;
@property (nonatomic, copy) NSString *remark;
/**
 出发地经纬度
 */
@property (nonatomic, assign) CGFloat startSiteLongitude;
@property (nonatomic, assign) CGFloat startSiteLatitude;
/**
 目的地经纬度
 */
@property (nonatomic, assign) CGFloat endSiteLongitude;
@property (nonatomic, assign) CGFloat endSiteLatitude;
@end

@interface YFGoodItemsModel : NSObject
/**
 申明价值
 */
@property (nonatomic, copy) NSString *goodsAmount;
@property (nonatomic, copy) NSString *goodsGrossWeight;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsNetWeight;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *goodsVolume;
@property (nonatomic, copy) NSString *goodsWeight;
@property (nonatomic, copy) NSString *remark;


@end

@interface YFLogisDetailsModel : NSObject
@property (nonatomic, copy) NSString *opCode;
@property (nonatomic, copy) NSString *opTime;
@property (nonatomic, copy) NSString *opLoc;
NS_ASSUME_NONNULL_END
@end

