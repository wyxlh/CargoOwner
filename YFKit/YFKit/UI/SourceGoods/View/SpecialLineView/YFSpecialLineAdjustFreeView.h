//
//  YFSpecialLineAdjustFreeView.h
//  YFKit
//
//  Created by 王宇 on 2018/9/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFSpecialInterestRateModel;
typedef NS_ENUM(NSInteger, OtherFreeType) {
    OtherFreeValueType,//声明价值
    OtherFreeCollectionType//代收货款
};

@interface YFSpecialLineAdjustFreeView : UIView<UIGestureRecognizerDelegate,UITextFieldDelegate>
/**
 费用说明
 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/**
 费用 view
 */
@property (weak, nonatomic) IBOutlet UIView *freeView;
/**
  费用输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *freeTF;
/**
 手续费
 */
@property (weak, nonatomic) IBOutlet UILabel *serviceFree;
/**
 详细描述
 */
@property (weak, nonatomic) IBOutlet UILabel *detailService;
@property (weak, nonatomic) IBOutlet UILabel *secondDetailService;

/**
 页面的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
/**
 确认
 */
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
/**
 判断是声明价值 还是代收货款
 */
@property (nonatomic, assign) OtherFreeType otherFreeType;
/**
 利率 Model
 */
@property (nonatomic, strong) YFSpecialInterestRateModel *rateModel;
/**
 s输入框是否有小数点
 */
@property (nonatomic, assign) BOOL isHaveDian;
/**
 重新赋值
 */
@property (nonatomic, copy) NSString *textFree;
/**返回添加的价钱*/
@property (nonatomic, copy) void (^freeInformationBlock)(OtherFreeType freeType, NSString *price, NSString *serviceFree);
@end
