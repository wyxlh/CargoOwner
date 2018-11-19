//
//  YFSortView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YFSortUserType) {
    YFSortUserLoginType,//登录的时候使用的
    YFSortUserBindType,//报价的时候筛选使用的
};

@interface YFSortView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 判断是时间还是价格 1 时间 2 价格
 */
@property (nonatomic, assign) NSInteger type;
/**
 判断是否前后两次都是点的同一个筛选条件
 */
@property (nonatomic, assign) NSInteger isEqual;
@property (nonatomic, strong) NSArray *dataArr;
/**
 使用的两种情况 登录的时候   报价列表筛选的时候
 */
@property (nonatomic, assign) YFSortUserType sortUserType;
/**
 默认选中第几个
 */
@property (nonatomic, assign) NSInteger selectIndex;
/**
 传回两个值, 一个值是当前点击的升序 还是降序 另外一个是点击的哪个 时间或是价格
 */
@property (nonatomic, copy) void (^backSortStateBlock)(NSInteger ,NSInteger);
-(void)disappear;
@end
