//
//  YFSpecialLineListViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@interface YFSpecialLineListViewController : YFBaseViewController
@property (nonatomic, copy, nullable) NSString *type;//订单状态
/**
 刷新数据
 */
-(void)refreshData;
@end
