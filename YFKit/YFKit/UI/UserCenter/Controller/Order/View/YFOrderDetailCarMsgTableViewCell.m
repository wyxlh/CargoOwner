//
//  YFOrderDetailCarMsgTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderDetailCarMsgTableViewCell.h"
#import "YFOrderDetailModel.h"
@implementation YFOrderDetailCarMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFOrderDetailModel *)model{
    self.carType.text       = [NSString stringWithFormat:@"车型车长 : %@ %@",[NSString getNullOrNoNull:model.carSize],[NSString getNullOrNoNull:model.carType]];
    
    self.time.text          = [NSString stringWithFormat:@"装货时间: %@",[NSString getGoodsDetailTime:model.pickGoodsDate WithStartTime:model.pickGoodsDateStart WithEndTime:model.pickGoodsDateEnd]];
    
    if (model.goodsItem.count > 0) {
        NSString *goodMes   = [NSString getGoodsName:[model.goodsItem[0] goodsName] GoodsWeight:[model.goodsItem[0] goodsWeight] GoodsVolume:[model.goodsItem[0] goodsVolume] GoodsNum:[model.goodsItem[0] goodsNumber]];
        self.goodsMsg.text  = [NSString stringWithFormat:@"货品信息 : %@",goodMes];
        self.mark.text      = [NSString stringWithFormat:@" %@%@",[NSString getNullOrNoNull:model.unloadWay],[NSString getNullOrNoNull:model.remark]];
    }else{
        self.goodsMsg.text  = @"货品信息 : ";
        self.mark.text      = @"其他要求 : ";
    }
    
    
    self.free.text          = [NSString stringWithFormat:@"运费 : %@元",model.taskFee];
    
    self.driver.text        = [NSString stringWithFormat:@"指定司机 : %@",[NSString getNullOrNoNull:model.driverName]];
    
    
}

@end
