//
//  YFLocationModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SKSingle.h"

@interface YFLocationModel : NSObject
SKSingleH(YFLocationModel)
/**
 定位
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;

/**
 定位 返回具体地址
 */
- (void)reGeocodeAction;

/**
 得到详细地址信息 和经纬度
 */
@property (nonatomic, copy) void(^backUserAddressDetailBlock)(AMapLocationReGeocode *, CGFloat, CGFloat);

/**
 定位 返回经纬度
 */
- (void)locAction;

/**
  得到用户经纬度
 */
@property (nonatomic, copy) void(^backUserLocationBlock)(CGFloat, CGFloat);

/**
 地址转经纬度
 */
- (void)GeoCoding;
/**
 暂定定位
 */
- (void)cleanUpAction;


/**
是否开始定位权限
 */
+ (BOOL)openLocationService;

@end
