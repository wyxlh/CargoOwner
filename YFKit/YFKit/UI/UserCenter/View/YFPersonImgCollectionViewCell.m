//
//  YFPersonImgCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPersonImgCollectionViewCell.h"
#import "YFPersonPhotoModel.h"
@implementation YFPersonImgCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.noPhotoLbl.adjustsFontSizeToFitWidth = YES;
}

-(void)setModel:(YFPersonPhotoModel *)model{
    self.title.text = model.title;
    if (self.isUdate) {
        self.noPhotoLbl.text = [NSString isBlankString:model.path] ? [NSString stringWithFormat:@"上传%@",model.title] : @"点击修改";
        if ([model.path containsString:@"http://"] || [NSString isBlankString:model.path]) {
            self.noPhotoLbl.hidden = NO;
        }else{
            self.noPhotoLbl.hidden = YES;
        }
        self.noPhotoLbl.alpha = [NSString isBlankString:model.path] ? 1 : 0.7;
    }else{
        self.noPhotoLbl.text = [NSString isBlankString:model.path] ? [NSString stringWithFormat:@"上传%@",model.title] :@"点击修改";
        
        self.noPhotoLbl.hidden = [NSString isBlankString:model.path] ? NO : YES;
//        self.noPhotoLbl.alpha = [NSString isBlankString:model.path] ? 1 : 0.8;
    }
    
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:model.path] placeholder:[UIImage imageNamed:@"placehoderLogo"]];
}

@end
