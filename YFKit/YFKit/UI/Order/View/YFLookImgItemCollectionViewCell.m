//
//  YFLookImgItemCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFLookImgItemCollectionViewCell.h"
#import "YFLookSignModel.h"
@implementation YFLookImgItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    SKViewsBorder(self.imgView, 3, 0, NavColor);
    // Initialization code
}

-(void)setPath:(NSString *)path{
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:path] placeholder:[UIImage imageNamed:@""]];
}

@end
