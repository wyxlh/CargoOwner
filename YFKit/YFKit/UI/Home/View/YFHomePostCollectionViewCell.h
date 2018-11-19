//
//  YFHomePostCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/7/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFHomePostCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void (^callBackBtnTagBlock)(NSInteger);
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
@end
