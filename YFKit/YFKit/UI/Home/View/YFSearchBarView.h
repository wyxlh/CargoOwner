//
//  YFSearchBarView.h
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSearchBarView : UIView
@property (nonatomic, copy) void(^searchBarBlock)(void);
@end

NS_ASSUME_NONNULL_END
