//
//  YFAddressDataTool.h
//  YFKit
//
//  Created by 王宇 on 2018/12/11.
//  Copyright © 2018 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YFAddressType) {
    YFSendAddressType = 0, //发货人地址
    YFReceiverAddressType, //收货人地址
};

@interface YFAddressDataTool : NSObject

+ (instancetype)shareInstance;

/**
 发货人地址信息

 @param resultBlock 返回的数据
 */
- (void)getSendAddress:(void(^)(NSArray <YFAddressModel *> *models))resultBlock;

/**
 收货人地址信息

 @param resultBlock 返回的数据
 */
- (void)getReceiverAddress:(void(^)(NSArray <YFAddressModel *> *models))resultBlock;

/**
 设置默认地址

 @param addressType 地址类型
 @param addressId 地址id
 */
- (void)setDefaultAddressId:(NSString *)addressId
                addressType:(YFAddressType)addressType
               successBlock:(void(^)(void))successBlock;

/**
 删除地址

 @param addressId id
 @param addressType 地址类型
 @param successBlock 成功返回
 */
- (void)setDeleteAddressId:(NSString *)addressId
                   addressType:(YFAddressType)addressType
                  successBlock:(void(^)(void))successBlock;

@end

NS_ASSUME_NONNULL_END
