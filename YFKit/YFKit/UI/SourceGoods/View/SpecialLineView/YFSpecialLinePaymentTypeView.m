//
//  YFSpecialLinePaymentTypeView.m
//  YFKit
//
//  Created by 王宇 on 2018/9/12.
//  Copyright © 2018年 wy. All rights reserved.
//
#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]

#import "YFSpecialLinePaymentTypeView.h"

@implementation YFSpecialLinePaymentTypeView

- (void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self, 5, 0, NavColor);
    SKViewsBorder(self.toPayTF, 0, 0.6, UIColorFromRGB(0xCCCCCC));
    SKViewsBorder(self.cashPaymentTF, 0, 0.6, UIColorFromRGB(0xCCCCCC));
    SKViewsBorder(self.backPaymentTF, 0, 0.6, UIColorFromRGB(0xCCCCCC));
    //设置TextField属性之文字距左边框的距离
    self.cashPaymentTF.leftView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.toPayTF.leftView               = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.backPaymentTF.leftView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.cashPaymentTF.leftViewMode     = UITextFieldViewModeAlways;
    self.toPayTF.leftViewMode           = UITextFieldViewModeAlways;
    self.backPaymentTF.leftViewMode     = UITextFieldViewModeAlways;
    self.toPayTF.delegate               = self;
    self.backPaymentTF.delegate         = self;
    @weakify(self)
    [[self.toPayTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *toPayString           = [NSString stringWithFormat:@"%@",x];
        if ([toPayString doubleValue] > self.sumPrice - [self.backPaymentTF.text doubleValue]) {
            self.toPayTF.text           = toPayString = [toPayString substringToIndex:toPayString.length-1];
            self.toPayWarn.hidden       = NO;
        }else{
            self.toPayWarn.hidden       = YES;
        }
        self.cashPaymentTF.text         = [NSString stringWithFormat:@"%.2f",self.sumPrice - [toPayString doubleValue]-[self.backPaymentTF.text doubleValue]];
        
    }];
    [[self.backPaymentTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *toPayString           = [NSString stringWithFormat:@"%@",x];
        if ([toPayString doubleValue] > self.sumPrice - [self.toPayTF.text doubleValue]) {
            self.backPaymentTF.text     = toPayString = [toPayString substringToIndex:toPayString.length-1];
            self.backPayWarn.hidden     = NO;
        }else{
            self.backPayWarn.hidden     = YES;
        }
        self.cashPaymentTF.text         = [NSString stringWithFormat:@"%.2f",self.sumPrice - [toPayString doubleValue]-[self.toPayTF.text doubleValue]];
        
    }];
}

//到付
- (void)setCashPrice:(NSString *)cashPrice{
    _cashPrice                          = cashPrice;
    if ([NSString isBlankString:cashPrice]) {
        self.cashPaymentTF.text         = @"0.00";
        return;
    }
    if ([NSString isBlankString:self.toPayTF.text] && [NSString isBlankString:self.backPaymentTF.text]) {
        //如果到付 和回付 都为空
        self.cashPaymentTF.text         = [NSString stringWithFormat:@"%.2f",self.sumPrice];
    }else{
        self.cashPaymentTF.text         = [NSString stringWithFormat:@"%@",self.cashPrice];
    }
}

//现付
- (void)setToPrice:(NSString *)toPrice{
    _toPrice                            = toPrice;
    if ([NSString isBlankString:toPrice]) {
        self.toPayTF.text               = @"";
        return;
    }
    if (![toPrice isEqualToString:@"0"] && [NSString isPureInt:toPrice]) {
        self.toPayTF.text               = toPrice;
    }else if (![toPrice isEqualToString:@"0"] && ![NSString isPureInt:toPrice]){
        self.toPayTF.text               = [NSString stringWithFormat:@"%.2f",[self.toPrice doubleValue]];
    }else{
        self.toPayTF.text               = @"";
    }
}

//回付
- (void)setBackPrice:(NSString *)backPrice{
    _backPrice                          = backPrice;
    if ([NSString isBlankString:backPrice]) {
        self.backPaymentTF.text         = @"";
        return;
    }
    if (![backPrice isEqualToString:@"0"] && [NSString isPureInt:backPrice]) {
        self.backPaymentTF.text         = backPrice;
    }else if (![backPrice isEqualToString:@"0"] && ![NSString isPureInt:backPrice]){
        self.backPaymentTF.text         = [NSString stringWithFormat:@"%.2f",[self.backPrice doubleValue]];
    }else{
        self.backPaymentTF.text         = @"";
    }
}

