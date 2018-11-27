//
//  YFSearceDetailTimeTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearceDetailTimeTableViewCell.h"

@implementation YFSearceDetailTimeTableViewCell

static NSString *const cellID = @"YFSearceDetailTimeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YFSearceDetailTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setIndex:(NSInteger)index {
    self.topLine.hidden         = index == 0;
//    self.bottomLine.hidden      = index == 4;
    self.bottomCons.constant    = index == 0 ? -2 : -6;
    self.imgView.image          = index == 0 ? [UIImage imageNamed:@"bluePoint"] : [UIImage imageNamed:@"AshPoint"];
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
