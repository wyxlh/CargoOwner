//
//  YFOrderTrajectoryModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFOrderTrajectoryModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy)   NSString *adr;
@property (nonatomic, copy)   NSString *city;
@property (nonatomic, copy)   NSString *country;
@property (nonatomic, copy)   NSString *province;
@property (nonatomic, copy)   NSString *time;
@property (nonatomic, copy)   NSString *lat;
@property (nonatomic, copy)   NSString *lon;

@end


@interface YFOrderLocationModel : NSObject
@property (nonatomic, copy)   NSString *lat;
@property (nonatomic, copy)   NSString *lon;
@property (nonatomic, copy)   NSString *adr;
@property (nonatomic, copy)   NSString *city;
@property (nonatomic, copy)   NSString *country;
NS_ASSUME_NONNULL_END
@end

