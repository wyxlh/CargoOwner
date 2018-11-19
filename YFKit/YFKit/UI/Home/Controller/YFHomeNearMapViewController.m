//
//  YFHomeNearMapViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeNearMapViewController.h"
#import "YFHomeNearService.h"
#import "YFHomeNearViewModel.h"
#import "POIAnnotation.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YFHomeNearMapSiteView.h"
#import "CustomAnnotationView.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface YFHomeNearMapViewController () <MAMapViewDelegate, AMapSearchDelegate>{
    int lastContentOffset;
}
@property (nonatomic, strong) YFHomeNearMapSiteView *siteView;
/**地图*/
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAMapView *mapView;
/* 路线规划*/
@property (nonatomic, strong) AMapRoute *route;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

/**是否是路线规划*/
@property (nonatomic, assign) BOOL isFalg;
/*///目的地 POI ID  目的地POI类型编码*/
@property (nonatomic, copy, nullable) NSString *destinationId, *destinationtype;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
/**每一次加载的数量*/
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong, nullable) UIView *gestureView;//当地图 fream 从大到小的时候显示 反正隐藏
@property (nonatomic, strong, nullable) UIButton *lookBtn;//查看更多
@property (nonatomic, strong, nullable) NSMutableArray *nameArr, *poiAnnotationsOne;//附近服务点名称 和点的位置
@end

@implementation YFHomeNearMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.number                         = 1;
    _nameArr                            = [NSMutableArray new];
    [self.view addSubview:self.mapView];
    [self.mapView addSubview:self.lookBtn];
    
    self.search                         = [[AMapSearchAPI alloc] init];
    self.search.delegate                = self;
    [self searchPoiByCenterCoordinate:self.number];
    
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation         = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        //点击感叹号❗️
        POIAnnotation *poiAnnotation    = (POIAnnotation*)annotation;
        for (int i = 0; i < self.nameArr.count; i ++) {
            NSString *name              = [self.nameArr[i] safeJsonObjForKey:@"address"];
            if ([name isEqualToString:poiAnnotation.poi.address]) {
                [self showLineWithLineMessage:self.nameArr[i]];
            }
        }
    }
}

/**
 *  标注view的calloutview整体点击时调用此接口
 *
 *  @param mapView 地图的view
 *  @param view calloutView所属的annotationView
 */
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view{
    id<MAAnnotation> annotation         = view.annotation;
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        //点击
        POIAnnotation *poiAnnotation    = (POIAnnotation*)annotation;
    
        for (int i = 0; i < self.nameArr.count; i ++) {
            NSString *name              = [self.nameArr[i] safeJsonObjForKey:@"address"];
            
            if ([name isEqualToString:poiAnnotation.poi.address]) {
                [self showLineWithLineMessage:self.nameArr[i]];
            }
        }
    }
}
//AMapSMCalloutView
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
//        static NSString *poiIdentifier          = @"poiIdentifier";
//        MAPinAnnotationView *poiAnnotationView  = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
//        if (poiAnnotationView == nil)
//        {
//            poiAnnotationView                   = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
//        }
//
//        poiAnnotationView.canShowCallout        = YES;
//        poiAnnotationView.image                 = [UIImage imageNamed:[NSArray getNearMapLogo][self.index]];
//        //设置右侧图片
//        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn.width = rightBtn.height = 30;
//        [rightBtn setImage:[UIImage imageNamed:@"roadLine"] forState:0];
//        poiAnnotationView.rightCalloutAccessoryView = rightBtn;
//
//        return poiAnnotationView;
        static NSString *customReuseIndetifier = @"customReuseIndetifier";

        MAAnnotationView *extractedExpr = [mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        CustomAnnotationView *annotationView = (CustomAnnotationView*)extractedExpr;

        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.title = annotation.title;
            annotationView.detail = annotation.subtitle;
            WS(weakSelf)
            annotationView.drawLineBlock = ^(CGFloat latitude,CGFloat longitude){
                [weakSelf showCustomLineWithLatitude:latitude Longitude:longitude];
            };
        }

        annotationView.portrait = [UIImage imageNamed:[NSArray getNearMapLogo][self.index]];

        return annotationView;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]] && self.isFalg)
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

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashType = kMALineDashTypeSquare;
        polylineRenderer.strokeColor = NavColor;

        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];

        polylineRenderer.lineWidth = 8;

        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = NavColor;
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




#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    //    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations             = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    
    NSMutableArray *contentArr      = [NSMutableArray new];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict   = [NSMutableDictionary dictionary];
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        [dict safeSetObject:obj.name forKey:@"name"];
        [dict safeSetObject:obj.uid forKey:@"uid"];
        [dict safeSetObject:obj.typecode forKey:@"typecode"];
        [dict safeSetObject:obj.address forKey:@"address"];
        [dict safeSetObject:@(obj.distance) forKey:@"distance"];
        [dict safeSetObject:@(obj.location.latitude) forKey:@"latitude"];
        [dict safeSetObject:@(obj.location.longitude) forKey:@"longitude"];
        [contentArr addObject:dict];
    }];
    
    
    if (contentArr.count != 0) {
        [_nameArr addObjectsFromArray:contentArr];
        _siteView.dataArr = _nameArr;
//        [self.tableView reloadData];
    }
    if (_nameArr.count <= 20) {
        /* 将结果以annotation的形式加载到地图上. */
        [self.mapView addAnnotations:poiAnnotations];
        self.poiAnnotationsOne = poiAnnotations;
    }
