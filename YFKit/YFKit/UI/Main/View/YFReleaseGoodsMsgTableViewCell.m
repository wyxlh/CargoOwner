//
//  YFReleaseGoodsMsgTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseGoodsMsgTableViewCell.h"
#import "YFHomeDataModel.h"
@implementation YFReleaseGoodsMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.otherDes.adjustsFontSizeToFitWidth = YES;
    @weakify(self)
    [[self.leftTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if ([string doubleValue] > 10000) {
            self.leftTF.text = @"9999";
        }
        DLog(@"%@",string);
    }];
    
    [[self.centerTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if ([string doubleValue] > 10000) {
            self.centerTF.text = @"9999";
        }
        DLog(@"%@",string);
    }];
    
    [[self.rightTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if ([string integerValue] >= 100000) {
            self.rightTF.text = @"99999";
        }
        DLog(@"%@",string);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFHomeDataModel *)model{
    self.logo.image      = [UIImage imageNamed:model.imgName];
    self.title.text      = model.title;
    if (!model.isCheck) {
        self.leftTF.text = self.centerTF.text = self.rightTF.text = @"";
    }
}

@end
