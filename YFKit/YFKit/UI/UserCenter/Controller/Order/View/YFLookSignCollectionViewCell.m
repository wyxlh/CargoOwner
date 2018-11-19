//
//  YFLookSignCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFLookSignCollectionViewCell.h"
#import "YFLookSignModel.h"
@implementation YFLookSignCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YFLookSignModel *)model{
    self.orderNum.text          = [NSString stringWithFormat:@"订单号 : %@",[NSString getNullOrNoNull:model.taskId]];
    self.signPeople.text        = [NSString stringWithFormat:@"签收人 : %@",[NSString getNullOrNoNull:model.signUser]];
    self.signTime.text          = [NSString stringWithFormat:@"%@",[NSString getNullOrNoNull:model.signTime]];
    self.signType.text          = [NSString stringWithFormat:@"%@",[NSString getNullOrNoNull:model.opStatue]];
}

@end
