//
//  YFCancelSourceMsgTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/5.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFCancelSourceMsgTableViewCell.h"
#import "YFReleseDetailModel.h"
#import "YFInverGeoModel.h"
#import "YFOrderDetailModel.h"

@implementation YFCancelSourceMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 货源

 @param sourceModel sourceModel description
 */
- (void)setSourceModel:(YFReleseDetailModel *)sourceModel{
    _sourceModel                    = sourceModel;
    self.orderNum.text              = [NSString stringWithFormat:@"货源号: %@",sourceModel.supplyGoodsId];
    NSArray *yearArr                = [sourceModel.publishedTime componentsSeparatedByString:@" "];
    
    NSArray *hourArr                = [[yearArr lastObject] componentsSeparatedByString:@":"];
    NSString *timeStr               = [NSString stringWithFormat:@"%@ %@:%@",[yearArr firstObject],[hourArr firstObject], hourArr[1]];
    self.time.text                  = timeStr;
    self.startAddress.text          = [NSString getCityName:sourceModel.startSite];
    self.endAddress.text            = [NSString getCityName:sourceModel.endSite];
    if (![NSString isBlankString:sourceModel.startAddress]) {
        self.startDetail.text       = [NSString getNullOrNoNull:sourceModel.startAddress];
    }else{
        self.startDetail.text       = [NSString getNullOrNoNull:sourceModel.startSite];
    }
    
    if (![NSString isBlankString:sourceModel.endAddress]) {
        self.endDetail.text         = [NSString getNullOrNoNull:sourceModel.endAddress];
    }else{
        self.endDetail.text         = [NSString getNullOrNoNull:sourceModel.endSite];
    }
    [self onlyGetLatitudeAndLongitudeWithSource];
}

/**
 订单

 @param orderModel orderModel description
 */
- (void)setOrderModel:(YFOrderDetailModel *)orderModel{
    _orderModel                      = orderModel;
    self.orderNum.text               = [NSString stringWithFormat:@"订单号 : %@",orderModel.taskId];
    self.time.text                   = [NSString getNullOrNoNull:orderModel.creatorTime];
    self.startAddress.text           = [NSString getCityName:orderModel.startSite];
    self.endAddress.text             = [NSString getCityName:orderModel.endSite];
    if (![NSString isBlankString:orderModel.startAddress]) {
        self.startDetail.text       = [NSString getNullOrNoNull:orderModel.startAddress];
    }else{
        self.startDetail.text       = [NSString getNullOrNoNull:orderModel.startSite];
    }
    if (![NSString isBlankString:orderModel.endAddress]) {
        self.endDetail.text         = [NSString getNullOrNoNull:orderModel.endAddress];
    }else{
        self.endDetail.text         = [NSString getNullOrNoNull:orderModel.endSite];
    }
    
    [self onlyGetLatitudeAndLongitudeWithOrder];
}

/**
 如果后台有返回经纬度 就直接使用经纬度
 */
- (void)onlyGetLatitudeAndLongitudeWithSource{
    [[YFInverGeoModel sharedYFInverGeoModel] getTwoPointsDistanceWithStartLatitude:self.sourceModel.startSiteLatitude startLongitude:self.sourceModel.startSiteLongitude endLatitude:self.sourceModel.endSiteLatitude endLongitude:self.sourceModel.endSiteLongitude strategy:2];
    WS(weakSelf)
    [YFInverGeoModel sharedYFInverGeoModel].twoPointDistanceBlock = ^(CGFloat distance){
        weakSelf.distance.text = [NSString stringWithFormat:@"距离%.2f公里",distance];
    };
    
}

- (void)onlyGetLatitudeAndLongitudeWithOrder{
    [[YFInverGeoModel sharedYFInverGeoModel] getTwoPointsDistanceWithStartLatitude:self.orderModel.startSiteLatitude startLongitude:self.orderModel.startSiteLongitude endLatitude:self.orderModel.endSiteLatitude endLongitude:self.orderModel.endSiteLongitude strategy:2];
    WS(weakSelf)
    [YFInverGeoModel sharedYFInverGeoModel].twoPointDistanceBlock = ^(CGFloat distance){
        weakSelf.distance.text = [NSString stringWithFormat:@"距离%.2f公里",distance];
    };
    
}

@end
