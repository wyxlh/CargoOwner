//
//  YFSearchGoodsItemTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSearchGoodsItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *driver;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
