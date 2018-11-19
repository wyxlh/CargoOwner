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
    self.name.text = [NSString stringWithFormat:@"%@    交易次数  %@次",model.carrierName,model.transactionCount];
    self.time.text = [NSString stringWithFormat:@"报价时间 : %@",model.quoteTime];
    self.money.text = [NSString stringWithFormat:@"报价金额 : %@元",model.quotePrice];

}

@end
