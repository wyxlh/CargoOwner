//
//  YFQueryResultTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFQueryResultTableViewCell.h"
@implementation YFQueryResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.HandleBtn, 2, 0, NavColor);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
