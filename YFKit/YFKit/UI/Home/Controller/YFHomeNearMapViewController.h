//
//  YFHomeNearMapViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
@interface YFHomeNearMapViewController : YFBaseViewController

/**
 定位的城市
 */
@property (nonatomic, copy) NSString *city;

/**
 定位的纬度
 */
@property (nonatomic, assign) CGFloat latitude;

/**
 定位的经度
 */
@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, copy) NSString *keywords;

/**
 显示对应的图标
 */
@property (nonatomic, assign) NSInteger index;
@end
