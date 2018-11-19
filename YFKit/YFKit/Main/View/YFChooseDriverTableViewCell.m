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
    SKViewsBorder(self.PlaceOrderBtn, 3, 0, NavColor);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self.imgView addGestureRecognizer:tap];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        !self.callBackImgBlock ? : self.callBackImgBlock();
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFDriverListModel *)model{
    self.name.text = [NSString stringWithFormat:@"%@    交易次数  %@次",model.driverName,model.transactionCount];
    self.LicenseNum.text = [NSString stringWithFormat:@"车牌号码 : ",model.carLawId];
}

@end
