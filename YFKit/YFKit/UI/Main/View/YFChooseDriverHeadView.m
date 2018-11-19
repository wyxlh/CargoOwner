//
//  YFChooseDriverHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFChooseDriverHeadView.h"

@implementation YFChooseDriverHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    //设置TextField属性之文字距左边框的距离
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    SKViewsBorder(self.textField, 0, 0.5, UIColorFromRGB(0x5A8FEA));
    SKViewsBorder(self.searchBtn, 3, 0, NavColor);
    @weakify(self);
    RACSignal *programmerSignal = [self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)];
    [programmerSignal subscribeNext:^(RACTuple* x) {
        //这里可以理解为的方法要的执行代码
        @strongify(self);
        !self.clickSearchCallBackBlock ? : self.clickSearchCallBackBlock();
    }];
}


- (IBAction)clickSearch:(id)sender {
    !self.clickSearchCallBackBlock ? : self.clickSearchCallBackBlock();
}

@end
