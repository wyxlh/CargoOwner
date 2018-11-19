//
//  SKAppUpdaterView.m
//  SKKit
//
//  Created by maxin on 2017/6/2.
//  Copyright © 2017年 maxin. All rights reserved.
//

#import "SKAppUpdaterView.h"

@implementation SKAppUpdaterView

- (void)drawRect:(CGRect)rect {
   
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    SKViewsBorder(self.baView, 3, 0, [UIColor redColor]);
//    if (IS_IPHONE5) {
//        self.TopHeight.constant = 120;
//    }
    
}


- (IBAction)closeBtn:(id)sender {
    [self dismiss];
}

- (IBAction)upDateBtn:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    }
    NSString *appStoreURL = [NSString stringWithFormat:@"https://itunes.apple.com/app/id1386644247"];
    NSURL *appUrl = [NSURL URLWithString:appStoreURL];
    if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
        [[UIApplication sharedApplication] openURL:appUrl];
    }
   
    
}
-(void)dismiss{

    UIView * updateview  = [YFWindow viewWithTag:123456];
    [updateview removeFromSuperview];
    updateview = nil;
}




@end
