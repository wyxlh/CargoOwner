//
//  YFSortViewTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSortViewTableViewCell.h"

@implementation YFSortViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.sortUserType != 0) {
        if (selected) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
}




@end
