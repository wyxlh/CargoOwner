//
//  YFChooseDriverTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFDriverListModel;
@interface YFChooseDriverTableViewCell : UITableViewCell
/**
 下单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *PlaceOrderBtn;
/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *name;

/**
 车牌
 */
@property (weak, nonatomic) IBOutlet UILabel *LicenseNum;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) YFDriverListModel *model;
@property (nonatomic, copy) void (^callBackImgBlock)(void);
@end
