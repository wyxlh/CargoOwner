//
//  YFGoodsSourceDetailViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@interface YFGoodsSourceDetailViewController : YFBaseViewController
/**
 判断是发布中的货源还是历史货源 1发布中 --> 2历史货源
 */
@property (nonatomic, assign)NSInteger type;
/**
 1 发布中 2 已承运 3 未承运 4 已取消
 */
@property (nonatomic, assign)NSInteger orderType;
@property (nonatomic, copy) NSString *Id;
@end
