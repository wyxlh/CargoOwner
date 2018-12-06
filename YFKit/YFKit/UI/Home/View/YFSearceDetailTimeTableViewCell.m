//
//  YFSearceDetailTimeTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearceDetailTimeTableViewCell.h"
#import "YFSearchDetailModel.h"

@implementation YFSearceDetailTimeTableViewCell

static NSString *const cellID = @"YFSearceDetailTimeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YFSearceDetailTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setIndex:(NSInteger)index {
    self.topLine.hidden         = index == 0;
    if (index == 0) {
        //第一行
        self.detailDes.textColor = self.time.textColor = self.title.textColor = UIColorFromRGB(0x0073E7);
        self.btnWidth.constant   = 72.0f;
        self.bottomCons.constant = -2;
        self.imgView.image       = [UIImage imageNamed:@"bluePoint"];
    }else{
        self.detailDes.textColor = self.time.textColor = self.title.textColor = UIColorFromRGB(0x909192);
        self.btnWidth.constant   = CGFLOAT_MIN;
        self.bottomCons.constant = -6;
        self.imgView.image       = [UIImage imageNamed:@"AshPoint"];
    }
}

- (void)setModel:(detailsModel *)model {
    //只有订单所有者才能查看签收单
    if (([model.status containsString:@"签收"] || [model.describe containsString:@"签收"])&& [self.creator isEqualToString:[UserData userInfo].userId]) {
        self.lookBtn.hidden      = NO;
        self.btnWidth.constant   = 72.0f;
    }else {
        self.lookBtn.hidden      = YES;
        self.btnWidth.constant   = CGFLOAT_MIN;
    }
    self.title.text              = model.status;
    self.detailDes.text          = model.describe;
    self.time.text               = model.dataTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
