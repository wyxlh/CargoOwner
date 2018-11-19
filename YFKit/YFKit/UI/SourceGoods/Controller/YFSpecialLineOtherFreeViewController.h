//
//  YFSpecialLineOtherFreeViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/9/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@class YFSpecialLineModel;
@interface YFSpecialLineOtherFreeViewController : YFBaseViewController
@property (nonatomic, strong) YFSpecialLineModel *specilLineModel;
/**
 返回 费用明细和 计算完的总费用
 */
@property (nonatomic, copy) void (^allOtherFreeBlock)(YFSpecialLineModel *specialModel, double otherFree);

@end
