//
//  YFReleseDetailModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFReleseDetailModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic ,copy) NSString *taskId;//任务单单号
@property (nonatomic ,copy) NSString *pickGoodsDate;//预期提货日期
@property (nonatomic ,copy) NSString *pickGoodsDateStart;//预期提货日期开始时间点
@property (nonatomic ,copy) NSString *pickGoodsDateEnd;//预期提货日期结束时间点
@property (nonatomic ,copy) NSString *vehicleCarLength;//车长
@property (nonatomic ,copy) NSString *vehicleCarType;//车型
@property (nonatomic ,copy) NSString *vehicleCarNum;// 期望车辆数
@property (nonatomic ,copy) NSString *unloadWay;// 装卸方式
@property (nonatomic ,copy) NSString *startSite;// 起始地
@property (nonatomic ,copy) NSString *startAddress;// 起始地详细地址
@property (nonatomic ,copy) NSString *remark;//
@property (nonatomic ,copy) NSString *quotedPrice;// 报价金额
@property (nonatomic ,copy) NSString *linkPhone;// 联系电话
@property (nonatomic ,copy) NSString *linkMan;// 联系人
@property (nonatomic ,copy) NSString *expectPrice;// 目的地
@property (nonatomic ,copy) NSString *endSite;// 联系人
@property (nonatomic ,copy) NSString *endAddress;//  起始地详细地址
@property (nonatomic ,copy) NSString *driverPhone;// 司机电话
@property (nonatomic ,copy) NSString *driverName;// 司机名称
@property (nonatomic, strong) NSArray *goodsItem;

@end

@interface goodsItemModel : NSObject
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsVolume;
@property (nonatomic, copy) NSString *goodsWeight;
@property (nonatomic, copy) NSString *supplyGoodsId;
NS_ASSUME_NONNULL_END
@end
