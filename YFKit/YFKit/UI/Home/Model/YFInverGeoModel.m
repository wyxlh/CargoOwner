//
//  YFInverGeoModel.m
//  YFKit
//
//  Created by 王宇 on 2018/6/27.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFInverGeoModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ReGeocodeAnnotation.h"
#import "GeocodeAnnotation.h"
#import "MANaviRoute.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";

@interface YFInverGeoModel()<AMapSearchDelegate>
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapRoute *route;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;

@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isSearchFromDragging;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;
@end

@implementation YFInverGeoModel
SKSingleM(YFInverGeoModel)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
    }
    return self;
}

/**
 返回地址 逆地理编码
 @param latitude latitude description
 @param longitude longitude description
 */
- (void)getDriverAddressWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
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


#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
//    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil && _isSearchFromDragging == NO)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        DLog(@"%@",reGeocodeAnnotation.reGeocode.formattedAddress);
        !self.driverAddressBlock ? : self.driverAddressBlock(reGeocodeAnnotation.reGeocode.formattedAddress);
        
    }
    else /* from drag search, update address */
    {
        [self.annotation setAMapReGeocode:response.regeocode];
    }
}

/*获取经纬度*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        DLog(@"%f",geocodeAnnotation.geocode.location.latitude);
        !self.latitudeAndlongitudeBlock ? : self.latitudeAndlongitudeBlock (geocodeAnnotation.geocode.location.latitude, geocodeAnnotation.geocode.location.longitude);
        [annotations addObject:geocodeAnnotation];
    }];
    
}

#pragma mark 计算两个点之间的线路距离
- (void)getTwoPointsDistanceWithStartLatitude:(CGFloat)startLatitude startLongitude:(CGFloat)startLongitude endLatitude:(CGFloat)endLatitude endLongitude:(CGFloat)endLongitude strategy:(NSInteger)strategy{
    self.startCoordinate                 = CLLocationCoordinate2DMake(startLatitude, startLongitude);
    self.destinationCoordinate           = CLLocationCoordinate2DMake(endLatitude, endLongitude);
    [self addDefaultAnnotations];
    [self searchRoutePlanningDrive:strategy];
}
- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    self.destinationAnnotation = destinationAnnotation;
    
}

- (void)searchRoutePlanningDrive:(NSInteger)strategy
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    //    navi.destinationId = @"B0FFH7VSWU";
    //    navi.destinationtype = @"070500";
    // 0，速度优先（时间)；1，费用优先（不走收费路段的最快道路）；2，距离优先
    navi.strategy = strategy;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    [GiFHUD dismiss];
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    NSString *distance = [NSString stringWithFormat:@"%ld",[[self.route.paths firstObject] distance]];
    DLog(@"%@",distance);
    !self.twoPointDistanceBlock ? : self.twoPointDistanceBlock([distance doubleValue]/1000);

}


@end

