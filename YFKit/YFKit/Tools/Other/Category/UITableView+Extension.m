//
//  UITableView+Extension.m
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

/**
 刷新指定的某一行
 
 @param section 指定的一个区
 @param indexPath 指定的某一行
 */
- (void)refreshTableViewWithSection:(NSInteger )section indexPath:(NSInteger)indexPath{
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:indexPath inSection:section];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

/**
 刷新某一个区
 
 @param section 指定的某个区
 */
- (void)refreshTableViewWithSection:(NSInteger )section{
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

@end
