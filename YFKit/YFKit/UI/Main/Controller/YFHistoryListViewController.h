//
//  YFHistoryListViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@interface YFHistoryListViewController : YFBaseViewController
/**
 判断是发布中的货源还是历史货源 1发布中 --> 2历史货源
 */
@property (nonatomic, assign) NSInteger type;
/**
 刷新数据
 */
-(void)refreshData;
@end
