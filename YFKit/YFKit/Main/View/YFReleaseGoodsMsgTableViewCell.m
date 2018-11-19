//
//  YFReleaseGoodsMsgTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseGoodsMsgTableViewCell.h"

@implementation YFReleaseGoodsMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.otherDes.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
