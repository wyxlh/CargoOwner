//
//  YFFindCartService.h
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFFindCardViewModel.h"

@interface YFFindCartService : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, nullable) YFFindCardViewModel *viewModel;
@end
