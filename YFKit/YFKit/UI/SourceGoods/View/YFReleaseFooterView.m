//
//  YFReleaseFooterView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseFooterView.h"

@implementation YFReleaseFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.submitBtn, 3, 0, NavColor);
}

@end
