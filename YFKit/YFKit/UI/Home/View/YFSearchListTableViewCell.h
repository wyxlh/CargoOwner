//
//  YFSearchListTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YFSearchListModel;
@interface YFSearchListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (nonatomic, strong) YFSearchListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
