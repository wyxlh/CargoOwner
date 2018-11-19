//
//  YFChooseDriverHeadView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFChooseDriverHeadView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic, copy) void (^clickSearchCallBackBlock)(void);
@end
