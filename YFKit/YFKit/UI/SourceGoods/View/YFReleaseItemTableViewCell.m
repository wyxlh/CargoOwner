//
//  YFReleaseItemTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.飒飒
//

#import "YFReleaseItemTableViewCell.h"
#import "YFHomeDataModel.h"
@implementation YFReleaseItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFHomeDataModel *)model{
    self.title.text                      = model.title;
    self.logo.image                      = [UIImage imageNamed:model.imgName];
    if (model.isCheck) {
        self.placeholder.text            = model.placeholder;
    }else{
        self.placeholder.text            = @"";
        self.placeholder.placeholder     = model.placeholder;
    }
    
}

@end
