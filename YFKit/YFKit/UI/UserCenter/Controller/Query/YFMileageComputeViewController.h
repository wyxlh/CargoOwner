//
//  YFMileageComputeViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/7/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@interface YFMileageComputeViewController : YFBaseViewController

/**
 出发地
 */
@property (nonatomic, copy, nullable) NSString *startAddress;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
/**
 目的地
 */
@property (nonatomic, copy, nullable) NSString *endAddress;

@end
