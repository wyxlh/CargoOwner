//
//  NSArray+AddressMsg.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFCarTypeModel.h"
@interface NSArray (AddressMsg)


/**
 读取本地JSON文件

 @param name 文件名
 */
+ (NSArray *)readLocalFileWithName:(NSString *)name;

/**
 获取车型
*/
+ (NSArray *)getCartType;

/**
 获取车长
 */
+ (NSArray *)getCarLength;

/**
 获取货品名称
 */
+ (NSArray *)getGoodsName;

/**
 获取其他要求
 */
+ (NSArray *)getOtherRequirement;

/**
 获取首页的 title 图片 和 placeholder
 */
+ (NSArray *)getHomeData;

/**
获取订单的 title 图片 和 placeholder
*/
+ (NSArray *)getOrderData;

/**
 获取专线开单的 title 图片 和 placeholder
 */
+ (NSArray *)getSpecialLineData;

/**
 得到当前日期的后十天
 */
+ (NSArray *)getDateArray;

/**
 得到具体时间
 */
+ (NSArray *)getTimeArray;

/**
 得到最近几天的数据
 */
+ (NSArray *)getNearArrat;

/**
 获取首页 title
 */
+ (NSArray *)getHomeTitleArray;

/**
 获取首页 image
 */
+ (NSArray *)getHomeImageArray;

/**
 获取首页 统计标识
 */
+ (NSArray *)getHomeIdentificationArray;

/**
 获取个人中心 图标 title
 */
+ (NSArray *)getUserCenterArray;

/**
 获取设置 title
 */
+ (NSArray *)getSettingArray;

/**
 获取司机详情的开始地点和目的地 logo
 */
+ (NSArray *)getDriverLogo;

/**
 开始 目的地图标
 */
+ (NSArray *)getOnlyRoadLogo;

/**
获取时间筛选条件
 */
+ (NSArray *)getTimeSortData;

/**
 获取价格筛选条件
 */
+ (NSArray *)getMoneySortData;

/**
获取登录方式
 */
+ (NSArray *)getLoginModeData;

/**
 获取个人信息里面身份证信息 title 或图片信息
 */
+ (NSArray *)getPersonIDCardTitle;

/**
 获取车型的头部数组
 */
+ (NSArray *)ChooseCarTypeHeadArray;

/**
 获取车长的头部数组
 */
+ (NSArray *)ChooseCarLengthHeadArray;

/**
 得到选择地区的 title
 */
+(NSArray *)getChooseAddressHeadTitleArr;

/**
 读取历史出发地数据
 */
+(NSArray *)readStartAddressData;

/**
 得到出发地历史数据
 
 @param startAddressArray 传入的数据
 */
+(NSArray *)saveStartAddressData:(NSMutableArray *)startAddressArray;

/**
 读取历史目的地数据
 */
+(NSArray *)readEndAddressData;

/**
 得到目的地的历史数据
 
 @param endAddressArray 传入的数据
 */
+(NSArray *)saveEndAddressData:(NSMutableArray *)endAddressArray;

/**
 读取历史车型
 */
+ (NSMutableArray *)readTypeData;

/**
 得到车型的历史数据
 
 @param selectArray 传入的数据
 */
+ (NSMutableArray *)saveCarTypeData:(NSMutableArray *)selectArray;
/**
 读取历史车长
 */
+ (NSMutableArray *)readLengthData;

/**
 得到车长的历史数据
 
 @param selectArray 传入的数据
 */
+ (NSMutableArray *)saveCarLengthData:(NSMutableArray *)selectArray;

/**
 获取附近 logo
 */
+ (NSArray *)getNearMapLogo;

/**
 获取取消货源的原因

 @return return value description
 */
+ (NSArray *)cancelSourceReasonData;

@end
