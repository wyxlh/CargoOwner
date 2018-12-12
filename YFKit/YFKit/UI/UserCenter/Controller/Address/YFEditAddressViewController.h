//
//  YFEditAddressViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
#import "YFAddressModel.h"

@interface YFEditAddressViewController : YFBaseViewController
/**
 是否是编辑地址
 */
@property (nonatomic, assign) BOOL isEdit;
/**
 是否是发货人管理
 */
@property (nonatomic, assign)BOOL isConsignor;
@property (nonatomic, strong) YFAddressModel *aModel;
@end
