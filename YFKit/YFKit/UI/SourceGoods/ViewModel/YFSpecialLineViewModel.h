//
//  YFSpecialLineViewModel.h
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFSpecialLineListModel;

@interface YFSpecialLineViewModel : NSObject

@property (nonatomic, strong, nullable) NSMutableArray *dataArr;

/**
 再来一单的数据
 */
@property (nonatomic, strong, nullable) YFSpecialLineListModel *itemModel;
/**
 GCD并发请求数据
 */
@property (nonatomic, strong) dispatch_group_t netWorkGroup;
/**
 操作成功刷新页面
 */
@property (nonatomic, copy) void (^operationSuccessBlock)(NSInteger section,NSInteger row);

/**
 这个页面的控制器
 */
@property (nonatomic, strong) YFBaseViewController *superVC;

/**
 计算总运费
 */
- (void)calculatedTotalFree;

/**
 发布专线订单
 */
- (void)postSpecialLineData;

/**
 页面跳转

 @param section  section
 @param index index
 */
- (void)jumpCtrlWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index;

/**
 添加货品信息
 */
- (void)addGoodsInformationWithSection:(NSInteger)section selectIndex:(NSInteger)selectIndex;

/**
 删除货品信息
 */
- (void)deleteGoodsInformationWithSection:(NSInteger)section selectIndex:(NSInteger)selectIndex;

/**
 选择货品名称
 */
- (void)chooseGoodsNameWithSection:(NSInteger)section selectIndex:(NSInteger)selectIndex;

@end
