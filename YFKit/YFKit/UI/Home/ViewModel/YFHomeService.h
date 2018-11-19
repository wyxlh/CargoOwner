//
//  YFHomeService.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFHomeViewModel.h"
@interface YFHomeService : NSObject <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, nullable) YFHomeViewModel *viewModel;
@end
