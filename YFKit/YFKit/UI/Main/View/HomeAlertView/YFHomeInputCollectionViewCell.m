//
//  YFHomeInputCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeInputCollectionViewCell.h"

@implementation YFHomeInputCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置TextField属性之文字距左边框的距离
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    SKViewsBorder(self.textField, 3, 0.5, UIColorFromRGB(0xD6D5D9));
    [[self.textField rac_textSignal] subscribeNext:^(id x) {
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if (string.length > 8) {
            self.textField.text = [string substringWithRange:NSMakeRange(0, 8)];
        }
        DLog(@"%@",string);
    }];
    // Initialization code
}

@end
