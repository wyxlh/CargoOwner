//
//  YFViolationTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFViolationTableViewCell.h"
#import "YFQueryResultViewController.h"
@implementation YFViolationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.saveBtn, 3, 0, NavColor);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickQueryBtn:(id)sender {
    YFQueryResultViewController *query  = [YFQueryResultViewController new];
    [self.superVC.navigationController pushViewController:query animated:YES];
}
@end
