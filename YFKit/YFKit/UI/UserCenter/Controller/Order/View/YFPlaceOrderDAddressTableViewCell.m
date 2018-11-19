//
//  YFPlaceOrderDAddressTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPlaceOrderDAddressTableViewCell.h"
#import "YFHomeDataModel.h"
@implementation YFPlaceOrderDAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
    [[self.addressTF rac_textSignal] subscribeNext:^(id x) {
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if (string.length > 30) {
            self.addressTF.text = [string substringWithRange:NSMakeRange(0, 30)];
        }
        DLog(@"%@",string);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFHomeDataModel *)model{
    self.title.text                      = model.title;
    if (!model.isCheck && [model.placeholder isEqualToString:@"点击输入"]) {
        self.addressTF.text              = @"";
    }else if (model.isCheck && ![NSString isBlankString:model.placeholder]){
        self.addressTF.text              = model.placeholder;
    }
    
}

@end
