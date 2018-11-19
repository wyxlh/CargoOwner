//
//  YFSettingViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBaseViewController.h"
@interface YFSettingViewController : YFBaseViewController
/**
 是够是子账号
 */
@property (nonatomic, assign) BOOL isSon;
@property (nonatomic, copy, nullable) NSString *userName;
@end
