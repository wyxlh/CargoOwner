//
//  YFSpecialDetailAddressTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/9/18.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialDetailAddressTableViewCell.h"
#import "YFSpecialLineListModel.h"
#import "YFInverGeoModel.h"
#import "YFMileageComputeViewController.h"

@implementation YFSpecialDetailAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YFSpecialLineListModel *)model{
    _model                          = model;
    self.startAddress.text          = [NSString getNullOrNoNull:model.sendSite];
    self.endAddress.text            = [NSString getNullOrNoNull:model.recvSite];
    self.startDetailAddress.text    = [NSString getNullOrNoNull:model.consignerAddr];
    self.endDetailAddress.text      = [NSString getNullOrNoNull:model.receiverAddr];
    [self onlyGetLatitudeAndLongitude];
}

/**
 如果后台有返回经纬度 就直接使用经纬度
 */
- (void)onlyGetLatitudeAndLongitude{
    [[YFInverGeoModel sharedYFInverGeoModel] getTwoPointsDistanceWithStartLatitude:self.model.consignerLatitude startLongitude:self.model.consignerLongitude endLatitude:self.model.receiverLatitude endLongitude:self.model.receiverLongitude strategy:2];
    WS(weakSelf)
    [YFInverGeoModel sharedYFInverGeoModel].twoPointDistanceBlock = ^(CGFloat distance){
        weakSelf.distance.text = [NSString stringWithFormat:@"距离%.2f公里",distance];
    };
    
}

- (IBAction)clickDistance:(id)sender {
    YFMileageComputeViewController *mileage = [YFMileageComputeViewController new];
    mileage.startCoordinate                 = CLLocationCoordinate2DMake(self.model.consignerLatitude, self.model.consignerLongitude);
    mileage.destinationCoordinate           = CLLocationCoordinate2DMake(self.model.receiverLatitude, self.model.receiverLongitude);
    mileage.startAddress                    = [NSString stringWithFormat:@"%@",[NSString getNullOrNoNull:self.model.sendSite]];
    mileage.endAddress                      = [NSString getNullOrNoNull:self.model.recvSite];
    [self.superVC.navigationController pushViewController:mileage animated:YES];
}

@end