//    self.viewModel.dataArr = nameArr;
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:YES];
        
    }
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

- (void)updateTotal
{
    self.totalCourse = self.route.paths.count;
}


#pragma mark - Utility

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(NSInteger)number
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.city                = self.city;
    request.keywords            = self.keywords;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.radius              = 5000;
    request.page                = number;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
}

/**
 用系统的冒泡 点击查询线路

 @param dict 点击这条的数据
 */
- (void)showLineWithLineMessage:(NSDictionary *)dict{
    [self.mapView removeAnnotations:self.poiAnnotationsOne];
    self.mapView.height             = self.view.height;
    
    [self clear];
    
    CGFloat latitude                = [[dict safeJsonObjForKey:@"latitude"] floatValue];
    CGFloat longitude               = [[dict safeJsonObjForKey:@"longitude"] floatValue];
    self.startCoordinate            = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.destinationCoordinate      = CLLocationCoordinate2DMake(latitude, longitude);
    self.isFalg                     = YES;
    
    self.destinationId              = [dict safeJsonObjForKey:@"uid"];
    self.destinationtype            = [dict safeJsonObjForKey:@"typecode"];
    
    [self.mapView removeAnnotation:self.startAnnotation];
    [self.mapView removeAnnotation:self.destinationAnnotation];
    [self addDefaultAnnotations];
    [self searchRoutePlanningDrive];
}

/**
 用自定义的 点击查看路线

 @param latitude 经度
 @param longitude 维度
 */
- (void)showCustomLineWithLatitude:(CGFloat )latitude Longitude:(CGFloat )longitude{
    [self.mapView removeAnnotations:self.poiAnnotationsOne];
    self.mapView.height             = self.view.height;
    self.isFalg                     = YES;
    [self clear];
    
    self.startCoordinate            = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.destinationCoordinate      = CLLocationCoordinate2DMake(latitude, longitude);
    
    [self.mapView removeAnnotation:self.startAnnotation];
    [self.mapView removeAnnotation:self.destinationAnnotation];
    [self addDefaultAnnotations];
    [self searchRoutePlanningDrive];
}

/**
 选择地址
 */
-(void)showSiteView{
    self.mapView.height                     = self.mapView.height - 300;
    self.siteView.hidden                    = self.gestureView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.siteView.backgroundColor       = [UIColor clearColor];
        self.siteView.y                     = -300;
    }];
}

#pragma mark siteView
-(YFHomeNearMapSiteView *)siteView{
    if (!_siteView) {
        _siteView                           = [[[NSBundle mainBundle] loadNibNamed:@"YFHomeNearMapSiteView" owner:nil options:nil] lastObject];
        _siteView.frame                     = CGRectMake(0, 0, ScreenWidth, self.view.height + 300);
        _siteView.dataArr                   = self.nameArr;
        @weakify(self)
        _siteView.callBackBlock             = ^(){
            @strongify(self)
            self.number ++;
            [self searchPoiByCenterCoordinate:self.number];
        };
        _siteView.dispperBlock              = ^{
            @strongify(self)
            self.mapView.height         = self.view.height;
        };

        _siteView.callLocationBlock         = ^(NSDictionary *dict){
            @strongify(self)
            [self showLineWithLineMessage:dict];
        };

        [self.view addSubview:_siteView];
    }
    return _siteView;
}

#pragma mark mapView
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView                            = [[MAMapView alloc]initWithFrame:self.view.bounds];
        _mapView.showsCompass               = NO;//是否显示指南针,
        _mapView.showsScale                 = NO;//是否显示比例尺
        _mapView.showsUserLocation          = YES;
        _mapView.zoomLevel                  = 15;//缩放级别
        _mapView.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate                   = self;
    }
    return _mapView;
}

#pragma mark lookBtn
-(UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn                            = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-NavHeight-50, ScreenWidth, 50)];
        [_lookBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        _lookBtn.backgroundColor            = UIColorFromRGB(0x0079E7);
        @weakify(self)
        [[_lookBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self showSiteView];
        }];
    }
    return _lookBtn;
}

- (UIView *)gestureView{
    if (!_gestureView) {
        _gestureView                        = [[UIView alloc]initWithFrame:CGRectMake(0, 300, ScreenWidth, 300)];
        _gestureView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap         = [[UITapGestureRecognizer alloc]init];
        [_gestureView addGestureRecognizer:tap];
        @weakify(self)
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            [self.siteView disappear];
            self.mapView.height             = self.view.height;
        }];
        [self.siteView addSubview:_gestureView];
        [self.siteView sendSubviewToBack:_gestureView];
    }
    return _gestureView;
}

#pragma mark 路线规划
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


/**
 do search
 */
- (void)searchRoutePlanningDrive
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.destinationId = self.destinationId;
    navi.destinationtype = self.destinationtype;
    //    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];

    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
}

@end