- (IBAction)clickBtn:(UIButton *)sender {
    [self endEditing:YES];
    if (sender.tag == 10) {
        //到付
        self.toPayTF.text               = [NSString stringWithFormat:@"%.2f",self.sumPrice];
        self.cashPaymentTF.text         = @"0.00";
        self.backPaymentTF.text         = @"";
    }else{
        //回付
        self.backPaymentTF.text         = [NSString stringWithFormat:@"%.2f",self.sumPrice];
        self.cashPaymentTF.text         = @"0.00";
        self.toPayTF.text               = @"";
    }
}


- (void)customview{
    if (self.bGView==nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [YFWindow addSubview:view];
        self.bGView =view;
    }
    self.center = CGPointMake(ScreenWidth/2, ScreenHeight/2.5);
    self.bounds = CGRectMake(0, 0, ScreenWidth-40, 220);
    [YFWindow addSubview:self];
}

- (void)show:(BOOL)animated
{
    [self customview];
    if (animated)
    {
        [self animationAlert:self];
    }
}

- (void)hide:(BOOL)animated
{
    if (self.bGView != nil) {
        [self.bGView removeFromSuperview];
        [self removeFromSuperview];
        self.bGView = nil;
    }
}

-(void)disapper{
    [self.bGView removeFromSuperview];
    [self removeFromSuperview];
    self.bGView = nil;
}

- (IBAction)clickCancelBtn:(id)sender {
//    if (self.toPayTF.text.length != 0 || self.backPaymentTF.text.length != 0) {
//        //得到总和
//        double sum = [self.cashPaymentTF.text doubleValue] + [self.toPayTF.text doubleValue] + [self.backPaymentTF.text doubleValue];
//        !self.cancelPayMentTypeMoneyDetailBlock ? : self.cancelPayMentTypeMoneyDetailBlock([NSString stringWithFormat:@"%f",sum],self.toPayTF.text,self.backPaymentTF.text,[NSString stringWithFormat:@"现付%.2f",sum]);
//    }
    [self disapper];
}
- (IBAction)clickSaveBtn:(id)sender {
    NSString *moneyString = @"";
    if (![self.cashPaymentTF.text isEqualToString:@"0.00"] && ![NSString isBlankString:self.toPayTF.text] && [NSString isBlankString:self.backPaymentTF.text]) {
        moneyString = [NSString stringWithFormat:@"现付%@/到付..",self.cashPaymentTF.text];
    }else if (![self.cashPaymentTF.text isEqualToString:@"0.00"] && [NSString isBlankString:self.toPayTF.text] && [NSString isBlankString:self.backPaymentTF.text]){
        moneyString = [NSString stringWithFormat:@"现付%@",self.cashPaymentTF.text];
    }else if (![self.cashPaymentTF.text isEqualToString:@"0.00"] && [NSString isBlankString:self.toPayTF.text] && ![NSString isBlankString:self.backPaymentTF.text]){
        moneyString = [NSString stringWithFormat:@"现付%@/回付..",self.cashPaymentTF.text];
    }else if (![self.cashPaymentTF.text isEqualToString:@"0.00"] && ![NSString isBlankString:self.toPayTF.text] && ![NSString isBlankString:self.backPaymentTF.text]){
        moneyString = [NSString stringWithFormat:@"现付%@/到付../回付..",self.cashPaymentTF.text];
    }else if ([self.cashPaymentTF.text isEqualToString:@"0.00"] && ![NSString isBlankString:self.toPayTF.text] && [NSString isBlankString:self.backPaymentTF.text]){
        moneyString = [NSString stringWithFormat:@"现付%@/到付..",self.cashPaymentTF.text];
    }else if ([self.cashPaymentTF.text isEqualToString:@"0.00"] && [NSString isBlankString:self.toPayTF.text] && ![NSString isBlankString:self.backPaymentTF.text]){
        moneyString = [NSString stringWithFormat:@"现付%@/回付..",self.cashPaymentTF.text];
    }else if ([self.cashPaymentTF.text isEqualToString:@"0.00"] && ![NSString isBlankString:self.toPayTF.text] && ![NSString isBlankString:self.backPaymentTF.text]){
        moneyString = [NSString stringWithFormat:@"现付%@/到付../回付..",self.cashPaymentTF.text];
    }
    //返回相关数据
    !self.payMentTypeMoneyDetailBlock ? : self.payMentTypeMoneyDetailBlock (self.cashPaymentTF.text,self.toPayTF.text,self.backPaymentTF.text,moneyString);
    [self disapper];
    
}

-(void) animationAlert:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

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
                if (single == '0')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
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


@end
