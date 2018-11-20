//
//  YFPersonCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/12.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPersonCollectionViewCell.h"
#import "YFPersonImageModel.h"

@implementation YFPersonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YFPersonImageModel *)model{
    //008 可以修改公司, 001 是不能修改公司名的
    self.companyName.enabled = IS_CARGO_OWNER;
    self.name.enabled = self.IDCard.enabled = self.isUpdata;
    self.changeBtn.userInteractionEnabled = self.isUpdata;
    self.changeBtn.alpha        = self.isUpdata ? 1 : 0.5;
    self.name.text              = model.realName;
    self.companyName.text       = model.companyName;
    self.phone.text             = model.mobile;
    self.IDCard.text            = model.idcard;
}
- (IBAction)textFieldDidChange:(UITextField *)textField {
    DLog(@"%@",textField.text);
    //前17位必须为数字
    if (![textField.text isNumberString] && textField.text.length < 18) {
        if (textField.text.length == 1) {
            textField.text      = @"";
        }else{
            textField.text      = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - 1)];
        }
    }
    //第18位可以为数字 或者 X
    if (textField.text.length == 18) {
        NSString *lastString    = [textField.text substringWithRange:NSMakeRange(17, 1)];
        if (![lastString isNumberString] && ![lastString isEqualToString:@"x"] && ![lastString isEqualToString:@"X"]) {
            textField.text      = [textField.text substringWithRange:NSMakeRange(0, 17)];
        }else if ([lastString isEqualToString:@"x"]){
            NSString *idCard    = [textField.text substringWithRange:NSMakeRange(0, 17)];
            textField.text      = [NSString stringWithFormat:@"%@X",idCard];
        }
    }
    //首先 身份证号最多18位
    if (textField.text.length > 18) {
        textField.text          = [textField.text substringWithRange:NSMakeRange(0, 18)];
    }
}

@end
