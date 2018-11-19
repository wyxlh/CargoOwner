//
//  YFOrderDetailCarMsgTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFOrderDetailModel;
@interface YFOrderDetailCarMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *goodsMsg;
@property (weak, nonatomic) IBOutlet UILabel *free;
@property (weak, nonatomic) IBOutlet UILabel *driver;
@property (weak, nonatomic) IBOutlet UILabel *mark;
@property (nonatomic, strong) YFOrderDetailModel *model;
@end
