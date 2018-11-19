//
//  YFSignOutView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSignOutView.h"

@implementation YFSignOutView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.signOutBtn, 5, 0, NavColor);
}

@end
