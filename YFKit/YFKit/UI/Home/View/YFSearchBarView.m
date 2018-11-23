//
//  YFSearchBarView.m
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchBarView.h"

@implementation YFSearchBarView

- (IBAction)clickGesture:(id)sender {
    !self.searchBarBlock ? : self.searchBarBlock();
}

@end
