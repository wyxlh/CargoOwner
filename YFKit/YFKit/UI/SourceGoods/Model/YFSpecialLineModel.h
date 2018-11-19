//
//  YFSpecialLineModel.h
//  YFKit
//
//  Created by 王宇 on 2018/9/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFSpecialLineModel : NSObject
NS_ASSUME_NONNULL_BEGIN
/**
 申明价值
 */
@property (nonatomic, copy) NSString *adjustTotalPrice;
/**
 代收货款
 */
@property (nonatomic, copy) NSString *collectionTotalPrice;
/**
 保价费
 */
@property (nonatomic, copy) NSString *adjustMoney;
/**
 手续费
 */
@property (nonatomic, copy) NSString *collectionMoney;
/**
 信息费
 */
@property (nonatomic, copy) NSString *informationTF;
/**
 提货费
 */
@property (nonatomic, copy) NSString *takeGoodsTF;
/**
 送单费
 */
@property (nonatomic, copy) NSString *giveGoodsTF;
/**
 回单费
 */
@property (nonatomic, copy) NSString *returnOrderTF;

@end

@interface YFSpecialGoodsInformationModel : NSObject
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsNumber;
@property (nonatomic, copy) NSString *goodsVolume;
@property (nonatomic, copy) NSString *goodsWeight;

@end

@interface YFSpecialInterestRateModel : NSObject
/**
 代收费费率
 */
@property (nonatomic, strong) NSNumber *handlingFeeRate;
/**
 保价费费率
 */
@property (nonatomic, strong) NSNumber *insurancePriceRate;
/**
 代收费最低钱
 */
@property (nonatomic, strong) NSNumber *minHandlingFee;
/**
 保价最低收钱
 */
@property (nonatomic, strong) NSNumber *minInsurancePriceFee;

@end

NS_ASSUME_NONNULL_END
