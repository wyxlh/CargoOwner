//
//  YFGoodsSourceTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsSourceTableViewCell.h"
#import "YFReleseDetailModel.h"
@implementation YFGoodsSourceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.orderNum.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFReleseDetailModel *)model{
    self.orderNum.text          = [NSString stringWithFormat:@"货源单号: %@",[model.goodsItem[0] supplyGoodsId]];
    self.time.text              = model.pickGoodsDate;
    self.startAddress.text      = model.startSite;
    self.endAddress.text        = model.endSite;
    self.startDetail.text       = model.startAddress;
    self.endDetail.text         = model.endAddress;
    self.carMsg.text            = [NSString stringWithFormat:@"车型车长: %@ %@",model.vehicleCarLength,model.vehicleCarType];
    self.Etime.text             = [NSString stringWithFormat:@"装货日期: %@",model.pickGoodsDate];
    self.goodsVolume.text       = [NSString stringWithFormat:@"货品信息: %@ %@吨 %@方 %@件",[model.goodsItem[0] goodsName], [model.goodsItem[0] goodsWeight],[model.goodsItem[0] goodsVolume],[model.goodsItem[0] goodsCount]];
    
    if ([NSString isBlankString:model.quotedPrice]) {
        self.wantFree.text          = @"期望运费: 0元";
    }else{
        self.wantFree.text          = [NSString stringWithFormat:@"期望运费: %@元",model.quotedPrice];
    }
    
    if ([NSString isBlankString:model.driverName]) {
        self.driver.text          = @"指定司机: ";
    }else{
        self.driver.text        = [NSString stringWithFormat:@"指定司机: %@",model.driverName];
    }
    
    if ([NSString isBlankString:model.remark]) {
        self.more.text          = @"其他要求: 无";
    }else{
        self.more.text          = [NSString stringWithFormat:@"其他要求: %@",model.remark];
    }
     
}

@end
