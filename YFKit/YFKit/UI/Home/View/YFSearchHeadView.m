//
//  YFSearchHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchHeadView.h"

@implementation YFSearchHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.searchTF.delegate = self;
//    self.searchTF.text = @"D201800049599";
    self.searchTF.text = @"R201800000028";
//    self.searchTF.text = @"WYF201800000472";
    @weakify(self);
    RACSignal *programmerSignal = [self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)];
    [programmerSignal subscribeNext:^(RACTuple* x) {
        //这里可以理解为的方法要的执行代码
        @strongify(self);
        [self removeKeyborad];
    }];
}
- (void)removeKeyborad {
    [_searchTF resignFirstResponder];
    if (self.searchClickBlock){
        if ([_searchTF.text removeWhiteSpace].length>0){
            self.searchClickBlock(_searchTF.text);
        }else{
            [YFToast showMessage:@"请输入订单号"];
        }
    }
}
@end
