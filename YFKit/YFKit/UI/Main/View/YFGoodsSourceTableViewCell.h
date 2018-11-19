//
//  YFGoodsSourceTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFReleseDetailModel;
@interface YFGoodsSourceTableViewCell : UITableViewCell
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
 车辆信息
 */
@property (weak, nonatomic) IBOutlet UILabel *carMsg;
/**
 装货时间
 */
@property (weak, nonatomic) IBOutlet UILabel *Etime;
/**
 物品体积
 */
@property (weak, nonatomic) IBOutlet UILabel *goodVolume;
/**
 期望运费
 */
@property (weak, nonatomic) IBOutlet UILabel *wantFree;
/**
 指定司机
 */
@property (weak, nonatomic) IBOutlet UILabel *driver;
/**
 其他
 */
@property (weak, nonatomic) IBOutlet UILabel *more;

@property (nonatomic, strong) YFReleseDetailModel *model;
@end
