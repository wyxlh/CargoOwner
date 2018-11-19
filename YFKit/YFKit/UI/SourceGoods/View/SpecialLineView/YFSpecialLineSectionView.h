//
//  YFSpecialLineSectionView.h
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSpecialLineSectionView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (nonatomic, copy) void(^showCarMsgBlock)(void);
@end

NS_ASSUME_NONNULL_END
