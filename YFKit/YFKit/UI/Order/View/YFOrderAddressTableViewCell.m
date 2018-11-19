//
//  YFOrderAddressTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOrderAddressTableViewCell.h"
#import "YFOrderDetailModel.h"
@implementation YFOrderAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFOrderDetailModel *)model{
    self.startAddress.text          = [NSString getCityName:model.startSite];
    self.endAddress.text            = [NSString getCityName:model.endSite];
    self.Sdetail.text               = [NSString getNullOrNoNull:model.startAddress];
    self.Edetail.text               = [NSString getNullOrNoNull:model.endAddress];
}

@end
