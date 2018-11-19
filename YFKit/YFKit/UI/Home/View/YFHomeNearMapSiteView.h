//
//  YFHomeNearMapSiteView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFHomeNearMapSiteView : UIView <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong, nullable) NSMutableArray *dataArr;
@property (nonatomic, assign) int lastContentOffset;
@property (nonatomic, assign) BOOL istop;
/**
 上拉加载
 */
@property (nonatomic, copy) void(^callBackBlock)(void);

/**
 返回经纬度
 */
@property (nonatomic, copy) void(^callLocationBlock)(NSDictionary *);
@property (nonatomic, copy) void(^dispperBlock)(void);
//消失当前View
- (void)disappear;
@end
