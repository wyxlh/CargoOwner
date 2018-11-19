//
//  YFSpecialDetailOtherFeeTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YFSpecialLineListModel;

@interface YFSpecialDetailOtherFeeTableViewCell : UITableViewCell
/**
 声明价值
 */
@property (weak, nonatomic) IBOutlet UILabel *valueFee;
/**
 代收货款
 */
@property (weak, nonatomic) IBOutlet UILabel *generationFee;
/**
 保价费
 */
@property (weak, nonatomic) IBOutlet UILabel *protectionFee;
/**
 手续费
 */
@property (weak, nonatomic) IBOutlet UILabel *proceduresFee;
/**
 信息费
 */
@property (weak, nonatomic) IBOutlet UILabel *informationFee;
/**
  送货费
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryFree;
/**
 提货费
 */
@property (weak, nonatomic) IBOutlet UILabel *takeFee;
/**
 回单
 */
@property (weak, nonatomic) IBOutlet UILabel *returnFee;
@property (nonatomic, strong) YFSpecialLineListModel *model;
@end

NS_ASSUME_NONNULL_END
