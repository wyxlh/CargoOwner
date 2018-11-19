//
//  YFReleseDetailModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YFReleseDetailModel : NSObject

@property (nonatomic ,copy) NSString *taskId;//任务单单号
@property (nonatomic ,copy) NSString *publishedTime;//任务单单号
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
@property (nonatomic ,copy) NSString *expectPrice;//运费
@property (nonatomic ,copy) NSString *endSite;// 联系人
@property (nonatomic ,copy) NSString *endAddress;//  起始地详细地址
@property (nonatomic ,copy) NSString *driverPhone;// 司机电话
@property (nonatomic ,copy) NSString *driverName;// 司机名称
@property (nonatomic ,copy) NSString *driverId;// 司机名称
@property (nonatomic, strong) NSArray *goodsItem;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *supplyGoodsId;

@property (nonatomic, copy) NSString *startSiteCode;
@property (nonatomic, copy) NSString *endSiteCode;

@property (nonatomic, copy) NSString *consignerMobile;//发货人和收货人信息
@property (nonatomic, copy) NSString *consignerName;
@property (nonatomic, copy) NSString *receiverMobile;
@property (nonatomic, copy) NSString *receiverName;

/**
 出发地经纬度
 */
@property (nonatomic, assign) CGFloat startSiteLongitude;
@property (nonatomic, assign) CGFloat startSiteLatitude;
/**
 目的地经纬度
 */
@property (nonatomic, assign) CGFloat endSiteLongitude;
@property (nonatomic, assign) CGFloat endSiteLatitude;
@property (nonatomic, assign) CGFloat updateDate;
/**
 验证货源有没有被接单 Id
 */
@property (nonatomic, copy)   NSString *verificationId;
@end

@interface goodsItemModel : NSObject
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsVolume;
@property (nonatomic, copy) NSString *goodsWeight;
@property (nonatomic, copy) NSString *supplyGoodsId;

@end


NS_ASSUME_NONNULL_END
