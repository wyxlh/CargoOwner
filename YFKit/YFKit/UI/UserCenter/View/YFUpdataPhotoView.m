//
//  YFUpdataPhotoView.m
//  YFKit
//
//  Created by 王宇 on 2018/7/2.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUpdataPhotoView.h"

@implementation YFUpdataPhotoView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}


#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight) {
        return YES;
    }
    return NO;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self disappear];
}

- (void)disappear
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}
- (IBAction)clickDisapper:(id)sender {
    [self disappear];
}
@end
