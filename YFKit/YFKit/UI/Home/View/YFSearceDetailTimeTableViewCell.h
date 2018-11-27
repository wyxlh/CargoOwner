//
//  YFSearceDetailTimeTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSearceDetailTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *topLine;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (nonatomic, assign)NSInteger index;
/**
 第一个 cell 的下面的线的约束要小一点, 后面的要大一点, 这是图片引起的
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
