//
//  YFSortViewTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSortViewTableViewCell : UITableViewCell
/**
 0 是登录 1 报价列表
 */
@property (nonatomic, assign) NSInteger sortUserType;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
