//
//  YFUserCenterCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserCenterCollectionViewCell.h"

@implementation YFUserCenterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelNum.adjustsFontSizeToFitWidth = YES;
    SKViewsBorder(self.cancelNum, 7.5, 0, NavColor);
}

-(void)setDict:(NSDictionary *)dict{
    self.title.text = [dict safeJsonObjForKey:@"name"];
    self.logo.image = [UIImage imageNamed:[dict safeJsonObjForKey:@"imgName"]];
    self.cancelNum.text = [NSString stringWithFormat:@"%ld",(long)[YFOfferData shareInstace].cancelOrderSuccessCount];
}

@end
