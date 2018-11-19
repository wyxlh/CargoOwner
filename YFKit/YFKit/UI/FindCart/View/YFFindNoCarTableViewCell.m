//
//  YFFindNoCarTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindNoCarTableViewCell.h"

@implementation YFFindNoCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.addBtn, 3, 0, NavColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickAddCarBtn:(id)sender {
    [YFNotificationCenter postNotificationName:@"addCarKeys" object:nil];
}

@end
