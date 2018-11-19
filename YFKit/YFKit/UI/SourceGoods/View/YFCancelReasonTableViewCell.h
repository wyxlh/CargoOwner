//
//  YFCancelReasonTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFCarTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface YFCancelReasonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reasonLbl;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (nonatomic, strong, nullable) YFCarTypeModel *model;
@end

NS_ASSUME_NONNULL_END
