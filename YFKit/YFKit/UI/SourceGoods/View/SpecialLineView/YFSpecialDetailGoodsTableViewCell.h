//
//  YFSpecialDetailGoodsTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YFSpecialGoodsModel;

@interface YFSpecialDetailGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *goodsMsg;
@property (weak, nonatomic) IBOutlet UILabel *feeLbl;
@property (nonatomic, strong) YFSpecialGoodsModel *model;
@end

NS_ASSUME_NONNULL_END
