//
//  YFItemCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFItemCollectionViewCell.h"

@implementation YFItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    SKViewsBorder(self.title, 1, 0.5, UIColorFromRGB(0xDFDFDF));
}

@end
