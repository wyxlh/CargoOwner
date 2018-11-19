//
//  YFFindCarCollectionReusableView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/25.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCarCollectionReusableView.h"

@implementation YFFindCarCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSection:(NSInteger)section{
    self.title.text = self.isStart ? [NSArray ChooseCarTypeHeadArray][section] : [NSArray ChooseCarLengthHeadArray][section];
    if (self.isStart) {
        self.topCons.constant = section == 1 ? CGFLOAT_MIN : 5.0f;
        self.emptyBtn.hidden = section != 2;
        [self.emptyBtn setTitle:@"返回上一级" forState:0];
    }else{
        self.topCons.constant = section == 0 ? CGFLOAT_MIN : 5.0f;
        self.emptyBtn.hidden  = section == 1;
        [self.emptyBtn setTitle:section == 0 ? @"清空" : @"返回上一级" forState:0];
    }

}

@end
