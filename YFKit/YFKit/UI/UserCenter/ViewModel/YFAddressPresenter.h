//
//  YFAddressPresenter.h
//  YFKit
//
//  Created by 王宇 on 2018/12/11.
//  Copyright © 2018 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFAddressListTableViewCell.h"
#import "YFAddressModel.h"
#import "YFAddressFooterView.h"

NS_ASSUME_NONNULL_BEGIN

// 1. 准备所有view需要的最终数据 (MVVM)
// 2. 展示到view上面
@interface YFAddressPresenter : NSObject

/**
 发货人 收货人 model
 */
@property (nonatomic, strong) YFAddressModel *model;

/**
  绑定 cell

 @param cell  传进来的 cell
 */
- (void)bindToCell:(YFAddressListTableViewCell *)cell;

/**
 设置 footer

 @param footerView  传进来的footerView
 */
- (void)bindToFooterView:(YFAddressFooterView *)footerView;


/**
 处理footerView按钮逻辑

 @param baseVC 上个页面的 VC 用于跳转用
 @param buttonTitleString 按钮的 title
 @param isConsignor  这条数据的 是否是发货人地址
 @param resultBlock  执行结束之后刷新页面
 */
- (void)handleFooterViewButton:(YFBaseViewController *)baseVC
             buttonTitleString:(NSString *)buttonTitleString
                   isConsignor:(BOOL)isConsignor
                   resultBlock:(void(^)(void))resultBlock;
@end

NS_ASSUME_NONNULL_END
