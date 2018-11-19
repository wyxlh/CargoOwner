//
//  YFTwoInverGeoModel.h
//  YFKit
//
//  Created by 王宇 on 2018/9/20.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSingle.h"
NS_ASSUME_NONNULL_BEGIN

@interface YFTwoInverGeoModel : NSObject
SKSingleH(YFTwoInverGeoModel)
/**
 返回经纬度
 
 @param address address description
 */
- (void)getLatitudeAndlongitudeWithAddress:(NSString *)address;
@property (nonatomic, copy) void (^latitudeAndlongitudeBlock)(CGFloat ,CGFloat);
@end

NS_ASSUME_NONNULL_END
