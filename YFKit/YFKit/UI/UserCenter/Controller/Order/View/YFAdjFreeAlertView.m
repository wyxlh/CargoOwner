//
//  YFAdjFreeAlertView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/18.
//  Copyright © 2018年 wy. All rights reserved.
//
#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]
#import "YFAdjFreeAlertView.h"
#import "YFOrderListModel.h"

@implementation YFAdjFreeAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.textField, 0, 0.5, UIColorFromRGB(0xCCCCCC));
    SKViewsBorder(self.textView, 0, 0.5, UIColorFromRGB(0xCCCCCC));
    SKViewsBorder(self, 5, 0, NavColor);
    self.textView.delegate = self;
    //设置TextField属性之文字距左边框的距离
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    @weakify(self)
    [[self.textView rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *text = [NSString stringWithFormat:@"%@",x];
        if ([NSString isBlankString:text]) {
            self.placehodle.hidden = NO;
        }else{
            self.placehodle.hidden = YES;
        }
        //最多50
        if (text.length>50) {
            self.textView.text = [text substringWithRange:NSMakeRange(0, 50)];
        }
    }];
    
}

- (void)customview{
    if (self.bGView==nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [YFWindow addSubview:view];
        self.bGView =view;
    }
    self.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    self.bounds = CGRectMake(0, 0, ScreenWidth-40, 205*(ScreenWidth-40)/280);
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
        self.bGView=nil;
    }
}

-(void)disapper{
    [self.bGView removeFromSuperview];
    [self removeFromSuperview];
    self.bGView=nil;
}
- (IBAction)clickCancelBtn:(id)sender {
    [self disapper];
}
- (IBAction)clickSaveBtn:(id)sender {
    [self adjustmentFree];
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

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake(ScreenWidth/2, ScreenHeight/2 - 100);
    }];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }];
}

-(void)adjustmentFree{
    NSString *alert;
    if ([NSString isBlankString:self.textField.text]) {
        alert                              = @"请输入调整后的金额";
    }else if ([self.textField.text integerValue] < 1){
        alert                               = @"运费必须大于0元";
    }else if ([NSString isBlankString:self.textView.text]){
        alert                               = @"请输入备注信息";
    }
    //订单的总和
    int total = self.model.addAmount.intValue + self.model.taskFee.intValue;
    //实际值
    int inputNum = [self.textField.text intValue];
    
//    int actual = abs(total-inputNum);
    
    if (total - inputNum  > 10000 || inputNum - total > 10000) {
        alert                               = @"增补金额之差应在0到1万之间";
    }
    
    DLog(@"%d  ,%d",(total - inputNum),(inputNum - total ));
    
    if (alert.length != 0) {
        !self.adjustmentFreeBlock ? : self.adjustmentFreeBlock(NO,alert,@"");
        [YFToast showMessage:alert inView:self];
        return;
    }
    
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.model.taskId forKey:@"taskId"];
    [parms safeSetObject:self.model.Id forKey:@"id"];
    [parms safeSetObject:self.textField.text forKey:@"finalFee"];
    [parms safeSetObject:self.textView.text forKey:@"remark"];
    [parms safeSetObject:self.model.refId forKey:@"refId"];
    NSInteger totalFee                      = self.model.taskFee.integerValue + self.model.addAmount.integerValue;
    [parms safeSetObject:@(totalFee) forKey:@"beforeFee"];
    @weakify(self)
    [WKRequest postWithURLString:@"v1/taskOrder/addCount.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        [self disapper];
        if (CODE_ZERO) {
            !self.adjustmentFreeBlock ? : self.adjustmentFreeBlock(YES,@"调整运费申请成功",self.textField.text);
        }else{
            !self.adjustmentFreeBlock ? : self.adjustmentFreeBlock(NO,baseModel.message,@"");
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
