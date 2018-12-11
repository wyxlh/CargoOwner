//
//  YFSearchDetailViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFSearchDetailViewController : YFBaseViewController
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *syscode;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy, readonly) YFSearchDetailViewController *(^billIdBlock)(NSString *billId);
@property (nonatomic, copy, readonly) YFSearchDetailViewController *(^syscodeBlock)(NSString *syscode);
@property (nonatomic, copy, readonly) YFSearchDetailViewController *(^typeBlock)(NSString *type);
@property (nonatomic, copy, readonly) YFSearchDetailViewController *(^IdBlock)(NSString *Id);
@end

NS_ASSUME_NONNULL_END
