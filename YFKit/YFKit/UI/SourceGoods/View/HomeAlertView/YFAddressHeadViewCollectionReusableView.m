//
//  YFAddressHeadViewCollectionReusableView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAddressHeadViewCollectionReusableView.h"

@implementation YFAddressHeadViewCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    SKViewsBorder(self.bgView, 0, 0.5, UIColorFromRGB(0xDFDFDF));
}
- (IBAction)clickBtn:(UIButton *)sender {
    for (UIButton *btn in self.btnArr) {
        btn.selected                = NO;
        btn.backgroundColor         = [UIColor whiteColor];
    }
    sender.selected                 = YES;
    sender.backgroundColor          = UIColorFromRGB(0x0079E7);
    !self.clickcChooseAddressBlock ? : self.clickcChooseAddressBlock(sender.tag);
}

/**
 改变 button 的选中状态
 
 @param tag  tag
 */
-(void)updataBtnBackgroundColorWithTag:(NSInteger)tag{
    for (UIButton *btn in self.btnArr) {
        btn.selected                = NO;
        btn.backgroundColor         = [UIColor whiteColor];
    }
    UIButton *selectBtn             = self.btnArr[tag];
    selectBtn.selected              = YES;
    selectBtn.backgroundColor       = UIColorFromRGB(0x0079E7);
}

@end
