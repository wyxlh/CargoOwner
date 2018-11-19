//
//  YFSpecialLineListTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFSpecialLineListModel;

NS_ASSUME_NONNULL_BEGIN
@interface YFSpecialLineListTableViewCell : UITableViewCell
/**
 订单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;
/**
 出发地
 */
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
/**
 目的地
 */
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
/**
 货品信息
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsMsg;
/**
 其他要求
 */
@property (weak, nonatomic) IBOutlet UILabel *remake;

@property (nonatomic, strong, nullable) YFSpecialLineListModel *model;
@end
NS_ASSUME_NONNULL_END
