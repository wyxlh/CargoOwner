//
//  YFSearchDetailMapTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFLogisticsTrackMapView;
NS_ASSUME_NONNULL_BEGIN
@class YFSearchDetailModel;
@interface YFSearchDetailMapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (nonatomic, strong) YFLogisticsTrackMapView *mapView;
@property (nonatomic, strong) YFSearchDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
