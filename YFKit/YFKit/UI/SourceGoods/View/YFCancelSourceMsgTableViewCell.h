//
//  YFCancelSourceMsgTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YFReleseDetailModel;
@class YFOrderDetailModel;
@interface YFCancelSourceMsgTableViewCell : UITableViewCell
/**
 货源单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time;
/**
 开始地址
 */
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
/**
 结束地址
 */
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
/**
 开始详细地址
 */
@property (weak, nonatomic) IBOutlet UILabel *startDetail;
/**
 结束详细地址
 */
@property (weak, nonatomic) IBOutlet UILabel *endDetail;
/**
 距离
 */
@property (weak, nonatomic) IBOutlet UILabel *distance;
/**
 货源
 */
@property (nonatomic, strong) YFReleseDetailModel *sourceModel;
/**
 订单
 */
@property (nonatomic, strong) YFOrderDetailModel *orderModel;
@end

NS_ASSUME_NONNULL_END
