//
//  YFGoodsDetailSectionView.m
//  YFKit
//
//  Created by 王宇 on 2018/7/11.
//  Copyright © 2018年 wy. All rights reserved. 0085E2  0078E1
//

#import "YFGoodsDetailSectionView.h"

@implementation YFGoodsDetailSectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.leftLine, 0.5, 0, NavColor);
    SKViewsBorder(self.rightLine, 0.5, 0, NavColor);
    self.leftBtn.selected = YES;
}
- (IBAction)clickLeftBtn:(UIButton *)sender {
    self.rightLine.hidden = self.leftBtn.selected  = YES;
    self.leftLine.hidden  = self.rightBtn.selected = NO;
    !self.clickDriverLookTypeBlock ? : self.clickDriverLookTypeBlock (sender.tag);
}
- (IBAction)clickRightBtn:(UIButton *)sender {
   self.rightLine.hidden = self.leftBtn.selected  = NO;
   self.leftLine.hidden  = self.rightBtn.selected = YES;
    !self.clickDriverLookTypeBlock ? : self.clickDriverLookTypeBlock (sender.tag);
}

-(void)setOrderType:(NSInteger)orderType{
    if(orderType == 2){
        //已承运
        self.chooseBtn.hidden = NO;
        [self.chooseBtn setTitle:@"    已承运司机" forState:0];
        self.bottomLeftCons.constant = self.bottomRightCons.constant = 16;
    }else if (orderType == 3){
        //未承运
        self.chooseBtn.hidden = NO;
        [self.chooseBtn setTitle:@"    已中标司机" forState:0];
        self.bottomLeftCons.constant = self.bottomRightCons.constant = 16;
    }
}

@end
