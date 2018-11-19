//
//  YFReleaseGoodsMsgTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseGoodsMsgTableViewCell.h"
#import "YFHomeDataModel.h"

@implementation YFReleaseGoodsMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [AttributedLbl setRichTextOnlyColor:self.weightLbl titleString:@"重量（吨）*" textColor:OrangeBtnColor colorRang:NSMakeRange(5, 1)];
    self.leftTF.delegate = self;
    self.centerTF.delegate = self;
    @weakify(self)
    [[self.leftTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if ([string doubleValue] > 10000) {
            self.leftTF.text = @"9999";
        }
        DLog(@"%@",string);
    }];
    
    [[self.centerTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if ([string doubleValue] > 10000) {
            self.centerTF.text = @"9999";
        }
        DLog(@"%@",string);
    }];
    
    [[self.rightTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string = [NSString stringWithFormat:@"%@",x];
        if ([string containsString:@"."]) {
            self.rightTF.text = [NSString stringWithFormat:@"%ld",[self.rightTF.text integerValue]];
        }
        if ([string integerValue] >= 100000) {
            self.rightTF.text = @"99999";
        }
        DLog(@"%@",string);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        self.isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                if(single == '.')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0')
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.')
            {
                if(!self.isHaveDian)//text中还没有小数点
                {
                    self.isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}



-(void)setModel:(YFHomeDataModel *)model{
    if (!model.isCheck) {
        self.leftTF.text = self.centerTF.text = self.rightTF.text = @"";
    }
}

@end
