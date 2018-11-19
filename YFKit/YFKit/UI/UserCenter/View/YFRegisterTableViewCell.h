//
//  YFRegisterTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFRegisterTableViewCell : UITableViewCell{
    NSInteger counting;//倒计时秒数
}

@property (nonatomic, strong) NSTimer *timer;

/**
 手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/**
验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
/**
 设置密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
/**
 确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *savePswTF;
/**
 公司名称
 */
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
/**
 邀请人电话
 */
@property (weak, nonatomic) IBOutlet UITextField *InviterPhone;
/**
 注册
 */
@property (weak, nonatomic) IBOutlet UIButton *rgisterBtn;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

/**
 阅读并同意
 */
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (nonatomic, strong) YFBaseViewController *superVC;
/**
 注册成功
 */
@property (nonatomic, copy) void(^registerSuccessBlock)(void);
@end
