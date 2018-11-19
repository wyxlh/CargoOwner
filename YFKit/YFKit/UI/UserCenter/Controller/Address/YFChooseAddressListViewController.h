//
//  YFChooseAddressListViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/6/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

typedef NS_ENUM (NSInteger, ChooseAddressType)
{
    AssignOrderType = 0,//指派下单
    SpecialLineSourceGoods = 1//线路货源
};

@class YFAddressModel;
@class YFConsignerModel;
@interface YFChooseAddressListViewController : YFBaseViewController
/**
 是否是发货人管理
 */
@property (nonatomic, assign) BOOL isConsignor;

/**
 地址Id 用来判断应该选择哪条数据的
 */
@property (nonatomic, copy) NSString *addressId;

/**
 区分指派下单和线路货源
 */
@property (nonatomic, assign) ChooseAddressType chooseAddressType;

/**
 收货人地址管理
 */
@property (nonatomic, copy) void(^backAddressBlock)(YFAddressModel *);
/**
 发货人地址管理
 */
@property (nonatomic, copy) void(^backCaddressBlock)(YFConsignerModel *);
@end
