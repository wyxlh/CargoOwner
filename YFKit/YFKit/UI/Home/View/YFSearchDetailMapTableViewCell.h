//
//  YFSearchDetailMapTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSearchDetailMapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (nonatomic, strong) MAMapView *mapView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
