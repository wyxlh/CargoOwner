//
//  YFMechanismLoginView.h
//  YFKit
//
//  Created by 王宇 on 2018/11/1.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFMechanismLoginView : UIView
/**
 机构编码
 */
@property (weak, nonatomic) IBOutlet UITextField *mechanismNumTF;
/**
 用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
/**
 登录
 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) YFBaseViewController *superVC;
/**
 登录成功
 */
@property (nonatomic, copy) void(^mechanismLoginSuccessBlock)(void);
/**
 登录失败
 */
@property (nonatomic, copy) void(^mechanismLoginFailureBlock)(void);
@end

NS_ASSUME_NONNULL_END
