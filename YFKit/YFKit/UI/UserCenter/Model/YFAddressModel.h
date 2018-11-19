//
//  YFAddressModel.h
//  YFKit
//
//  Created by 王宇 on 2018/6/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFAddressModel : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) BOOL    isDefault;
@property (nonatomic, assign) BOOL    isSelect;
@property (nonatomic, copy) NSString *receiverAddr;
@property (nonatomic, copy) NSString *receiverCity;
@property (nonatomic, copy) NSString *receiverContacts;
@property (nonatomic, copy) NSString *receiverMobile;
@property (nonatomic, copy) NSString *siteCode;
@property (nonatomic, copy) NSString *remark;

@end

@interface YFConsignerModel : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) BOOL    isDefault;
@property (nonatomic, assign) BOOL    isSelect;
@property (nonatomic, copy) NSString *consignerAddr;
@property (nonatomic, copy) NSString *consignerCity;
@property (nonatomic, copy) NSString *consignerContacts;
@property (nonatomic, copy) NSString *consignerMobile;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *siteCode;
NS_ASSUME_NONNULL_END
@end

