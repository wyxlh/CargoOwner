//
//  YFPersonSubmitCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPersonSubmitCollectionViewCell.h"

@implementation YFPersonSubmitCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    SKViewsBorder(self.submitBtn, 3, 0, NavColor);
}

@end
