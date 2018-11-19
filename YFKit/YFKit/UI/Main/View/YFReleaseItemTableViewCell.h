//
//  YFReleaseItemTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;
@interface YFReleaseItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *placeholder;
@property (nonatomic, strong) YFHomeDataModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;
@end
