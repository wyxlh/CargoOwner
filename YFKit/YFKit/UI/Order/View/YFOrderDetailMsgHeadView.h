//
//  YFOrderDetailMsgHeadView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFOrderDetailMsgHeadView : UIView
/**
 title
 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/**
 右边按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^showCarMsgBlock)(void);
@end
