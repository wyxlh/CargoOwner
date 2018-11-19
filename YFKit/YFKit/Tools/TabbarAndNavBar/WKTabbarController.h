//
//  WKTabbarController.h
//  WKKit
//
//  Created by 王宇 on 16/9/13.
//  Copyright © 2016年 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTabbarController : UITabBarController

/**
 *  指定选中这个Tabbar
 *
 */
-(void)appointTabbarIndex:(NSInteger)index;
/**
 *  指定哪一个Tabbar上面有一个小红点。为0 就不显示了
 *
 *  @param badgeValue 数量
 *  @param index      index
 */
-(void)appointbadgeValue:(NSInteger)badgeValue toIndex:(NSInteger)index;



@end
