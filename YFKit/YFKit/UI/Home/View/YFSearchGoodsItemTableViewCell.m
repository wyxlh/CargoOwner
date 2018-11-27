//
//  YFSearchGoodsItemTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchGoodsItemTableViewCell.h"

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
    self.goodsName.text = @"哈哈啊哈哈哈\n哈哈哈哈哈哈多或多\n附属设施";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
