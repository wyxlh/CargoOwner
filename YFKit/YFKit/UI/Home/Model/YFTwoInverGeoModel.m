//
//  YFTwoInverGeoModel.m
//  YFKit
//
//  Created by 王宇 on 2018/9/20.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFTwoInverGeoModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ReGeocodeAnnotation.h"
#import "GeocodeAnnotation.h"
#import "MANaviRoute.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";

@interface YFTwoInverGeoModel()<AMapSearchDelegate>
@property (nonatomic, strong) AMapSearchAPI *search;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;

@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isSearchFromDragging;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;

@end

@implementation YFTwoInverGeoModel
SKSingleM(YFTwoInverGeoModel)
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

@end
