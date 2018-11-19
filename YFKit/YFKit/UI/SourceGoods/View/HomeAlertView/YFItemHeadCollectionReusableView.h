//
//  YFItemHeadCollectionReusableView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFItemHeadCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) void (^clickCancenBlock)(void);
@end
