//
//  YFUserCenterService.h
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFUserCenterViewModel.h"
#import "YFUserCenterHeadView.h"
@interface YFUserCenterService : NSObject <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, nullable) YFUserCenterViewModel *viewModel;
@property (nonatomic, strong, nullable) YFUserCenterHeadView *headView;
@end
