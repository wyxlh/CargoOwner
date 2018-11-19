//
//  YFCarSourceHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFCarSourceHeadView.h"

@implementation YFCarSourceHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    //车型 tag = 10 车长 tap = 20
    self.selectBtn = 10;
    
    self.btnArr = [NSMutableArray arrayWithObjects:self.carTypeBtn,self.carLengthBtn, nil];
}

- (IBAction)clickBtn:(UIButton *)sender {
    
    if (self.selectBtn == sender.tag) {
        sender.selected = !sender.selected;
    }else{
        for (UIButton *btn in self.btnArr) {
            btn.selected = NO;
        }
        sender.selected = YES;
    }
    self.selectBtn = sender.tag;
    
    !self.callBackBlock ? : self.callBackBlock (sender.tag, sender.selected);
}

/**
 设置 button Title
 */
- (void)setButtonTitltWithButtonTitleType:(ButtonTitleType)buttonTitleType{
    if (buttonTitleType == CarMessageTitleType) {
        [self.carTypeBtn setTitle:@"车型" forState:0];
        [self.carLengthBtn setTitle:@"车长" forState:0];
    }else{
        [self.carTypeBtn setTitle:@"始发地" forState:0];
        [self.carLengthBtn setTitle:@"目的地" forState:0];
    }
}

/**
 设置按钮的选中状态
 
 @param isSelect 是否选中 这里是这是所有按钮, 所以在本程序中 只有设置为 NO 的情况
 */
- (void)setButtonSelectType:(BOOL)isSelect{
    for (UIButton *btn in self.btnArr) {
        btn.selected             = NO;
    }
}


@end
