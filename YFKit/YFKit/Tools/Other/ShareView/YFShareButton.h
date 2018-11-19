//
//  YFShareButton.h
//  YFKit
//
//  Created by 王宇 on 2018/5/23.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFShareButton : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, copy) void(^clickShareBtnBlock)(void);
@end
