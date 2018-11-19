//
//  YFUserItemCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/7/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserItemCollectionViewCell.h"

@implementation YFUserItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict{
    self.title.text = [dict safeJsonObjForKey:@"name"];
    self.logo.image = [UIImage imageNamed:[dict safeJsonObjForKey:@"imgName"]];
}
@end
