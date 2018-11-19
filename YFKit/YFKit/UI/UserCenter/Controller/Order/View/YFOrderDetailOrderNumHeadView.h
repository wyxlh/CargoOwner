//
//  YFOrderDetailOrderNumHeadView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFOrderDetailModel;
@class YFSpecialLineListModel;

@interface YFOrderDetailOrderNumHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic, strong) YFOrderDetailModel *model;
@property (nonatomic, strong) YFSpecialLineListModel *sModel;
@end
