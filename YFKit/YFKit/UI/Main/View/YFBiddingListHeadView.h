//
//  YFBiddingListHeadView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFBiddingListModel;
@interface YFBiddingListHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (nonatomic, strong) NSTimer *timer;//倒计时
@property (nonatomic, assign) NSInteger counting; //倒计时秒数
@property (nonatomic, strong) YFBiddingListModel *model;
@property (nonatomic, copy) NSString *publishedTime;//货源发布时间 用来做倒计时
// 把选择状态和tag值传回去
@property (nonatomic, copy) void (^callBackSortBlock)(NSInteger,BOOL);

@end
