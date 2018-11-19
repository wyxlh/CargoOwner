//
//  MHSelectPickerView.m
//  MHDatePicker
//
//  Created by LMH on 16/03/12.
//  Copyright (c) 2015年 LMH. All rights reserved.
//

#import "MHSelectPickerView.h"

@implementation MHSelectPickerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateArr = [NSArray getDateArray];
    self.timeArr = [NSArray getTimeArray];
    self.nearArr = [NSArray getNearArrat];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    //默认选中第一条数据
    self.firstStr = self.dateArr[0];
    self.secondStr = self.timeArr[0];
    self.selectStr = [NSString stringWithFormat:@"%@ %@",self.firstStr,self.secondStr];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    [self changeSpearatorLineColor];
    _lineWidth.constant = 1;
    _lineHeight.constant = 0.5;
}

#pragma mark UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.dateArr.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = self.timeArr.count;
            break;
            
        default:
            break;
    }
    
    return result;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title = nil;
    switch (component) {
        case 0:
            if (row < 3) {
                title = [NSString stringWithFormat:@"%@",self.dateArr[row]];
            }else{
                title = self.dateArr[row];
            }
            break;
        case 1:
            title = self.timeArr[row];
            break;
        default:
            break;
    }
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 0){
        self.firstStr = self.dateArr[row];
    }else{
        self.secondStr = self.timeArr[row];
    }
    self.selectStr = [NSString stringWithFormat:@"%@ %@",self.firstStr,self.secondStr];
}

- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor redColor];//隐藏分割线
        }
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    DLog(@"%@",self.selectStr);
    !self.callBackSelectTimeBlock ? : self.callBackSelectTimeBlock(self.selectStr);
}
@end
