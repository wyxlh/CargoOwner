//
//  YFSpecialLineService.h
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFSpecialLineViewModel.h"

@interface YFSpecialLineService : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) YFSpecialLineViewModel *viewModel;
@end
