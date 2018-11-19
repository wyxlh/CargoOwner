//
//  YFCarSourceHeadView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonTitleType) {
    CarMessageTitleType,//车型车长
    AddressTitleType,//出发地, 目的地
};

@interface YFCarSourceHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *carTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *carLengthBtn;
/**
 btn 数组和
 */
@property (nonatomic, strong) NSMutableArray *btnArr;
/**
 选择的第几个
 */
@property (nonatomic, assign) NSInteger selectBtn;
/**
 返回 btn 的 tag 和选中状态
 */
@property (nonatomic, copy) void (^callBackBlock)(NSInteger,BOOL);

/**
 设置按钮的选中状态
 
 @param isSelect 是否选中 这里是这是所有按钮, 所以在本程序中 只有设置为 NO 的情况
 */
- (void)setButtonSelectType:(BOOL)isSelect;

/**
 设置 button Title
 */
- (void)setButtonTitltWithButtonTitleType:(ButtonTitleType)buttonTitleType;

@end
