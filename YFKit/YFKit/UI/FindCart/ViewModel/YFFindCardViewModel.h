//
//  YFFindCardViewModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFMayBeCarModel;
@interface YFFindCardViewModel : NSObject

@property (nonatomic, assign) NSInteger page;

/**
 用户关注的数据
 */
@property (nonatomic, strong) NSMutableArray <YFMayBeCarModel *> *dataArr;

/**
 用户可能关注的数据
 */
@property (nonatomic, strong) NSMutableArray *likeDataArr;

@property (nonatomic, strong) YFBaseViewController *superVC;

@property (nonatomic, copy) void (^refreshBlock)(void);

@property (nonatomic, copy) void (^failureBlock)(void);

@property (nonatomic, copy) void(^jumpBlock)(UIViewController *);
/**
 搜索条件
 */
@property (nonatomic, copy) NSString *condition;

/**
 筛选需要的参数
 */
@property (nonatomic, strong) NSMutableDictionary *conditionDic;

/**
 判断是筛选还是搜索 yes 代表筛选, no 搜索
 */
@property (nonatomic, assign) BOOL isSort;

/**
 获取关注的数据
 */
- (void)netWorkLike;

/**
 获取可能关注的数据
 */
- (void)netWorkMayBeWithSuccess:(void (^)(void))success;

/**
 取消关注
 */
- (void)cancelLikeWithCarId:(NSString *)carId DriverId:(NSString *)driverId;

/**
 添加关注车辆
 
 @param carId 车辆 Id
 */
- (void)likeCar:(NSString *)carId DriverId:(NSString *)driverId;

- (void)jumpCtrlWithDriverId:(NSString *)driverId;


@end
