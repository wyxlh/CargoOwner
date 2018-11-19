//
//  YFSpecialDetailPaymentTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YFSpecialLineListModel;

@interface YFSpecialDetailPaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *otherPlan;
@property (nonatomic, strong) YFSpecialLineListModel *model;
@end

NS_ASSUME_NONNULL_END
