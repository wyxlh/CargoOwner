//
//  YFAddressFooterView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YFAddressFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (nonatomic, copy) void(^refreshBlock)(NSString *titleString);
+ (instancetype)loadFooterView;
@end
