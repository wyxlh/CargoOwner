//
//  YFHomeViewModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFHomeViewModel : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 首页 title  image 
 */
@property (nonatomic, strong) NSArray *titleArr,*imgArr,*trackingArr;

/**
 大于0 才具有专线下单的权限
 */
@property (nonatomic, assign) NSInteger jurisdiction;

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

/**
 页面跳转 block
 */
@property (nonatomic, copy) void(^jumpBlock)(UIViewController *);

@property (nonatomic, strong) YFBaseViewController *superVC;

/**
 选中哪条数据
 */
- (void)jumpCtrlWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index;


NS_ASSUME_NONNULL_END

@end
