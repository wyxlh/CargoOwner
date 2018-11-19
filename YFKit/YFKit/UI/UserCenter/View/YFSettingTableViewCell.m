//
//  YFSettingTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSettingTableViewCell.h"

@implementation YFSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
