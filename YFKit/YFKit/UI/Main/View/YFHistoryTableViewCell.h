//
//  YFHistoryTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFReleseListModel;
@interface YFHistoryTableViewCell : UITableViewCell
/**
开始地址
 */
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
/**
 结束地址
 */
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
/**
 状态
 */
@property (weak, nonatomic) IBOutlet UILabel *GoodsStatus;
/**
 火车信息
 */
@property (weak, nonatomic) IBOutlet UILabel *carMsg;
/**
 物件信息
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsVolume;

@property (nonatomic, strong) YFReleseListModel *model;

@end
