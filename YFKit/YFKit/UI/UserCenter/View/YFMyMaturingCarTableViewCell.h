//
//  YFMyMaturingCarTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFCarSourceModel.h"
@interface YFMyMaturingCarTableViewCell : UITableViewCell <AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *carNum;
@property (weak, nonatomic) IBOutlet UILabel *transactionsNum;
/**
 是否在线
 */
@property (weak, nonatomic) IBOutlet UILabel *onLine;
@property (weak, nonatomic) IBOutlet UIImageView *addressLogo;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
/**
 车牌号距离上面的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carNumCons;
/**
 交易次数距离上面的次数
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countCons;
@property (nonatomic, strong) YFCarSourceModel *model;
@property (nonatomic, strong) YFMayBeCarModel *Lmodel;
@property (nonatomic, copy) void (^callBackBlock)(BOOL);
@end
