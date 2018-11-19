//
//  YFOrderListViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
@interface YFOrderListViewController : YFBaseViewController
/**
定位
 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
/**
 判断当前订单是什么状态
 */
@property (nonatomic, assign) NSInteger type;

/**
 刷新数据
 */
-(void)refreshData;

/**
 确认收货定位
 */
-(void)reGeocodeAction;
@end
