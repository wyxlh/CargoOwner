//
//  YFDriverDetailViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"

@interface YFDriverDetailViewController : YFBaseViewController
@property (nonatomic, copy, nullable) NSString *driveId;
@property (nonatomic, copy) void (^refreashDriverDataBlock)(void);
@end