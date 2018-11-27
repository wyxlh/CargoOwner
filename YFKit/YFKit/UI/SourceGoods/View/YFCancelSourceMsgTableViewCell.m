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
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "GeocodeAnnotation.h"

@interface YFCancelSourceMsgTableViewCell()<AMapSearchDelegate>{
    
}
@property (nonatomic, assign) CGFloat Latitude;//以前的老单子, 需要把位置转为经纬度
@property (nonatomic, assign) CGFloat Longitude;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation YFCancelSourceMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
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
    
    //距离多少米
    if (sourceModel.endSiteLatitude == 0 || sourceModel.startSiteLatitude == 0) {
        [self getLatitudeAndLongitude];
    }else{
        [self onlyGetLatitudeAndLongitudeWithSource];
    }
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

- (void)getLatitudeAndLongitude{
    if (_sourceModel) {
        //出发地
        YFInverGeoModel  *geoStart                  = [[YFInverGeoModel alloc]init];
        [geoStart getLatitudeAndlongitudeWithAddress:self.sourceModel.startSite];
        WS(weakSelf)
        geoStart.latitudeAndlongitudeBlock          = ^(CGFloat Latitude, CGFloat Longitude){
            weakSelf.Latitude                       = Latitude;
            weakSelf.Longitude                      = Longitude;
            //目的地
            [weakSelf getLatitudeAndlongitudeWithAddress:weakSelf.sourceModel.endSite];
        };
    }else{
        //出发地
        YFInverGeoModel  *geoStart                  = [[YFInverGeoModel alloc]init];
        [geoStart getLatitudeAndlongitudeWithAddress:self.orderModel.startSite];
        WS(weakSelf)
        geoStart.latitudeAndlongitudeBlock          = ^(CGFloat Latitude, CGFloat Longitude){
            weakSelf.Latitude                       = Latitude;
            weakSelf.Longitude                      = Longitude;
            //目的地
            [weakSelf getLatitudeAndlongitudeWithAddress:weakSelf.orderModel.endSite];
        };
    }
    
    
}
/**
 返回经纬度
 
 @param address address description
 */
- (void)getLatitudeAndlongitudeWithAddress:(NSString *)address{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    
    [self.search AMapGeocodeSearch:geo];
}
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    WS(weakSelf)
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        DLog(@"%f",geocodeAnnotation.geocode.location.latitude);
        [[YFInverGeoModel sharedYFInverGeoModel] getTwoPointsDistanceWithStartLatitude:self.Latitude startLongitude:self.Longitude endLatitude:geocodeAnnotation.geocode.location.latitude endLongitude:geocodeAnnotation.geocode.location.longitude strategy:2];
        
        [YFInverGeoModel sharedYFInverGeoModel].twoPointDistanceBlock = ^(CGFloat distance){
            weakSelf.distance.text = [NSString stringWithFormat:@"距离%.2f公里",distance];
        };
        [annotations addObject:geocodeAnnotation];
    }];
    
}

@end
