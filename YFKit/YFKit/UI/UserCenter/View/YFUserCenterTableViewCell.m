//
//  YFUserCenterTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserCenterTableViewCell.h"

@implementation YFUserCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSDictionary *)dict{
    self.title.text = [dict safeJsonObjForKey:@"name"];
    self.imgView.image = [UIImage imageNamed:[dict safeJsonObjForKey:@"imgName"]];
}

@end
