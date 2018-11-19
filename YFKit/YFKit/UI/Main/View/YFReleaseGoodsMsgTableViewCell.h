//
//  YFReleaseGoodsMsgTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;
@interface YFReleaseGoodsMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *otherDes;
@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *centerTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (nonatomic, strong) YFHomeDataModel *model;
@end
