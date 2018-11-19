//
//  YFUserAgreeTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/25.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserAgreeTableViewCell.h"

@implementation YFUserAgreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
