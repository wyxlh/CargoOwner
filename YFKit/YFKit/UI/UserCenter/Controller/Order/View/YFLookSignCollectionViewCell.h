//
//  YFLookSignCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFLookSignModel;
@class YFSearchLookSignModel;
@interface YFLookSignCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;//订单号
@property (weak, nonatomic) IBOutlet UILabel *signPeople;//签收人
@property (weak, nonatomic) IBOutlet UILabel *signTime;//签收时间
@property (weak, nonatomic) IBOutlet UILabel *signType;//签收类型
@property (nonatomic, strong) YFLookSignModel *model;
@property (nonatomic, strong) YFSearchLookSignModel *searchModel;
@end
