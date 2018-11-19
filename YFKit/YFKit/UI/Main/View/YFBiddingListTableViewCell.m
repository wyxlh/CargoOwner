//
//  YFBiddingListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBiddingListTableViewCell.h"
#import "YFBiddingListModel.h"
@implementation YFBiddingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.time.adjustsFontSizeToFitWidth = YES;
    SKViewsBorder(self.saveBtn, 2, 0, NavColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PriceListModel *)model{
    _model           = model;
    if (!model.isCanOffer) {
        self.saveBtn.backgroundColor = UIColorFromRGB(0x98999A);
        self.saveBtn.userInteractionEnabled = NO;
    }else{
        self.saveBtn.backgroundColor = UIColorFromRGB(0x0078E5);
        self.saveBtn.userInteractionEnabled = YES;
    }
    self.name.text   = [NSString stringWithFormat:@"%@    交易次数  %@次",[NSString getNullOrNoNull:model.carrierName],model.transactionCount];
    self.time.text   = [NSString stringWithFormat:@"报价时间 : %@",[NSString getNullOrNoNull:model.quoteTime]];
    
    self.money.text  = [NSString stringWithFormat:@"报价金额 : %@元",[NSString getNullOrNoNull:model.quotePrice]];
    
}


@end
