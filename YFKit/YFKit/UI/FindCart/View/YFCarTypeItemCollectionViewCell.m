//
//  YFCarTypeItemCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/26.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFCarTypeItemCollectionViewCell.h"
#import "YFCarTypeModel.h"
@implementation YFCarTypeItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    SKViewsBorder(self.title, 1, 0.5, UIColorFromRGB(0xDFDFDF));
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        !self.deleteSelectItemBlock ? : self.deleteSelectItemBlock();
    }];
    [self.deleteImg addGestureRecognizer:tap];
}

-(void)setModel:(YFCarTypeModel *)model{
    self.title.text = model.name;
}

-(void)setAddressModel:(YFChooseAddressModel *)addressModel{
    self.title.text = addressModel.address;
    //    if (addressModel.isSelect) {
    //        SKViewsBorder(self.title, 1, 0.8, UIColorFromRGB(0x0073E7));
    //        self.title.textColor = UIColorFromRGB(0x0079E7);
    //    }else{
    SKViewsBorder(self.title, 1, 0.5, UIColorFromRGB(0xDFDFDF));
    self.title.textColor = UIColorFromRGB(0x5B5B5B);
    //    }
}

@end
