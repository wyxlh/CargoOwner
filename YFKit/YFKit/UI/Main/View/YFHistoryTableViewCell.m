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
     self.startAddress.text      = [NSString getCityName:model.startSite];
     self.endAddress.text        = [NSString getCityName:model.endSite];
     self.GoodsStatus.text       = model.historyStatus;
     self.carMsg.text            = [NSString stringWithFormat:@"%@ %@",[NSString getNullOrNoNull:model.vehicleCarLength],[NSString getNullOrNoNull:model.vehicleCarType]];
     self.goodsVolume.text       = [NSString getGoodsName:model.goodsName GoodsWeight:model.goodsTotalWeight GoodsVolume:model.goodsTotalVolume GoodsNum:model.goodsTotalNumber];
 }


@end
