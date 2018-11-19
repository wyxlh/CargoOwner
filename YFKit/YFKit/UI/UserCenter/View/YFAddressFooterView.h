//
//  YFAddressFooterView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFAddressModel;
@class YFConsignerModel;
@interface YFAddressFooterView : UIView
@property (nonatomic, strong, nullable) YFBaseViewController *superVC;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
/**
 是否是发货人管理
 */
@property (nonatomic, assign)BOOL isConsignor;
@property (nonatomic, strong) YFAddressModel *model;
@property (nonatomic, strong) YFConsignerModel *Cmodel;
@property (nonatomic, copy) void(^refreshBlock)(void);
@end
