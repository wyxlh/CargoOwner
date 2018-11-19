//
//  YFUserCenterTableViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFUserCenterTableViewCell : UITableViewCell
@property (weak, nonatomic, nullable) IBOutlet UIImageView *imgView;
@property (weak, nonatomic, nullable) IBOutlet UILabel *title;
@property (nonatomic, strong, nullable) NSDictionary *dict;
@end
