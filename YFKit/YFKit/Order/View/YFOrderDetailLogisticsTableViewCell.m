//
//  YFOrderDetailLogisticsTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderDetailLogisticsTableViewCell.h"

@implementation YFOrderDetailLogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.imgView, 10, 0, NavColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIndex:(NSInteger)index{
    self.topLine.hidden         = index == 1;
    self.bottomLine.hidden      = index == 4;
    self.bottomCons.constant    = index == 1 ? -2 : -6;
    self.imgView.image          = index == 1 ? [UIImage imageNamed:@"bluePoint"] : [UIImage imageNamed:@"AshPoint"];
    self.time.textColor = self.address.textColor = index == 1 ? UIColorFromRGB(0x02A8F5) : UIColorFromRGB(0x555658);
}

@end
