//
//  YFUserCenterViewModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFPersonImageModel.h"

@interface YFUserCenterViewModel : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) YFPersonImageModel *mainModel;

@property (nonatomic, strong) YFBaseViewController *superVC;

@property (nonatomic, copy) void(^jumpBlock)(UIViewController *);

/**
 初始化页面
 */
- (void)setUIWithSuccess:(void (^)(void))success;


/**
 获取个人信息
 */
- (void)netWorkWithSuccess:(void (^)(YFPersonImageModel *))success;


/**
 选中哪条数据
 */
- (void)jumpCtrlWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index;

NS_ASSUME_NONNULL_END

@end
