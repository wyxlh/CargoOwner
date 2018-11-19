//
//  YFModeBindViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/10/17.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
  绑定手机号的来源

 - BindPhoneByPersonMessageType: 从个人资料跳转过来的
 - BindPhoneByTMSAccountType: 从使用机构编码登录跳转过来的
 */
typedef NS_ENUM(NSInteger, BindPhoneBySourceType) {
    BindPhoneByPersonMessageType,
    BindPhoneByTMSAccountType,
};

@interface YFModeBindViewController : YFBaseViewController

@property (nonatomic, assign) BindPhoneBySourceType sourceType;
@end

NS_ASSUME_NONNULL_END
