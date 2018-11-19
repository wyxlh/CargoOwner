//
//  YFUpdataPhotoView.h
//  YFKit
//
//  Created by 王宇 on 2018/7/2.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFUpdataPhotoView : UIView <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *placeHolderImg;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *PhotoBtn;
- (void)disappear;
@end
