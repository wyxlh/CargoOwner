//
//  YFPlaceOrderItemTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;
@interface YFPlaceOrderItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (nonatomic, strong) YFHomeDataModel *model;
@end
