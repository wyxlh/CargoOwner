//
//  YFFindCarSearchBarView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFFindCarSearchBarView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) void(^searchCarSourceBlock)(NSString *);
@end
