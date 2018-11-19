//
//  YFHomeDataModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFHomeDataModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *placeholder;
/**
 是否是用户选中或者填写的, 默认是 NO
 */
@property (nonatomic, assign) BOOL isCheck;
NS_ASSUME_NONNULL_END
@end
