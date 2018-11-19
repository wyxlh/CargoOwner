//
//  YFPersonImageModel.h
//  YFKit
//
//  Created by 王宇 on 2018/5/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface YFPersonImageModel : NSObject

/**
 0为待审核，1为审核通过，2审核不通过
 */
@property (nonatomic, assign) NSInteger auditStatus;
/**
 /公司名片照
 */
@property (nonatomic, copy) NSString *businessCardUrl;
/**
 公司名
 */
@property (nonatomic, copy) NSString *companyName;
/**
 门头照
 */
@property (nonatomic, copy) NSString *doorheadPhotoUrl;
/**
 身份证号码
 */
@property (nonatomic, copy) NSString *idcard;
/**
 身份证背面照
 */
@property (nonatomic, copy) NSString *identityBackUrl;
/**
 身份证正面
 */
@property (nonatomic, copy) NSString *identityUrl;
/**
 手机号
 */
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *realName;

/**
 是否是企业账户
 */
@property (nonatomic, assign) BOOL systemDef;

@end

@interface YFUserAccountTypeModel : NSObject
/**
 登录用户类型
 */
@property (nonatomic, copy) NSString *title;
/**
 默认选中第几个
 */
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
