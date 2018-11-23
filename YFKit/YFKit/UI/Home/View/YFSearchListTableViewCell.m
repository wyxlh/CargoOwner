//
//  YFSearchListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchListTableViewCell.h"

@implementation YFSearchListTableViewCell

static NSString *const cellID = @"YFSearchListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YFSearchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    
    return cell;
}

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
