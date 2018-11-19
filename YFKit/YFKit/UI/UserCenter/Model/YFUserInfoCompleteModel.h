//
//  YFUserInfoCompleteModel.h
//  YFKit
//
//  Created by 王宇 on 2018/10/22.
//  Copyright © 2018 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFUserInfoCompleteModel : NSObject

+ (YFUserInfoCompleteModel *)shareInstace;

/**
 信息是否完整
 */
@property (nonatomic, assign) BOOL isCompleteInfo;

@end

NS_ASSUME_NONNULL_END
