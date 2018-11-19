//
//  YFSpecialDetailOtherFeeTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialDetailOtherFeeTableViewCell.h"
#import "YFSpecialLineListModel.h"

@implementation YFSpecialDetailOtherFeeTableViewCell

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
    self.protectionFee.text           = [NSString stringWithFormat:@"保价费：%.2f元",model.baoJiaFee];
    self.valueFee.text                = [NSString stringWithFormat:@"（声明价值：%.2f元）",model.declareValue];
    self.proceduresFee.text           = [NSString stringWithFormat:@"手续费：%.2f元",model.shouXuFee];
    self.generationFee.text           = [NSString stringWithFormat:@"（代收货款：%.2f元）",model.daiShouHuoKuanFee];
    self.informationFee.text          = [NSString stringWithFormat:@"信息费：%.2f元",model.xinXiFee];
    self.deliveryFree.text            = [NSString stringWithFormat:@"送货费：%.2f元",model.songHuoFee];
    self.takeFee.text                 = [NSString stringWithFormat:@"提货费：%.2f元",model.tiHuoFee];
    self.returnFee.text               = [NSString stringWithFormat:@"装卸费：%.2f元",model.huiDanFee];
}

@end
