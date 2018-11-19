//
//  YFSpecialDetailGoodsTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialDetailGoodsTableViewCell.h"
#import "YFSpecialLineListModel.h"

@implementation YFSpecialDetailGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.numLbl, 7, 1, OrangeBtnColor);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YFSpecialGoodsModel *)model{
    self.goodsMsg.text      = [NSString getMsgWithGoodsName:model.goodsName GoodsWeight:model.goodsWeight GoodsVolume:model.goodsVolume GoodsNum:model.goodsNumber];
    self.feeLbl.text        = [NSString stringWithFormat:@"运费：%.2f元",model.shipAmount];
}

@end
