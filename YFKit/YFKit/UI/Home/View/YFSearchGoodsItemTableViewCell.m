//
//  YFSearchGoodsItemTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchGoodsItemTableViewCell.h"
#import "YFSearchDetailModel.h"

@implementation YFSearchGoodsItemTableViewCell

static NSString *const cellId = @"YFSearchGoodsItemTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YFSearchGoodsItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:@"YFSearchGoodsItemTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.goodsName.text = @" ";
}

- (void)setModel:(YFSearchDetailModel *)model {
    self.startAddress.text = model.startingPlace;
    self.endAddress.text = model.destination;
    if ([NSString isBlankString:model.startingPlace] && [NSString isBlankString:model.destination]) {
        self.addressCons.constant = 0;
        self.addressView.hidden = YES;
    }
    NSMutableArray *goodsMsgList = [NSMutableArray new];
    if (model.goodInfo.count == 1) {
        goodInfoModel *dmodel = [model.goodInfo firstObject];
        self.goodsName.text = [NSString getGoodsName:dmodel.goodName GoodsWeight:dmodel.goodWeight GoodsVolume:dmodel.volumeWeight GoodsNum:dmodel.number];
    }else{
        for (goodInfoModel *dmodel in model.goodInfo) {
            NSString *goodMsg = [NSString getGoodsName:dmodel.goodName GoodsWeight:dmodel.goodWeight GoodsVolume:dmodel.volumeWeight GoodsNum:dmodel.number];
            [goodsMsgList addObject:goodMsg];
        }
        NSString *goodsMsg = [goodsMsgList componentsJoinedByString:@"\n"];
        self.goodsName.text = goodsMsg;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
