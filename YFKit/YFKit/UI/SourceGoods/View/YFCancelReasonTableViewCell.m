//
//  YFCancelReasonTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFCancelReasonTableViewCell.h"
#import "YFCarTypeModel.h"

@implementation YFCancelReasonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YFCarTypeModel *)model{
    self.reasonLbl.text = model.name;
    self.selectImg.image = [UIImage imageNamed:model.isSelect ? @"setDefault" : @"cancenDefault"];
}

@end
