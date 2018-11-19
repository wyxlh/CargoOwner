//
//  YFChooseAddressListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFChooseAddressListTableViewCell.h"
#import "YFAddressModel.h"

@implementation YFChooseAddressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//收货人地址
-(void)setModel:(YFAddressModel *)model{
    if ([NSString isBlankString:model.receiverAddr]) {
        self.name.alpha         = self.address.alpha = self.phone.alpha = self.selectBtn.alpha = 0.4;
    }else{
        self.name.alpha         = self.address.alpha = self.phone.alpha = self.selectBtn.alpha = 1;
    }
    self.name.text              = model.receiverContacts;
    if (model.isDefault) {
        [AttributedLbl setRichTextOnlyColor:self.address titleString:[NSString stringWithFormat:@"默认地址: %@%@",model.receiverCity,[NSString getNullOrNoNull:model.receiverAddr]] textColor:OrangeBtnColor colorRang:NSMakeRange(0, 5)];
    }else{
        self.address.text       = [NSString stringWithFormat:@"%@%@",model.receiverCity,[NSString getNullOrNoNull:model.receiverAddr]];
    }
    self.phone.text             = model.receiverMobile;
    self.selectBtn.selected     = model.isSelect;
    
}

//发货人地址
-(void)setCmodel:(YFConsignerModel *)Cmodel{
    if ([NSString isBlankString:Cmodel.consignerAddr] && self.chooseAddressType == 0) {
        self.name.alpha         = self.address.alpha = self.phone.alpha = self.selectBtn.alpha = 0.4;
    }else{
        self.name.alpha         = self.address.alpha = self.phone.alpha = self.selectBtn.alpha = 1;
    }
    self.name.text              = [NSString getNullOrNoNull:Cmodel.consignerContacts];
    if (Cmodel.isDefault) {
        [AttributedLbl setRichTextOnlyColor:self.address titleString:[NSString stringWithFormat:@"默认地址: %@%@",Cmodel.consignerCity,[NSString getNullOrNoNull:Cmodel.consignerAddr]] textColor:OrangeBtnColor colorRang:NSMakeRange(0, 5)];
    }else{
        self.address.text           = [NSString stringWithFormat:@"%@%@",Cmodel.consignerCity,[NSString getNullOrNoNull:Cmodel.consignerAddr]];
    }
    self.phone.text             = [NSString getNullOrNoNull:Cmodel.consignerMobile];
    self.selectBtn.selected     = Cmodel.isSelect;
}

@end
