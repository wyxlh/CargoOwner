//
//  YFSearchDetailModel.h
//  YFKit
//
//  Created by 王宇 on 2018/11/30.
//  Copyright © 2018 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSearchDetailModel : NSObject
@property (nonatomic, copy) NSString *billWRId;
@property (nonatomic, copy) NSString *billWRType;
/**
 所有者
 */
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *consignor;
/**
 目的地
 */
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, assign) CGFloat sendSiteLatitude;
@property (nonatomic, assign) CGFloat sendSiteLongitude;
/**
 是否展示地图
 */
@property (nonatomic, assign) BOOL isShowMap;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *driverPhone;
/**
 起始地
 */
@property (nonatomic, copy) NSString *startingPlace;
@property (nonatomic, assign) CGFloat recvSiteLatitude;
@property (nonatomic, assign) CGFloat recvSiteLongitude;
/**
 司机位置信息
 */
@property (nonatomic, assign) CGFloat driverLatitude;
@property (nonatomic, assign) CGFloat driverLongitude;
@property (nonatomic, copy) NSString *type;
/**
 记录
 */
@property (nonatomic, strong) NSArray *details;
/**
 物品信息
 */
@property (nonatomic, strong) NSArray *goodInfo;
@end


@interface detailsModel : NSObject
@property (nonatomic, copy) NSString *dataTime;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@end

@interface goodInfoModel : NSObject
@property (nonatomic, copy) NSString *goodName;
@property (nonatomic, copy) NSString *goodWeight;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *volumeWeight;
@end

NS_ASSUME_NONNULL_END
