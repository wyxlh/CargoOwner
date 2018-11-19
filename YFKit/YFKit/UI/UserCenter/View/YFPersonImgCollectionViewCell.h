//
//  YFPersonImgCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFPersonPhotoModel;
@interface YFPersonImgCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *noPhotoLbl;
@property (nonatomic, assign) BOOL isUdate;
@property (nonatomic, strong) YFPersonPhotoModel *model;
@end
