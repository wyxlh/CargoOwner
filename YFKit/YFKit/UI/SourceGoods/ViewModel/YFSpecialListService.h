//
//  YFSpecialListService.h
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFSpecialListViewModel.h"

@interface YFSpecialListService : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) YFSpecialListViewModel *viewModel;
@end
