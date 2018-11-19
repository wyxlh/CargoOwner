//
//  YFShareButton.m
//  YFKit
//
//  Created by 王宇 on 2018/5/23.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFShareButton.h"

@implementation YFShareButton

- (IBAction)clickShareBtn:(id)sender {
    !self.clickShareBtnBlock ? : self.clickShareBtnBlock();
}


@end
