//
//  YFItemCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFItemCollectionViewCell.h"
#import "YFCarTypeModel.h"
@implementation YFItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setModel:(YFCarTypeModel *)model{
    self.title.text = model.name;
    if (model.isSelect) {
        SKViewsBorder(self.title, 1, 0.8, UIColorFromRGB(0x0079E7));
        self.title.textColor = UIColorFromRGB(0x0079E7);
    }else{
        SKViewsBorder(self.title, 1, 0.5, UIColorFromRGB(0xDFDFDF));
        self.title.textColor = UIColorFromRGB(0x5B5B5B);
    }
}

-(void)setAddressModel:(YFChooseAddressModel *)AddressModel{
    self.title.text = AddressModel.address;
    if (AddressModel.isSelect) {
        SKViewsBorder(self.title, 1, 0.8, UIColorFromRGB(0x0079E7));
         self.title.textColor = UIColorFromRGB(0x0079E7);
    }else{
        SKViewsBorder(self.title, 1, 0.5, UIColorFromRGB(0xDFDFDF));
        self.title.textColor = UIColorFromRGB(0x5B5B5B);
    }
}

@end
