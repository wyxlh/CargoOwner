//
//  YFCarSourceModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFCarSourceModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *carLawId;
@property (nonatomic, copy) NSString *carSize;
@property (nonatomic, copy) NSString *certifiedStatus;
@property (nonatomic, copy) NSString *containerType;
@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *driverMobile;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *driverPhone;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *locAddr;
@property (nonatomic, copy) NSString *transactionCount;
@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, copy) NSString *locTime;//司机定位时时间,用来判断司机是否在线
@property (nonatomic, assign) BOOL onLine;//是否在线
@end

@interface YFMayBeCarModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *carCode;
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *carSize;
@property (nonatomic, copy) NSString *carLong;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *times;
@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, copy) NSString *transactionCount;//交易次数
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;//查看时间
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, copy) NSString *locTime;//司机定位时时间,用来判断司机是否在线
@property (nonatomic, assign) BOOL onLine;//是否在线

NS_ASSUME_NONNULL_END
@end
