//
//  YFHistoryListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseListTableViewCell.h"
#import "YFReleseListModel.h"
#import "YFOrderListModel.h"
@implementation YFReleaseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.time.font = ScreenWidth == 320.0f ? [UIFont systemFontOfSize:12] : [UIFont systemFontOfSize:14];
    SKViewsBorder(self.amount, 3, 0.5, UIColorFromRGB(0xFD6800));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(YFReleseListModel *)model{
    self.orderNum.text          = [NSString stringWithFormat:@"货源单号 : %@",model.supplyGoodsId];
    
    
    NSArray *yearArr            = [model.publishedTime componentsSeparatedByString:@" "];
    
    NSArray *hourArr            = [[yearArr lastObject] componentsSeparatedByString:@":"];
    NSString *timeStr           = [NSString stringWithFormat:@"%@ %@:%@",[yearArr firstObject],[hourArr firstObject], hourArr[1]];
    self.time.text              =timeStr;
    
    self.startAddress.text      = [NSString getCityName:model.startSite];
    self.endAddress.text        = [NSString getCityName:model.endSite];
    self.carMsg.text            = [NSString stringWithFormat:@"%@ %@",[NSString getNullOrNoNull:model.vehicleCarLength],[NSString getNullOrNoNull:model.vehicleCarType]];
    self.goodsVolume.text       = [NSString getGoodsName:model.goodsName GoodsWeight:model.goodsTotalWeight GoodsVolume:model.goodsTotalVolume GoodsNum:model.goodsTotalNumber];
    self.Etime.text             = [NSString stringWithFormat:@"装车时间: %@",[NSString getGoodsDetailTime:model.pickGoodsDate WithStartTime:model.pickGoodsDateStart WithEndTime:model.pickGoodsDateEnd]];
    
}


-(void)setOmodel:(YFOrderListModel *)Omodel{
    self.topImgView.image       = [UIImage imageNamed:@"cardGoods"];
    self.centerImgView.image    = [UIImage imageNamed:@"Originating"];
    self.bottomImgView.image    = [UIImage imageNamed:@"End"];
    self.orderState.hidden      = NO;
    self.orderNum.text          = [NSString stringWithFormat:@"订单号 : %@",Omodel.taskId];
    self.time.text              = [NSString getNullOrNoNull:Omodel.creatorTime];
    self.startAddress.text      = [NSString getCityName:Omodel.startSite];
    self.endAddress.text        = [NSString getCityName:Omodel.endSite];
    self.carMsg.text       = [NSString getGoodsName:Omodel.goodsName GoodsWeight:Omodel.goodsTotalWeight GoodsVolume:Omodel.goodsTotalVolume GoodsNum:Omodel.goodsTotalNumber];
    self.goodsVolume.text       = [NSString getNullOrNoNull:Omodel.startAddress];
    self.Etime.text             = [NSString getNullOrNoNull:Omodel.endAddress];
    
    if (self.type == 1) {
        if (Omodel.taskStatus == 0) {
            self.orderState.text    = @"待接单";
        }else if (Omodel.taskStatus == 1){
            self.orderState.text    = @"待发运";
        }else if (Omodel.taskStatus == 2){
            self.orderState.text    = @"待到达";
        }else if (Omodel.taskStatus == 3){
            self.orderState.text    = @"待签收";
        }else{
            self.orderState.text    = @"待确认";
        }
    }else{
        DLog(@"%ld-------%ld",Omodel.confirmStatus,Omodel.taskFlag);
        if (Omodel.confirmStatus == 0 && Omodel.taskFlag != 1) {
             self.orderState.text   = @"";
        }else if (Omodel.confirmStatus == 1 && Omodel.taskFlag == 1){
            self.orderState.text    = @"";
        }else{
            self.orderState.text    = @"";
        }
    }
    
    
}

@end
