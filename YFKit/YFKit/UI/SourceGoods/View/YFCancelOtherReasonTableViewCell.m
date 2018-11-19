//
//  YFCancelOtherReasonTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFCancelOtherReasonTableViewCell.h"

@implementation YFCancelOtherReasonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
   SKViewsBorder(self.textView, 2, 0.6, UIColorFromRGB(0xEDECED));
    [[self.textView rac_textSignal] subscribeNext:^(id x) {
        NSString *text = [NSString stringWithFormat:@"%@",x];
        if ([NSString isBlankString:text]) {
            self.placeholder.hidden = NO;
        }else{
            self.placeholder.hidden = YES;
        }
        //最多100
        if (text.length >100) {
            self.textView.text = [text substringWithRange:NSMakeRange(0, 100)];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
