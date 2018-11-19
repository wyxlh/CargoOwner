//
//  YFHistoryListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseListTableViewCell.h"
#import "YFReleseListModel.h"
@implementation YFReleaseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.amount, 3, 0.5, UIColorFromRGB(0xFD6800));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(YFReleseListModel *)model{
    self.orderNum.text          = [NSString stringWithFormat:@"货源单号 : %@",model.supplyGoodsId];
    self.time.text              = model.createTime;
    self.startAddress.text      = model.startSite;
    self.endAddress.text        = model.endSite;
    self.carMsg.text            = [NSString stringWithFormat:@"%@ %@",model.vehicleCarLength,model.vehicleCarType];
    self.goodsVolume.text       = [NSString stringWithFormat:@"%@ %@吨 %@方 %@件",model.goodsName, model.goodsTotalWeight,model.goodsTotalVolume,model.goodsTotalNumber];
    self.Etime.text             = [NSString stringWithFormat:@"装车时间 %@",model.pickGoodsDate];
}

@end
