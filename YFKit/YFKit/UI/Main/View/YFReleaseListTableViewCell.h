//
//  YFHistoryListTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFReleseListModel;
@class YFOrderListModel;
@interface YFReleaseListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *amount;
/**
 订单状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderState;
/**
 单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
/**
 创建时间
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
 车的相关信息
 */
@property (weak, nonatomic) IBOutlet UILabel *carMsg;
/**
 
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsVolume;
/**
 预期提货日期
 */
@property (weak, nonatomic) IBOutlet UILabel *Etime;

@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgView;
@property (nonatomic, strong) YFReleseListModel *model;

/**
 为了判断下单已完成的订单状态 特意传下来的
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) YFOrderListModel *Omodel;
@end
