//
//  YFSortView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSortView : UIView<UITableViewDelegate,UITableViewDataSource>
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
 传回两个值, 一个值是当前点击的升序 还是降序 另外一个是点击的哪个 时间或是价格
 */
@property (nonatomic, copy) void (^backSortStateBlock)(NSInteger ,NSInteger);
-(void)disappear;
@end
