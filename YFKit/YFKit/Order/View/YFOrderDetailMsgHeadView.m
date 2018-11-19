//
//  YFOrderDetailMsgHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderDetailMsgHeadView.h"

@implementation YFOrderDetailMsgHeadView

- (IBAction)clickShowBtn:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    DLog(@"%ld",sender.selected);
    !self.showCarMsgBlock ? : self.showCarMsgBlock();
}

-(void)setIndex:(NSInteger)index{
    self.title.text                        = index == 1 ? @"详细信息" : @"订单跟踪";
    self.showBtn.hidden                    = index == 1 ? NO : YES;
}

@end
