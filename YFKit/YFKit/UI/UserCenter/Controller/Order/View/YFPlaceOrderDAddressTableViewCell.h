//
//  YFPlaceOrderDAddressTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;
@interface YFPlaceOrderDAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (nonatomic, strong) YFHomeDataModel *model;
@end
