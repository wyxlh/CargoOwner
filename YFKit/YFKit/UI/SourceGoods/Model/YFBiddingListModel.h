//
//  YFBiddingListModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBiddingListModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *endSite;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *nowTime;
@property (nonatomic, copy) NSString *pickGoodsDate;
@property (nonatomic, copy) NSString *startSite;
@property (nonatomic, copy) NSString *supplyGoodsId;
@property (nonatomic, strong) NSArray *priceList;
/**
倒计时
 */
@property (nonatomic, assign) NSInteger placeTime;

@end

@interface PriceListModel : NSObject
@property (nonatomic, copy) NSString *carrierLinkPhone;//司机手机
@property (nonatomic, copy) NSString *carrierName;//司机姓名
@property (nonatomic, copy) NSString *carrierSyscode;//司机id
@property (nonatomic, copy) NSString *channelWay;//报价渠道
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *quotePrice;//报价金额
@property (nonatomic, copy) NSString *quoteTime;
@property (nonatomic, copy) NSString *transactionCount;//交易次数
@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) BOOL    isCanOffer;//是否能报价
NS_ASSUME_NONNULL_END
@end
