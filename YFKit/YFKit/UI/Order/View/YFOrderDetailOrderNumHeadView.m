//
//  YFOrderDetailOrderNumHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderDetailOrderNumHeadView.h"
#import "YFOrderDetailModel.h"
@implementation YFOrderDetailOrderNumHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.orderNum.adjustsFontSizeToFitWidth = YES;
}

-(void)setModel:(YFOrderDetailModel *)model{
    self.orderNum.text = [NSString stringWithFormat:@"订单号 : %@",model.taskId];
    self.time.text = [NSString getNullOrNoNull:model.creatorTime];
}

@end
