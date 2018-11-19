//
//  YFCarSourceViewModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFCarSourceModel;
@interface YFCarSourceViewModel : NSObject

@property (nonatomic, assign) NSInteger page;

/**
 搜索条件
 */
@property (nonatomic, copy) NSString *condition;

/**
 是否在线
 */
@property (nonatomic, assign) BOOL onLine;

/**
 判断是筛选还是搜索 yes 代表筛选, no 搜索
 */
@property (nonatomic, assign) BOOL isSort;

@property (nonatomic, strong) NSMutableArray <YFCarSourceModel *> *dataArr;

@property (nonatomic, strong) YFBaseViewController *superVC;

@property (nonatomic, copy) void (^refreshBlock)(void);

@property (nonatomic, copy) void (^failureBlock)(void);

@property (nonatomic, copy) void(^jumpBlock)(UIViewController *);

/**
 获取数据平台车辆信息
 */
- (void)netWork;

/**
 添加关注车辆

 @param carId 车辆 Id
 */
- (void)likeCar:(NSString *)carId DriverId:(NSString *)driverId;

/**
 取消关注
 */
- (void)cancelLikeWithCarId:(NSString *)carId DriverId:(NSString *)driverId;

- (void)jumpCtrlWithDriverId:(NSString *)driverId;

@end
