//
//  YFOrderAddressTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFOrderDetailModel;
@interface YFOrderAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *Sdetail;
@property (weak, nonatomic) IBOutlet UILabel *Edetail;
@property (nonatomic, strong)YFOrderDetailModel *model;
@end
