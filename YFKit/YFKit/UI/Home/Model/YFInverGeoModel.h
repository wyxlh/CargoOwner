//
//  YFInverGeoModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/27.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSingle.h"

@interface YFInverGeoModel : NSObject
SKSingleH(YFInverGeoModel)
/**
 返回地址 逆地理编码
 @param latitude latitude description
 @param longitude longitude description
 */
- (void)getDriverAddressWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude;
@property (nonatomic, copy) void (^driverAddressBlock)(NSString *);

/**
 返回经纬度

 @param address address description
 */
- (void)getLatitudeAndlongitudeWithAddress:(NSString *)address;
@property (nonatomic, copy) void (^latitudeAndlongitudeBlock)(CGFloat ,CGFloat);
/**
 得到两个点之间的路线距离

 @param startLatitude 出发地的经纬度
 @param startLongitude 出发地的经纬度
 @param endLatitude 目的地的经纬度
 @param endLongitude 目的地的经纬度
 @param strategy 0，速度优先（时间)；1，费用优先（不走收费路段的最快道路）；2，距离优先
 */
- (void)getTwoPointsDistanceWithStartLatitude:(CGFloat)startLatitude startLongitude:(CGFloat)startLongitude endLatitude:(CGFloat)endLatitude endLongitude:(CGFloat)endLongitude strategy:(NSInteger)strategy;
@property (nonatomic, copy) void(^twoPointDistanceBlock)(CGFloat);
@end




