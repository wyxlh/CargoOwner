//
//  YFOrderDetailMapTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFOrderTrajectoryModel.h"
@interface YFOrderDetailMapTableViewCell : UITableViewCell<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSArray *lines;
//标记开始于结束的位置
@property (nonatomic, strong) NSMutableArray *annotations;
/**
 开始结束和货车图标
 */
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) YFOrderLocationModel *location;
@property (nonatomic, strong) NSArray <YFOrderTrajectoryModel *> *TrajectoryArr;//轨迹数据
@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@end
