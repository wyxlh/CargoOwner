//
//  YFPlaceOrderItemTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPlaceOrderItemTableViewCell.h"
#import "YFHomeDataModel.h"
@implementation YFPlaceOrderItemTableViewCell

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
    self.title.text                      = model.title;
    self.logo.image                      = [UIImage imageNamed:model.imgName];
    self.detailAddress.text              = model.placeholder;
    
}

@end
