//
//  YFHomePostCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/7/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomePostCollectionViewCell.h"
#import "YFHomeItemView.h"

@implementation YFHomePostCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *titleArr                        = @[@"发布货源",@"指派下单",@"专线下单"];
    NSArray *imgArr                          = @[@"releaseGoods",@"ReleaseSouce",@"SpecialLine"];
    CGFloat scale                            = 750.0f/190.0f;
    CGFloat height                           = ScreenWidth/scale;
    for (int i = 0; i < 3; i ++) {
        YFHomeItemView *itemView             = [[[NSBundle mainBundle] loadNibNamed:@"YFHomeItemView" owner:nil options:nil] lastObject];
        itemView.autoresizingMask            = 0;
        itemView.frame                       = CGRectMake(i*ScreenWidth/3, 0, ScreenWidth/3, IS_IPHONE6P ? height : 100);
        itemView.imgView.image               = [UIImage imageNamed:imgArr[i]];
        itemView.title.text                  = titleArr[i];
        UITapGestureRecognizer *tap          = [[UITapGestureRecognizer alloc]init];
        [itemView addGestureRecognizer:tap];
        @weakify(self)
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            !self.callBackBtnTagBlock ? : self.callBackBtnTagBlock(i);
        }];
        [self addSubview:itemView];
    }
}

@end
