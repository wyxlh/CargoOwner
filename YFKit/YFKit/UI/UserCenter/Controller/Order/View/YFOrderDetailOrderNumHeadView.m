//
//  YFOrderDetailOrderNumHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderDetailOrderNumHeadView.h"
#import "YFOrderDetailModel.h"
#import "YFSpecialLineListModel.h"

@implementation YFOrderDetailOrderNumHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.orderNum.adjustsFontSizeToFitWidth = YES;
}

-(void)setModel:(YFOrderDetailModel *)model{
    self.orderNum.text = [NSString stringWithFormat:@"订单号 : %@",model.taskId];
    self.time.text = [NSString getNullOrNoNull:model.creatorTime];
}

- (void)setSModel:(YFSpecialLineListModel *)sModel{
    self.orderNum.text = [NSString stringWithFormat:@"专线单号 : %@",sModel. shipId];
    NSArray *yearArr                = [sModel.shipDateStr componentsSeparatedByString:@" "];
    NSArray *hourArr                = [[yearArr lastObject] componentsSeparatedByString:@":"];
    NSString *timeStr               = [NSString stringWithFormat:@"%@ %@:%@",[yearArr firstObject],[hourArr firstObject], hourArr[1]];
    self.time.text                  = timeStr;
}

@end
