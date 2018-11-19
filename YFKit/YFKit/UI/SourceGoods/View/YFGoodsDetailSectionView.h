//
//  YFGoodsDetailSectionView.h
//  YFKit
//
//  Created by 王宇 on 2018/7/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFGoodsDetailSectionView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
/**
 1 发布中 2 已承运 3 未承运 4 已取消
 */
@property (nonatomic, assign) NSInteger orderType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomRightCons;
@property (nonatomic, copy) void (^clickDriverLookTypeBlock)(NSInteger);
@end
