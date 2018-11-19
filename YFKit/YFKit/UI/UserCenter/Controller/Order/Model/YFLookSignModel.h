//
//  YFLookSignModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFLookSignModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *taskId;
/**
 状态
 */
@property (nonatomic, copy) NSString *opStatue;
/**
 备注
 */
@property (nonatomic, copy) NSString *opRemark;
/**
 异常类型
 */
@property (nonatomic, copy) NSString *opErrType;
@property (nonatomic, copy) NSString *signUser;;
@property (nonatomic, copy) NSString *signTime;
@property (nonatomic, strong) NSArray *opPicurls;
NS_ASSUME_NONNULL_END
@end



