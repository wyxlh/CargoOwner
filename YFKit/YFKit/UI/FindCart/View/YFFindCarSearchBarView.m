//
//  YFFindCarSearchBarView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/19.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCarSearchBarView.h"

@implementation YFFindCarSearchBarView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.searchBar, 3, 0, NavColor);
    self.searchBar.leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 28, 18)];
    //设置显示模式为永远显示(默认不显示)
    self.searchBar.leftViewMode = UITextFieldViewModeAlways;
    self.searchBar.delegate = self;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 18, 18)];
    imgView.image = [UIImage imageNamed:@"searchHui"];
    [self.searchBar.leftView addSubview:imgView];
    
    @weakify(self);
    RACSignal *programmerSignal = [self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)];
    [programmerSignal subscribeNext:^(RACTuple* x) {
        //这里可以理解为的方法要的执行代码
        @strongify(self);
        !self.searchCarSourceBlock ? : self.searchCarSourceBlock(self.searchBar.text);
    }];
}


@end
