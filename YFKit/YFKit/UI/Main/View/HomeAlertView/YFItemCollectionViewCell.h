//
//  YFItemCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFCarTypeModel;
@class YFChooseAddressModel;
@interface YFItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong) YFCarTypeModel *model;
@property (nonatomic, strong) YFChooseAddressModel *AddressModel;
@end
