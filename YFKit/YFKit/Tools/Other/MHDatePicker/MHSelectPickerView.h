//
//  MHSelectPickerView.h
//  MHDatePicker
//
//  Created by LMH on 16/03/12.
//  Copyright (c) 2015年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHSelectPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (nonatomic, strong) NSArray *dateArr,*timeArr,*nearArr;//时间数据
@property (nonatomic, copy) NSString *selectStr;//选中的数据
@property (nonatomic, copy) NSString *firstStr,*secondStr;//第一行和第二行的数据
@property (nonatomic, copy) void (^callBackSelectTimeBlock)(NSString *);
@end
