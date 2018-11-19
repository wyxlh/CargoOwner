//
//  UITableView+Extension.h
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extension)

/**
 刷新指定的某一行

 @param section 指定的一个区
 @param indexPath 指定的某一行
 */
- (void)refreshTableViewWithSection:(NSInteger )section indexPath:(NSInteger)indexPath;

/**
 刷新某一个区

 @param section 指定的某个区
 */
- (void)refreshTableViewWithSection:(NSInteger )section;

@end

NS_ASSUME_NONNULL_END
