//
//  YFSpecialDetailPaymentTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialDetailPaymentTableViewCell.h"
#import "YFSpecialLineListModel.h"

@implementation YFSpecialDetailPaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YFSpecialLineListModel *)model{
    _model                          = model;
    self.payment.text               = [self goodsPayment];
    NSArray *remakrArr              = [model.remark componentsSeparatedByString:@";"];
    if ([NSString isBlankString:[remakrArr firstObject]] && [NSString isBlankString:[remakrArr lastObject]]) {
        self.otherPlan.text         = @"暂无";
    }else if (![NSString isBlankString:[remakrArr firstObject]] && ![NSString isBlankString:[remakrArr lastObject]]){
        self.otherPlan.text         = [NSString stringWithFormat:@"%@,%@",[remakrArr firstObject],[remakrArr lastObject]];
    }else{
        self.otherPlan.text         = [NSString stringWithFormat:@"%@%@",[remakrArr firstObject],[remakrArr lastObject]];
    }
}

- (NSString *)goodsPayment{
    NSString *daofuFee,*huifu;
    if (![NSString isBlankString:self.model.daofuFee]) {
        daofuFee                    = [NSString stringWithFormat:@"/到付%.2f",[self.model.daofuFee doubleValue]];
    }
    if (![NSString isBlankString:self.model.huifuFee]) {
        huifu                       = [NSString stringWithFormat:@"/回付%.2f",[self.model.huifuFee doubleValue]];
    }
    return [NSString stringWithFormat:@"付款方式：现付%.2f%@%@",[self.model.xianfuFee doubleValue],[NSString getNullOrNoNull:daofuFee],[NSString getNullOrNoNull:huifu]];
}


@end
