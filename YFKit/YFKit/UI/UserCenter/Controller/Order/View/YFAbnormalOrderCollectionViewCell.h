//
//  YFAbnormalOrderCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/7/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFLookSignModel;
@interface YFAbnormalOrderCollectionViewCell : UICollectionViewCell
/**
 异常类型
 */
@property (weak, nonatomic) IBOutlet UILabel *abnormalType;
/**
 异常说明
 */
@property (weak, nonatomic) IBOutlet UILabel *abnormalExplain;
@property (nonatomic, strong) YFLookSignModel *model;
@end
