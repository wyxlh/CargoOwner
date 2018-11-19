//
//  MHDatePicker.h
//  MHDatePicker
//
//  Created by LMH on 16/03/12.
//  Copyright (c) 2015年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSelectPickerView.h"

@interface MHDatePicker : UIView
@property (strong, nonatomic) NSDate *maxSelectDate;
///优先级低于isBeforeTime
@property (strong, nonatomic) NSDate *minSelectDate;

@property (strong, nonatomic) NSDate *selectDate;

///是否可选择当前时间之前的时间,默认为NO
@property (nonatomic,assign) BOOL isBeforeTime;

///DatePickerMode,默认是DateAndTime
@property (assign, nonatomic) UIDatePickerMode datePickerMode;

@property (nonatomic, copy) void(^DataTimeSelectBlock)(NSString *);
@end
