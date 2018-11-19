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
    
    
    self.time.text                  = [NSString getNullOrNoNull:model.publishedTime];
    self.startAddress.text          = [NSString getCityName:model.startSite];
    self.endAddress.text            = [NSString getCityName:model.endSite];
    if (![NSString isBlankString:model.startAddress]) {
        self.startDetail.text       = [NSString getNullOrNoNull:model.startAddress];
    }else{
        self.startDetail.text       = [NSString getNullOrNoNull:model.startSite];
    }
    
    if (![NSString isBlankString:model.endAddress]) {
        self.endDetail.text         = [NSString getNullOrNoNull:model.endAddress];
    }else{
        self.endDetail.text         = [NSString getNullOrNoNull:model.endSite];
    }
    
    
    self.carMsg.text                = [NSString stringWithFormat:@"车型车长 : %@ %@",[NSString getNullOrNoNull:model.vehicleCarLength],[NSString getNullOrNoNull:model.vehicleCarType]];
    
    self.Etime.text                 = [NSString stringWithFormat:@"装货时间: %@",[NSString getGoodsDetailTime:model.pickGoodsDate WithStartTime:model.pickGoodsDateStart WithEndTime:model.pickGoodsDateEnd]];
    if (model.goodsItem.count > 0) {
        self.orderNum.text          = [NSString stringWithFormat:@"货源号: %@",[model.goodsItem[0] supplyGoodsId]];
        NSString *goodsMsg          = [NSString getGoodsName:[model.goodsItem[0] goodsName] GoodsWeight:[model.goodsItem[0] goodsWeight] GoodsVolume:[model.goodsItem[0] goodsVolume] GoodsNum:[model.goodsItem[0] goodsCount]];
        self.goodVolume.text        = [NSString stringWithFormat:@"货品信息: %@",goodsMsg];
        
    }else{
        self.orderNum.text          = @"货源号: ";
        self.goodVolume.text        = @"货品信息: ";
    }
    
    
    
    
    if ([NSString isBlankString:model.expectPrice]) {
        self.wantFree.text          = @"期望运费: 0元";
    }else{
        self.wantFree.text          = [NSString stringWithFormat:@"期望运费: %@元",model.expectPrice];
    }
    
    if ([NSString isBlankString:model.driverName]) {
        self.driver.text            = @"指定司机: ";
    }else{
        self.driver.text            = [NSString stringWithFormat:@"指定司机: %@",model.driverName];
    }
    
    self.more.text                  = [NSString stringWithFormat:@"%@ %@",[NSString getNullOrNoNull:model.unloadWay],[NSString getNullOrNoNull:model.remark]];
     
}

@end
