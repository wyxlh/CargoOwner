//
//  YFCarTypeModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFCarTypeModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property(nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isSelect;

@end

@interface YFChooseAddressModel : NSObject
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *detailAddress;
@property(nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL isSelect;
NS_ASSUME_NONNULL_END
@end;
