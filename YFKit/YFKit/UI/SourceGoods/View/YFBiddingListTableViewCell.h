//
//  YFBiddingListTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PriceListModel;
@interface YFBiddingListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) YFBaseViewController *superVC;
@property (nonatomic, strong) PriceListModel *model;
@property (nonatomic, copy) void (^callBackBlock)(void);
///**
// 如果当前司机q已经取消报价 需要刷新当前页面的数据
// */
//@property (nonatomic, copy) void (^refreashDataBlock)(void);

@end
