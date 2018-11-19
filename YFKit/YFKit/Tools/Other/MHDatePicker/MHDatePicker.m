//
//  MHDatePicker.m
//  MHDatePicker
//
//  Created by LMH on 16/03/12.
//  Copyright (c) 2015年 LMH. All rights reserved.
//

#import "MHDatePicker.h"
#define kWinH [[UIScreen mainScreen] bounds].size.height
#define kWinW [[UIScreen mainScreen] bounds].size.width

// pickerView高度
#define kPVH (kWinH*0.35>230?230:(kWinH*0.35<200?200:kWinH*0.35))

@interface MHDatePicker()
@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) MHSelectPickerView *pickView;

@end

@implementation MHDatePicker

- (instancetype)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {

        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景按钮
        _bgButton = [[UIButton alloc] init];
        [self addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        _bgButton.alpha = 0.0;
        _bgButton.frame = CGRectMake(0, 0, kWinW, kWinH);
        
        //时间选择View
        [self addSubview:self.pickView];
        //显示
        [self pushDatePicker];
    }
    return self;
}

//出现
- (void)pushDatePicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickView.frame = CGRectMake(0, kWinH - kPVH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.2;
    }];
}

//消失
- (void)dismissDatePicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.pickView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
#pragma mark  时间选择器
-(MHSelectPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[[NSBundle mainBundle] loadNibNamed:@"MHSelectPickerView" owner:nil options:nil] lastObject];
        _pickView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        [_pickView.cancleBtn addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        WS(weakSelf)
        _pickView.callBackSelectTimeBlock = ^(NSString *select){
            [weakSelf dismissDatePicker];
            !weakSelf.DataTimeSelectBlock ? : weakSelf.DataTimeSelectBlock(select);
        };
    }
    return _pickView;
}


@end
