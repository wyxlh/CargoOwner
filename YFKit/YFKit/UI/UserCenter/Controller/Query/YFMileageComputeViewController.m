//
//  YFMileageComputeViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/7/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFMileageComputeViewController.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YFInverGeoModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "GeocodeAnnotation.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface YFMileageComputeViewController ()<MAMapViewDelegate, AMapSearchDelegate>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleArray;
@property (nonatomic, strong) NSArray *distanceArr;//距离 lable 数组
@property (weak, nonatomic) IBOutlet UILabel *minDistanceLbl;//距离最短
@property (weak, nonatomic) IBOutlet UILabel *minTime;//时间最短
@property (weak, nonatomic) IBOutlet UILabel *minMoney;//费用最少
@property (weak, nonatomic) IBOutlet UIView *mapBgView;

/* 路径规划类型 */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) AMapRoute *route;
/**
 距离最短的距离  时间最短的距离 费用最少的距离
 */
//@property (nonatomic, assign) NSInteger minDistance,timeDistance,moneyDistance;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

/**
 判断是不是刚进这个页面 距离最短为2
 */
@property (nonatomic, assign)  NSInteger isFirstNum;
@end

@implementation YFMileageComputeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                          = [NSString stringWithFormat:@"%@→%@",[NSString getCityName:self.startAddress],[NSString getCityName:self.endAddress]];
    self.isFirstNum                     = 2;
    self.distanceArr                    = @[self.minTime,self.minMoney,self.minDistanceLbl];
    if (self.destinationCoordinate.latitude != 0) {
        [self.mapBgView addSubview:self.mapView];
        [self showRoutePlanningDrive];
        return;
    }
    //目的地
    YFInverGeoModel *endGeo             = [[YFInverGeoModel alloc]init];
    [endGeo getLatitudeAndlongitudeWithAddress:self.endAddress];
    @weakify(self)
    endGeo.latitudeAndlongitudeBlock    = ^(CGFloat latitude, CGFloat longitude){
        @strongify(self)
        //得到目的地经纬度
        self.destinationCoordinate      = CLLocationCoordinate2DMake(latitude, longitude);
        [self.mapBgView addSubview:self.mapView];
        //查询路线
        [self showRoutePlanningDrive];
    };
    
}

#pragma mark mapView
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.mapBgView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        _mapView.showsCompass       = NO;//是否显示指南针,
        _mapView.showsScale         = NO;//是否显示比例尺
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    return _mapView;
}

#pragma mark 查询线路
- (void)showRoutePlanningDrive{
    [self addDefaultAnnotations];
    [self searchRoutePlanningDrive:self.isFirstNum];
    //因为老是划线错误 因此这个方法延迟调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self searchRoutePlanningDrive:1];
        [self searchRoutePlanningDrive:0];
    });
}

/**
 出发地址
 */
- (IBAction)startBtnClick:(id)sender {
}

/**
 目的地
 */
- (IBAction)endBtnClick:(id)sender {
}

/**
 0，速度优先（时间)；1，费用优先（不走收费路段的最快道路）；2，距离优先0078E5 999999
 */
- (IBAction)clickBtn:(UIButton *)sender {
    DLog(@"------%ld",sender.tag);
    [GiFHUD showWithOverlay];
    //上面的描述 颜色的变化
    for (UILabel *lbl in self.titleArray) {
        lbl.textColor = UIColorFromRGB(0x999999);
    }
    UILabel *lbl = self.titleArray[sender.tag];
    lbl.textColor = UIColorFromRGB(0x0078E5);
    //具体的距离 颜色的变化
    for (UILabel *lbl in self.distanceArr) {
        lbl.textColor = UIColorFromRGB(0x666666);
    }
    
    UILabel *dislbl = self.distanceArr[sender.tag];
    dislbl.textColor = UIColorFromRGB(0x0078E5);

    self.isFirstNum = 2;
    [self clear];
    [self searchRoutePlanningDrive:sender.tag];
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}


/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    DLog(@"%ld",self.currentCourse);
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

#pragma mark - do search
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
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashType = kMALineDashTypeSquare;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
//    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
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
    [self updateTotal];
    DLog(@"%@------%ld",[[self.route.paths firstObject] strategy],[[self.route.paths firstObject] distance]);
    
    NSString *distance = [NSString stringWithFormat:@"%ld",[[self.route.paths firstObject] distance]];
    
    if ([[[self.route.paths firstObject] strategy] containsString:@"距离最短"]) {
        //距离最短
        self.minDistanceLbl.text = [NSString stringWithFormat:@"%.2f公里",[distance doubleValue]/1000];
        
    }else if ([[[self.route.paths firstObject] strategy] containsString:@"费用最低"]){
        //费用最低
        self.minMoney.text = [NSString stringWithFormat:@"%.2f公里",[distance doubleValue]/1000];
        
    }else if ([[[self.route.paths firstObject] strategy] containsString:@"速度最快"]){
        //速度最快
        self.minTime.text = [NSString stringWithFormat:@"%.2f公里",[distance doubleValue]/1000];
        
    }
    
    self.currentCourse = 0;
    
    if (response.count > 0 && self.isFirstNum == 2)
    {
        [self presentCurrentCourse];
        self.isFirstNum ++;
    }
}


@end
