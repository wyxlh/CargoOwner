//
//  YFSpecialLineListModel.h
//  YFKit
//
//  Created by 王宇 on 2018/9/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSpecialLineListModel : NSObject
/**
 保价费
 */
@property (nonatomic, assign) double  baoJiaFee;
/**
 发货人地址
 */
@property (nonatomic, copy)   NSString *consignerAddr;
/**
 发货联系人
 */
@property (nonatomic, copy)   NSString *consignerContacts;
/**
 发货人电话
 */
@property (nonatomic, copy)   NSString *consignerMobile;
/**
 代收货款
 */
@property (nonatomic, assign) double  daiShouHuoKuanFee;
/**
 到付
 */
@property (nonatomic, copy) NSString  *daofuFee;
/**
 声明价值
 */
@property (nonatomic, assign) double  declareValue;
/**
 回单
 */
@property (nonatomic, assign) double  huiDanFee;
/**
 回h付
 */
@property (nonatomic, copy) NSString  *huifuFee;
/**
 手续费
 */
@property (nonatomic, assign) double  shouXuFee;
/**
 送货费
 */
@property (nonatomic, assign) double  songHuoFee;
/**
 提货费
 */
@property (nonatomic, assign) double  tiHuoFee;
/**
 现付费
 */
@property (nonatomic, copy) NSString  *xianfuFee;
/**
 信息费
 */
@property (nonatomic, assign) double  xinXiFee;
@property (nonatomic, copy)   NSString *Id;
/**
  收货人详细地址
 */
@property (nonatomic, copy)   NSString *receiverAddr;
/**
 收货人姓名
 */
@property (nonatomic, copy)   NSString *receiverContacts;
/**
 收货人电话
 */
@property (nonatomic, copy)   NSString *receiverMobile;
/**
 收货人城市
 */
@property (nonatomic, copy)   NSString *recvSite;
@property (nonatomic, copy)   NSString *recvSiteId;
/**
 备注
 */
@property (nonatomic, copy)   NSString *remark;
/**
  发货人城市
 */
@property (nonatomic, copy)   NSString *sendSite;
@property (nonatomic, copy)   NSString *sendSiteId;
/**
 时间
 */
@property (nonatomic, copy)   NSString *shipDateStr;
/**
 订单 id
 */
@property (nonatomic, copy)   NSString *shipId;
/**
 货品信息
 */
@property (nonatomic, copy)   NSArray  *goodsModel;
/**
 始发地经纬度
 */
@property (nonatomic, assign) CGFloat  consignerLatitude;
@property (nonatomic, assign) CGFloat  consignerLongitude;
/**
 目的地经纬度
 */
@property (nonatomic, assign) CGFloat  receiverLatitude;
@property (nonatomic, assign) CGFloat  receiverLongitude;
@end

@interface YFSpecialGoodsModel : NSObject
@property (nonatomic, assign) double    shipAmount;
@property (nonatomic, copy)   NSString *goodsName;
@property (nonatomic, copy)   NSString *goodsNo;
@property (nonatomic, copy)   NSString *goodsNumber;
@property (nonatomic, copy)   NSString *goodsVolume;
@property (nonatomic, copy)   NSString *goodsWeight;

@end
NS_ASSUME_NONNULL_END
