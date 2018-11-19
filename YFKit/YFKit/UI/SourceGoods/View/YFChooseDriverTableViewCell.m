//
//  YFChooseDriverTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFChooseDriverTableViewCell.h"
#import "YFDriverListModel.h"
@implementation YFChooseDriverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.PlaceOrderBtn, 1, 0, NavColor);
    SKViewsBorder(self.onLine, 2, 0, NavColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFDriverListModel *)model{
    self.name.text                  = [NSString getNullOrNoNull:model.driverName];
    self.count.text                 = [NSString stringWithFormat:@"交易次数   %@次",model.transactionCount];
    self.address.text               = [NSString isBlankString:model.locAddr] ? @"地址:暂无" : model.locAddr;
    self.onLine.backgroundColor     = model.onLine ? NavColor : UIColorFromRGB(0x999999);
    self.onLine.text                = model.onLine ? @"在线" : @"离线";
    self.LicenseNum.text            = [NSString isBlankString:model.carLawId] ? @"车牌:暂无" : [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:model.carLawId],[NSString getCarMessageWithFirst:model.containerType AndSecond:model.carSize]];

    
}

@end
