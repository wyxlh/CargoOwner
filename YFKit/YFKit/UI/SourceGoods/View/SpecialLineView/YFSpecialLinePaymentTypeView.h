//
//  YFSpecialLinePaymentTypeView.h
//  YFKit
//
//  Created by 王宇 on 2018/9/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSpecialLinePaymentTypeView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cashPaymentTF;//现付
@property (weak, nonatomic) IBOutlet UITextField *toPayTF;//到付
@property (weak, nonatomic) IBOutlet UITextField *backPaymentTF;//回付
@property (weak, nonatomic) IBOutlet UILabel *toPayWarn;//到付警告
@property (weak, nonatomic) IBOutlet UILabel *backPayWarn;//回付警告

@property (nonatomic,strong)UIView *bGView;
@property (nonatomic, assign) double sumPrice;//现付金额
@property (nonatomic, copy) NSString *cashPrice;//到付金额
@property (nonatomic, copy) NSString *toPrice;//到付金额
@property (nonatomic, copy) NSString *backPrice;//h回付金额
/**
 s输入框是否有小数点
 */
@property (nonatomic, assign) BOOL isHaveDian;
/**
 返回具体金额
 */
@property (nonatomic, copy) void (^payMentTypeMoneyDetailBlock)(NSString *cashMoney,NSString *toPayMoney,NSString *backMoney, NSString *moneyString);
//取消 需要把之前的值都重置
@property (nonatomic, copy) void (^ cancelPayMentTypeMoneyDetailBlock)(NSString *cashMoney,NSString *toPayMoney,NSString *backMoney, NSString *moneyString);
- (void)show:(BOOL)animated;
@end
