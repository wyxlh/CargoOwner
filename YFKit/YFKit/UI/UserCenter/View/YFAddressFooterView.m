//
//  YFAddressFooterView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAddressFooterView.h"

@implementation YFAddressFooterView

+ (instancetype)loadFooterView {
    YFAddressFooterView *footerView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"YFAddressFooterView" owner:nil options:nil] firstObject];
    return footerView;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.leftBtn, 3, 0.5, UIColorFromRGB(0x747474));
    SKViewsBorder(self.rightBtn, 3, 0.5, UIColorFromRGB(0x747474));
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.refreshBlock ? : self.refreshBlock(sender.titleLabel.text);
}



@end
