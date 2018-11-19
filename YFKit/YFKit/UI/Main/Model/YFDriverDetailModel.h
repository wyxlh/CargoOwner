//
//  YFDriverDetailModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFDriverDetailModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *certifiedStatus;
@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *driverMobile;
@property (nonatomic, copy) NSString *driverName;
/**
 车牌号
 */
@property (nonatomic, copy) NSString *carLawId;
NS_ASSUME_NONNULL_END
@end
