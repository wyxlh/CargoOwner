//
//  YFDriverDetailModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFDriverDetailModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *certifiedStatus;
@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *driverMobile;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *transactionCount;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *locTimeStr;//司机定位时时间,用来判断司机是否在线
@property (nonatomic, assign) BOOL onLine;//是否在线
/**
 车牌号
 */
@property (nonatomic, copy) NSString *carLawId;
@property (nonatomic, copy) NSString *carSize;
@property (nonatomic, copy) NSString *containerType;
@property (nonatomic, copy) NSString *locAddr;
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
NS_ASSUME_NONNULL_END
@end
