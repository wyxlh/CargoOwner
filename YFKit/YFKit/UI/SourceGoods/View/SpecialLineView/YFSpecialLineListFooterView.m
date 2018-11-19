//
//  YFSpecialLineListFooterView.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineListFooterView.h"

@implementation YFSpecialLineListFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.rightBtn, 1, 0, NavColor);
}

/**
 zzf 已取消   yhz 未承运  zkd 已开单  其余都为  已承运
 */
- (void)setShipStatue:(NSString *)shipStatue{
    if ([shipStatue isEqualToString:@"zkd"]) {
        //已开单
        [self.rightBtn setTitle:@"取消" forState:0];
        self.rightBtn.backgroundColor = OrangeBtnColor;
    }else if ([shipStatue isEqualToString:@"wcy"]){
        //未承运
    }else if ([shipStatue isEqualToString:@"ycy"]){
        //已承运
    }else if ([shipStatue isEqualToString:@"zzf"]){
        //已取消
        [self.rightBtn setTitle:@"再来一单" forState:0];
        self.rightBtn.backgroundColor = BlueBtnColor;
    }
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.clickRightBtnBlock ? : self.clickRightBtnBlock(sender.titleLabel.text);
    
}

@end
