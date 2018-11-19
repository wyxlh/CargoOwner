//
//  YFHomeNearService.h
//  YFKit
//
//  Created by 王宇 on 2018/6/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFHomeNearViewModel.h"
@interface YFHomeNearService : NSObject <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) YFHomeNearViewModel *viewModel;
@end
