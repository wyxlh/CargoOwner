//
//  YFChooseDriverViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
#import "YFDriverListModel.h"
@interface YFChooseDriverViewController : YFBaseViewController
/**
 是否是选择司机
 */
@property (nonatomic, assign) BOOL isChooseDriver;
@property (nonatomic, copy) void(^backDriverMsgBlock)(YFDriverListModel *);
@end
