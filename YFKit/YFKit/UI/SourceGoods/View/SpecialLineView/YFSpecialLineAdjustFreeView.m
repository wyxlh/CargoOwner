//
//  YFSpecialLineAdjustFreeView.m
//  YFKit
//
//  Created by 王宇 on 2018/9/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineAdjustFreeView.h"
#import "YFSpecialLineModel.h"

@implementation YFSpecialLineAdjustFreeView

- (void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.freeView, 0, 0.8, UIColorFromRGB(0xF2F2F2));
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.freeTF.delegate = self;
    @weakify(self)
    //开始编辑
    [[self.freeTF rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
        @strongify(self)
        self.heightCons.constant            = 470.0f;
        
    }];
    //结束编辑
    [[self.freeTF rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        @strongify(self)
        self.heightCons.constant            = 280.0f;
    }];
    //监听 最多8位数
    [[self.freeTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *freeString                = [NSString stringWithFormat:@"%@",x];
        if ([freeString integerValue] == 0 && freeString.length != 0) {
            self.freeTF.text                = @"0";
        }
        if (freeString.length > 6) {
            self.freeTF.text                = freeString = [freeString substringWithRange:NSMakeRange(0, 6)];
        }
        NSString *doubleString              = [NSString stringWithFormat:@"%.2f",[self getMinimumPriceFee:self.freeTF.text]];
        DLog(@"%f",[self getMinimumPriceFee:self.freeTF.text]);
        if (self.otherFreeType == OtherFreeValueType) {
            [AttributedLbl setRichTextOnlyColor:self.serviceFree titleString:[NSString stringWithFormat:@"   预估保价费%@元",doubleString] textColor: OrangeBtnColor colorRang:NSMakeRange(8, doubleString.length)];
        }else{
            [AttributedLbl setRichTextOnlyColor:self.serviceFree titleString:[NSString stringWithFormat:@"   预估手续费%@元",doubleString] textColor: OrangeBtnColor colorRang:NSMakeRange(8, doubleString.length)];
        }
        
    }];
}

//如果有值就重新赋值上去
- (void)setTextFree:(NSString *)textFree{
    self.freeTF.text = [textFree isEqualToString:@"0"] ? @"" : textFree;
}

/**
 得到最低b用费, 如果输入的费用低于设置的费用 则为最低费用 高于就远本来应该的费用
 @param fee 输入的费用
 */
- (double)getMinimumPriceFee:(NSString *)fee{
    if (self.otherFreeType == OtherFreeValueType) {
        //申明价值
        double minPrice = [fee doubleValue] * (self.rateModel.insurancePriceRate.doubleValue/1000);
        if (minPrice >= self.rateModel.minInsurancePriceFee.doubleValue) {
            return minPrice;
        }
        return self.rateModel.minInsurancePriceFee.doubleValue;
    }else{
        //代收货款
        double minPrice = [fee doubleValue] * (self.rateModel.handlingFeeRate.doubleValue/1000);
        if (minPrice >= self.rateModel.minHandlingFee.doubleValue) {
            return minPrice;
        }
        return self.rateModel.minHandlingFee.doubleValue;
    }
    
}

-(void)setOtherFreeType:(OtherFreeType)otherFreeType{
    _otherFreeType                          = otherFreeType;
    [self.freeTF becomeFirstResponder];
    if (otherFreeType == OtherFreeValueType) {
        self.title.text                     = @"申明价值";
        self.detailService.text             = @"1.保价费用按声明价值的比例收取";
        [AttributedLbl setRichTextOnlyColor:self.serviceFree titleString:@"   预估保价费0.00元" textColor: OrangeBtnColor colorRang:NSMakeRange(8, 4)];
    }else{
        self.title.text                     = @"代收货款";
        self.detailService.text             = @"1.手续费用按代收货款的比例收取";
        [AttributedLbl setRichTextOnlyColor:self.serviceFree titleString:@"   预估手续费0.00元" textColor: OrangeBtnColor colorRang:NSMakeRange(8, 4)];
    }
}

#pragma mark UITableViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        self.isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
//                if (single == '0')
//                {
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
            }
            //输入的字符是否是小数点
            if (single == '.')
            {
                if(!self.isHaveDian)//text中还没有小数点
                {
                    self.isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight) {
        return YES;
    }
    return NO;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self disappear];
}

- (IBAction)clickDisppear:(id)sender {
    [self disappear];
}

- (void)disappear
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (IBAction)clickSaveBtn:(id)sender {
    [self disappear];
    if ([NSString isBlankString:self.freeTF.text]) {
        return;
    }
    NSString *serviceFree  = [NSString stringWithFormat:@"%.2f",[self getMinimumPriceFee:self.freeTF.text]];
    !self.freeInformationBlock ? : self.freeInformationBlock(self.otherFreeType,self.freeTF.text,serviceFree);
    self.freeTF.text       = @"";
}



@end
