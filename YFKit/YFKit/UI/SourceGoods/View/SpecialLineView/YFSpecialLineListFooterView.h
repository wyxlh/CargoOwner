//
//  YFSpecialLineListFooterView.h
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFSpecialLineListFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
/**
 yzf 已取消   yhz 未承运  whz 已开单  其余都为  已承运
 */
@property (nonatomic, copy) NSString *shipStatue;
@property (nonatomic, copy) void (^clickRightBtnBlock)(NSString *title);
@end
