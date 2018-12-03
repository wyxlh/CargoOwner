//
//  YFLookSignModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface YFLookSignModel : NSObject

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

@end

@interface YFSearchLookSignModel : NSObject
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *signStatus;
@property (nonatomic, copy) NSString *signatory;
@property (nonatomic, strong) NSArray *pictureUrl;
@end


NS_ASSUME_NONNULL_END



