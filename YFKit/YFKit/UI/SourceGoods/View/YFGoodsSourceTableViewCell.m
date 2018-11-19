//
//  YFGoodsSourceTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsSourceTableViewCell.h"
#import "YFReleseDetailModel.h"
#import "YFMileageComputeViewController.h"
#import "YFInverGeoModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "GeocodeAnnotation.h"

@interface YFGoodsSourceTableViewCell()<AMapSearchDelegate>{

}
@property (nonatomic, assign) CGFloat Latitude;//以前的老单子, 需要把位置转为经纬度
@property (nonatomic, assign) CGFloat Longitude;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation YFGoodsSourceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.orderNum.adjustsFontSizeToFitWidth = YES;
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFReleseDetailModel *)model{
    
    _model                          = model;
    self.time.text                  = [NSString getNullOrNoNull:model.publishedTime];
    self.startAddress.text          = [NSString getCityName:model.startSite];
    self.endAddress.text            = [NSString getCityName:model.endSite];
    if (![NSString isBlankString:model.startAddress]) {
        self.startDetail.text       = [NSString getNullOrNoNull:model.startAddress];
    }else{
        self.startDetail.text       = [NSString getNullOrNoNull:model.startSite];
    }
    
    if (![NSString isBlankString:model.endAddress]) {
        self.endDetail.text         = [NSString getNullOrNoNull:model.endAddress];
    }else{
        self.endDetail.text         = [NSString getNullOrNoNull:model.endSite];
    }
    
    self.carMsg.text                = [NSString stringWithFormat:@"车型车长 : %@ %@",[NSString getNullOrNoNull:model.vehicleCarLength],[NSString getNullOrNoNull:model.vehicleCarType]];
    
    self.Etime.text                 = [NSString stringWithFormat:@"装货时间: %@",[NSString getGoodsDetailTime:model.pickGoodsDate WithStartTime:model.pickGoodsDateStart WithEndTime:model.pickGoodsDateEnd]];
    if (model.goodsItem.count > 0) {
        self.orderNum.text          = [NSString stringWithFormat:@"货源号: %@",[model.goodsItem[0] supplyGoodsId]];
        NSString *goodsMsg          = [NSString getGoodsName:[model.goodsItem[0] goodsName] GoodsWeight:[model.goodsItem[0] goodsWeight] GoodsVolume:[model.goodsItem[0] goodsVolume] GoodsNum:[model.goodsItem[0] goodsCount]];
        self.goodVolume.text        = [NSString stringWithFormat:@"货品信息: %@",goodsMsg];
        
    }else{
        self.orderNum.text          = @"货源号: ";
        self.goodVolume.text        = @"货品信息: ";
    }
    
    if ([NSString isBlankString:model.expectPrice]) {
        self.wantFree.text          = @"期望运费: 无";
    }else{
        self.wantFree.text          = [NSString stringWithFormat:@"期望运费: %@元",model.expectPrice];
    }
    
    if ([NSString isBlankString:model.driverName]) {
        self.driver.text            = @"指定司机: ";
    }else{
        self.driver.text            = [NSString stringWithFormat:@"指定司机: %@",model.driverName];
    }
    //其他要求
    if ([NSString isBlankString:model.unloadWay] && [NSString isBlankString:model.remark]) {
        self.more.text              = @"暂无";
    }else{
        self.more.text                  = [NSString stringWithFormat:@"%@ %@",[NSString getNullOrNoNull:model.unloadWay],[NSString getNullOrNoNull:model.remark]];
    }
    
    //距离多少米
    if (model.startSiteLatitude == 0) {
        [self getLatitudeAndLongitude];
    }else{
        [self onlyGetLatitudeAndLongitude];
    }

     
}

/**
 如果后台有返回经纬度 就直接使用经纬度
 */
- (void)onlyGetLatitudeAndLongitude{
    [[YFInverGeoModel sharedYFInverGeoModel] getTwoPointsDistanceWithStartLatitude:self.model.startSiteLatitude startLongitude:self.model.startSiteLongitude endLatitude:self.model.endSiteLatitude endLongitude:self.model.endSiteLongitude strategy:2];
    WS(weakSelf)
    [YFInverGeoModel sharedYFInverGeoModel].twoPointDistanceBlock = ^(CGFloat distance){
        weakSelf.distance.text = [NSString stringWithFormat:@"距离%.2f公里",distance];
    };

}


- (IBAction)clickLineRoad:(id)sender {
    [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:self.model.startSite];
    WS(weakSelf)
    [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
        YFMileageComputeViewController *mileage = [YFMileageComputeViewController new];
        mileage.startCoordinate                 = CLLocationCoordinate2DMake(latitude, longitude);
        mileage.startAddress                    = weakSelf.model.startSite;
        mileage.endAddress                      = weakSelf.model.endSite;
        [weakSelf.superVC.navigationController pushViewController:mileage animated:YES];
    };
}

- (void)getLatitudeAndLongitude{
    //出发地
    YFInverGeoModel  *geoStart                  = [[YFInverGeoModel alloc]init];
    [geoStart getLatitudeAndlongitudeWithAddress:self.model.startSite];
    WS(weakSelf)
    geoStart.latitudeAndlongitudeBlock          = ^(CGFloat Latitude, CGFloat Longitude){
        weakSelf.Latitude                       = Latitude;
        weakSelf.Longitude                      = Longitude;
        //目的地
        [weakSelf getLatitudeAndlongitudeWithAddress:weakSelf.model.endSite];
    };
    
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
