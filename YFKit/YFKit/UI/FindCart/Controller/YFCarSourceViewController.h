//
//  YFCarSourceViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@interface YFCarSourceViewController : YFBaseViewController

/**
 搜索条件
 */
@property (nonatomic, copy) NSString *condition;

/**
 是否在线
 */
@property (nonatomic, assign) BOOL onLine;

/**
 刷新数据
 */
-(void)refreshData;

/**
 隐藏筛选View
 */
-(void)dissmissSortView;

@end
