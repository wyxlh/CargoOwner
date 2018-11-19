//
//  YFDriverListModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFDriverListModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *carLawId;//车牌号
@property (nonatomic, copy) NSString *carNoBack;//备选车
@property (nonatomic, copy) NSString *carNoDef;//常跑车
@property (nonatomic, copy) NSString *carSize;//车长
@property (nonatomic, copy) NSString *containerType;//车型
@property (nonatomic, copy) NSString *driverId;//司机编码
@property (nonatomic, copy) NSString *driverMobile;//司机手机
@property (nonatomic, copy) NSString *driverName;//司机名称
@property (nonatomic, copy) NSString *driverPhone;//司机电话
@property (nonatomic, copy) NSString *sourceType;//来源类型:0-平台维护;1-注册;2-收藏
@property (nonatomic, copy) NSString *syscode;//机构编码
@property (nonatomic, copy) NSString *locAddr;//指定司机位置信息
@property (nonatomic, copy) NSString *transactionCount;//交易次数
@property (nonatomic, copy) NSString *locTime;//司机定位时时间,用来判断司机是否在线
@property (nonatomic, assign) BOOL onLine;//是否在线
NS_ASSUME_NONNULL_END
@end
