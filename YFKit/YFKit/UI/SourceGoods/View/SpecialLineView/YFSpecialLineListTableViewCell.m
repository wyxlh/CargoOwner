//
//  YFSpecialLineListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineListTableViewCell.h"
#import "YFSpecialLineListModel.h"

@implementation YFSpecialLineListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.time.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YFSpecialLineListModel *)model{
    self.orderNum.text              = [NSString stringWithFormat:@"专线单号: %@",model.shipId];
    NSArray *yearArr                = [model.shipDateStr componentsSeparatedByString:@" "];
    NSArray *hourArr                = [[yearArr lastObject] componentsSeparatedByString:@":"];
    NSString *timeStr               = [NSString stringWithFormat:@"%@ %@:%@",[yearArr firstObject],[hourArr firstObject], hourArr[1]];
    self.time.text                  = timeStr;
    self.startAddress.text          = [NSString getCityName:model.sendSite];
    self.endAddress.text            = [NSString getCityName:model.recvSite];
    if (model.goodsModel.count == 1) {
       self.goodsMsg.text           = [NSString getMsgWithGoodsName:[model.goodsModel[0] goodsName] GoodsWeight:[model.goodsModel[0] goodsWeight] GoodsVolume:[model.goodsModel[0] goodsVolume] GoodsNum:[model.goodsModel[0] goodsNumber]];
    }else{
        self.goodsMsg.text          = [NSString stringWithFormat:@"%@（多种货品）",[NSString getMsgWithGoodsName:[model.goodsModel[0] goodsName] GoodsWeight:[model.goodsModel[0] goodsWeight] GoodsVolume:[model.goodsModel[0] goodsVolume] GoodsNum:[model.goodsModel[0] goodsNumber]]];
    }
    if (![model.remark containsString:@";"]) {
        model.remark                = [NSString stringWithFormat:@"%@;",model.remark];
    }
    NSArray *remakrArr              = [model.remark componentsSeparatedByString:@";"];
    if ([NSString isBlankString:[remakrArr firstObject]] && [NSString isBlankString:[remakrArr lastObject]]) {
        self.remake.text            = @"其他要求：暂无";
    }else if (![NSString isBlankString:[remakrArr firstObject]] && ![NSString isBlankString:[remakrArr lastObject]]){
        self.remake.text            = [NSString stringWithFormat:@"其他要求：%@,%@",[remakrArr firstObject],[remakrArr lastObject]];
    }else{
        self.remake.text            = [NSString stringWithFormat:@"其他要求：%@ %@",[remakrArr firstObject],[remakrArr lastObject]];
    }
}

@end
