//
//  YFCarTypeItemCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/26.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFCarTypeModel;
@interface YFCarTypeItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImg;
@property (nonatomic, strong) YFCarTypeModel *model;
@property (nonatomic, strong) YFChooseAddressModel *addressModel;
@property (nonatomic, copy) void(^deleteSelectItemBlock)(void);
@end
