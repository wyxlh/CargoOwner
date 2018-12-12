//
//  YFAddressListTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YFAddressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
