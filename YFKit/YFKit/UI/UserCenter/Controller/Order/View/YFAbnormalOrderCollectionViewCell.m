//
//  YFAbnormalOrderCollectionViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/7/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAbnormalOrderCollectionViewCell.h"
#import "YFLookSignModel.h"
@implementation YFAbnormalOrderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YFLookSignModel *)model{
    NSArray *errorArr                  = [model.opErrType componentsSeparatedByString:@","];
    NSMutableArray *errorStrArr        = [NSMutableArray new];
    for (NSString *errorStr in errorArr) {
        if ([errorStr integerValue] == 1) {
            [errorStrArr addObject:@"货损"];
        }else if ([errorStr integerValue] == 2){
            [errorStrArr addObject:@"少件"];
        }else if ([errorStr integerValue] == 3){
            [errorStrArr addObject:@"晚点"];
        }
    }
    self.abnormalType.text             = [NSString stringWithFormat:@"异常签收 : %@",[errorStrArr componentsJoinedByString:@","]];
    self.abnormalExplain.text          = [NSString stringWithFormat:@"异常说明 : %@",[NSString getNullOrNoNull:model.opRemark]];
}

@end
