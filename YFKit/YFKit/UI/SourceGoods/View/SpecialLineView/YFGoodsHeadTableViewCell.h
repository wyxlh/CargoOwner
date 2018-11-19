//
//  YFGoodsHeadTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFHomeDataModel;

@interface YFGoodsHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic, strong) YFHomeDataModel *model;
@end
