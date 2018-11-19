//
//  YFDriverMapDetailViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/21.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
#import "YFOrderTrajectoryModel.h"
@interface YFDriverMapDetailViewController : YFBaseViewController
@property (nonatomic, strong) NSArray <YFOrderTrajectoryModel *> *TrajectoryArr;//轨迹数据
@property (nonatomic, strong) YFOrderLocationModel *location;
@property (nonatomic, copy)   NSString *phone;
@end
