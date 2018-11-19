//
//  YFGoodsHeadTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsHeadTableViewCell.h"
#import "YFHomeDataModel.h"

@implementation YFGoodsHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFHomeDataModel *)model{
    self.title.text = model.title;
    self.logo.image = [UIImage imageNamed:model.imgName];
}


@end
