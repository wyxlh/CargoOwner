//
//  YFAdjFreeAlertView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFOrderListModel;
@interface YFAdjFreeAlertView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placehodle;
@property(nonatomic,strong)UIView *bGView;
@property (nonatomic, strong) YFOrderListModel *model;
@property (nonatomic, copy) void (^adjustmentFreeBlock)(BOOL,NSString *,NSString *);
- (void)show:(BOOL)animated;
@end
