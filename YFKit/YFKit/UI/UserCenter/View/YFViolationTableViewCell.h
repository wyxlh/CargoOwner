//
//  YFViolationTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFViolationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) YFBaseViewController *superVC;
@end
