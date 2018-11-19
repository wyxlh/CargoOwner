//
//  YFOrderDetailLogisticsTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFOrderDetailLogisticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/**
 物流地址
 */
@property (weak, nonatomic) IBOutlet UILabel *address;
/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;
/**
 图片宽度
 */
@property (weak, nonatomic) IBOutlet UILabel *topLine;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (nonatomic, assign)NSInteger index;
/**
第一个 cell 的下面的线的约束要小一点, 后面的要大一点, 这是图片引起的
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;

@end
