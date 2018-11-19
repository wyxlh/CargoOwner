//
//  YFHistoryTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHistoryTableViewCell.h"
#import "YFReleseListModel.h"
@implementation YFHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


 -(void)setModel:(YFReleseListModel *)model{
     self.startAddress.text      = model.startSite;
     self.endAddress.text        = model.endSite;
     self.GoodsStatus.text       = model.supplyGoodsStatus;
     self.carMsg.text            = [NSString stringWithFormat:@"%@ %@",model.vehicleCarLength,model.vehicleCarType];
     self.goodsVolume.text       = [NSString stringWithFormat:@"%@ %@吨 %@方 %@件",model.goodsName, model.goodsTotalWeight,model.goodsTotalVolume,model.goodsTotalNumber];
 }


@end
