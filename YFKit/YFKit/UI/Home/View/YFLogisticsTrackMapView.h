//
//  YFLogisticsTrackMapView.h
//  YFKit
//
//  Created by 王宇 on 2018/11/28.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFLogisticsTrackMapView : UIView
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
/**订单是否已经完成*/
@property (nonatomic, assign) BOOL isCompleteOrder;
/**
 订单地址操作节点信息
 */
@property (nonatomic, strong) NSArray<AMapGeoPoint *> *channels;
@end

NS_ASSUME_NONNULL_END
