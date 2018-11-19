//
//  YFSpecialDetailAddressTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YFSpecialLineListModel;

@interface YFSpecialDetailAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *startDetailAddress;
@property (weak, nonatomic) IBOutlet UILabel *endDetailAddress;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (nonatomic, strong) YFSpecialLineListModel *model;
@property (nonatomic, strong) YFBaseViewController *superVC;
@end

NS_ASSUME_NONNULL_END
