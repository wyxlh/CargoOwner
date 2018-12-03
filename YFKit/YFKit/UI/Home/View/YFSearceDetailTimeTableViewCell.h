//
//  YFSearceDetailTimeTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class detailsModel;
@interface YFSearceDetailTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detailDes;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (nonatomic, assign) NSInteger index;
/**订单所有者*/
@property (nonatomic, copy) NSString *creator;
/**第一个 cell 的下面的线的约束要小一点, 后面的要大一点, 这是图片引起的*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (nonatomic, strong) detailsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
