//
//  YFSpecialLineSectionView.m
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineSectionView.h"

@implementation YFSpecialLineSectionView

- (IBAction)clickShowBtn:(UIButton *)sender {

    !self.showCarMsgBlock ? : self.showCarMsgBlock();
}

-(void)setIndex:(NSInteger)index{
    self.title.text                        = index == 1 ? @"货品" : @"其他费用";
    self.showBtn.hidden                    = index == 1 ? YES : NO;
    self.topLine.hidden                    = self.bottomLine.hidden = index == 1 ? YES : NO;
}

@end
