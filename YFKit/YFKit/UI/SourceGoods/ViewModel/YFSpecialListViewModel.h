//
//  YFSpecialListViewModel.h
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFSpecialLineListModel;

@interface YFSpecialListViewModel : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) void(^jumpBlock)(UIViewController *ctrl);

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray<YFSpecialLineListModel *> *dataArr;

@property (nonatomic, strong) YFBaseViewController *superVC;

@property (nonatomic, assign) NSInteger page;

/**
 yzf 已取消   yhz 未承运  whz 已开单  其余都为  已承运
 */
@property (nonatomic, copy) NSString *shipStatue;

/**
 出发地地址
 */
@property (nonatomic, copy) NSString *sendSite;

/**
 目的地地址
 */
@property (nonatomic, strong) NSMutableArray *recvSites;

/**
 是否还需要刷新
 */
@property (nonatomic, assign) BOOL isNeedRefresh;

/**
 是否还要展示tableViewfooter
 */
@property (nonatomic, assign) BOOL isShowFooter;

/**
 请求成功
 */
@property (nonatomic, copy) void (^refreshBlock)(void);

/**
 请求失败
 */
@property (nonatomic, copy) void (^failureBlock)(void);

/**
 获取专线订单列表
 */
- (void)netWork;

/**
 选中哪条数据
 */
- (void)jumpCtrlWithSelectSection:(NSInteger)section;

/**
 专线订单按钮处理逻辑

 @param title  title
 @param section  选中的第几个
 */
- (void)handleSpecialLineOrderWithtTitle:(NSString *)title section:(NSInteger)section;

NS_ASSUME_NONNULL_END
@end
