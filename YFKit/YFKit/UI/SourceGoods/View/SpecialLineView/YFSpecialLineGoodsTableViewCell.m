//
//  YFSpecialLineGoodsTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineGoodsTableViewCell.h"
#import "YFHomeDataModel.h"

@implementation YFSpecialLineGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [AttributedLbl setRichTextOnlyColor:self.countTitle titleString:@"件数（件）*" textColor:OrangeBtnColor colorRang:NSMakeRange(5, 1)];
    [AttributedLbl setRichTextOnlyColor:self.weightTitle titleString:@"重量（KG）*" textColor:OrangeBtnColor colorRang:NSMakeRange(6, 1)];
    [AttributedLbl setRichTextOnlyColor:self.volumeTitle titleString:@"体积（方）*" textColor:OrangeBtnColor colorRang:NSMakeRange(5, 1)];
    [AttributedLbl setRichTextOnlyColor:self.feeLbl titleString:@"运费*" textColor:OrangeBtnColor colorRang:NSMakeRange(2, 1)];
    SKViewsBorder(self.numLbl, 8, 1, OrangeBtnColor);
    SKViewsBorder(self.deleteBtn, 3, 0.5, OrangeBtnColor);
    //体积和重量可以保留两位小数
    self.weightTF.delegate = self;
    self.volumeTF.delegate = self;
    self.countTF.delegate  = self;
    self.freeTF.delegate   = self;
    
    //件数
    @weakify(self)
    [[self.countTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string        = [NSString stringWithFormat:@"%@",x];
        if (string.length != 0) {
            NSString *firstStr      = [string substringWithRange:NSMakeRange(0, 1)];
            if ([firstStr isEqualToString:@"0"]) {//如果第一个数字为0 不需要显示
                self.countTF.text   = [string substringWithRange:NSMakeRange(1, string.length-1)];
            }
        }
        if (string.length > 5) {
            self.countTF.text   = [string substringWithRange:NSMakeRange(0, 5)];
        }
        self.model.countNumTF = self.countTF.text;
    }];
    //重量
    [[self.weightTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string       = [NSString stringWithFormat:@"%@",x];
        if ([string integerValue] > 10000) {
            self.weightTF.text = [string substringWithRange:NSMakeRange(0, 4)];
        }
        self.model.weightTF    = self.weightTF.text;
    }];
    //体积
    [[self.volumeTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string    = [NSString stringWithFormat:@"%@",x];
        if ([string integerValue] > 10000) {
            self.volumeTF.text = [string substringWithRange:NSMakeRange(0, 4)];
        }
        self.model.volumeTF = self.volumeTF.text;
    }];
    //运费
    [[self.freeTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *string     = [NSString stringWithFormat:@"%@",x];
        if (string.length > 6) {
            self.freeTF.text = [string substringWithRange:NSMakeRange(0, 6)];
        }
        if (![self.freeTF.text isEqualToString:self.isChangeString]) {
            self.model.freeTF = self.freeTF.text;
            !self.editRefreshBlock ? : self.editRefreshBlock();
            self.isChangeString = self.freeTF.text;
        }
    }];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFHomeDataModel *)model{
    _model                               = model;
    self.title.text                      = model.title;
    if (model.isCheck) {
        self.title.text                  = model.placeholder;
    }else{
        self.title.text                  = @"";
        self.title.placeholder           = model.placeholder;
    }
    self.countTF.text                    = model.countNumTF;
    self.weightTF.text                   = model.weightTF;
    self.volumeTF.text                   = model.volumeTF;
    self.freeTF.text                     = model.freeTF;
}

@end
