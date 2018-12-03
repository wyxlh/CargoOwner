//
//  YFSearchViewController.h
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YFSearchOrderShowType) {
    YFSearchOrderShowHistoryType,//历史搜索
    YFSearchOrderShowResultType  //搜索出来的效果
};
@interface YFSearchViewController : YFBaseViewController

@property (nonatomic, assign) YFSearchOrderShowType searchType;

@end

NS_ASSUME_NONNULL_END
