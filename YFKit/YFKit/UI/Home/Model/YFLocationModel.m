//
//  YFLocationModel.m
//  YFKit
//
//  Created by 王宇 on 2018/6/14.
//  Copyright © 2018年 wy. All rights reserved.
//
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

#import "YFLocationModel.h"
#import <CoreLocation/CoreLocation.h>

@interface YFLocationModel () <AMapLocationManagerDelegate, AMapSearchDelegate>

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation YFLocationModel
SKSingleM(YFLocationModel)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initCompleteBlock];
        [self configLocationManager];
        
    }
    return self;
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
//    self.search = [[AMapSearchAPI alloc] init];
//
//    self.search.delegate = self;
}

- (void)reGeocodeAction
{
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction
{
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    WS(weakSelf)
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //修改label显示内容
        if (regeocode)
        {
            DLog(@"%@",[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]);
           
            !weakSelf.backUserAddressDetailBlock ? : weakSelf.backUserAddressDetailBlock(regeocode,location.coordinate.latitude,location.coordinate.longitude);
        }
        else
        {
            DLog(@"%@",[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
            
            !weakSelf.backUserLocationBlock ? : weakSelf.backUserLocationBlock (location.coordinate.latitude,location.coordinate.longitude);
        }
    };
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}

#pragma 位置转经纬度
-(void)GeoCoding{
    [self tapAction:@"上海市普陀区同普路靠近金环商务花园南园"];
    
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        DLog(@"%f,--%f",obj.location.latitude,obj.location.longitude);
    }];
    
    if (annotations.count == 1)
    {
    }
    else
    {
        
    }
    
}

#pragma mark - HandleAction
- (void)tapAction:(NSString *)choseAddress
{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address =choseAddress;
    [self.search AMapGeocodeSearch:geo];
}

#pragma mark - Utility

- (void)gotoDetailForGeocode:(AMapGeocode *)geocode
{
    if (geocode != nil)
    {
        DLog(@"%@",geocode);
    }
}

#pragma mark 是否开始定位权限
+ (BOOL)openLocationService
{
    BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOPen = YES;
    }
    return isOPen;
}


@end
