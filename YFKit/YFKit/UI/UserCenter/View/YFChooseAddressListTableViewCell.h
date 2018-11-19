//
//  YFChooseAddressListTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFAddressModel;
@class YFConsignerModel;

@interface YFChooseAddressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, assign) NSInteger chooseAddressType;
@property (nonatomic, strong) YFAddressModel *model;
@property (nonatomic, strong) YFConsignerModel *Cmodel;
@end
