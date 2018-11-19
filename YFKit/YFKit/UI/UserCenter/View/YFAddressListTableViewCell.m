//
//  YFAddressListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAddressListTableViewCell.h"
#import "YFAddressModel.h"
@implementation YFAddressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFAddressModel *)model{
    self.name.text    = model.receiverContacts;
    self.address.text = [NSString stringWithFormat:@"%@%@",model.receiverCity,[NSString getNullOrNoNull:model.receiverAddr]];
    self.phone.text   = model.receiverMobile;
    
}


-(void)setCmodel:(YFConsignerModel *)Cmodel{
    self.name.text    = [NSString getNullOrNoNull:Cmodel.consignerContacts];
    self.address.text = [NSString stringWithFormat:@"%@%@",Cmodel.consignerCity,[NSString getNullOrNoNull:Cmodel.consignerAddr]];
    self.phone.text   = [NSString getNullOrNoNull:Cmodel.consignerMobile];
}
@end
