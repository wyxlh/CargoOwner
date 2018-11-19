//
//  YFDriverDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFDriverDetailViewController.h"

@interface YFDriverDetailViewController ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapBgView;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *lines;
//标记开始于结束的位置
@property (nonatomic, strong) NSMutableArray *annotations;
/**
 开始结束和货车图标
 */
@property (nonatomic, strong) NSArray *imgArr;
@end

@implementation YFDriverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLines];
    [self initAnnotations];
    [self setUI];
}

-(void)setUI{
    self.title                              = @"司机详情";
    SKViewsBorder(self.mapBgView, 3, 0, NavColor);
    self.imgArr                             = @[@"Originating",@"BidPeople",@"End"];
    [self.mapBgView addSubview:self.mapView];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.mapView addOverlays:self.lines];
}

#pragma mark - Initialization
- (void)initLines {
    NSMutableArray *arr                      = [NSMutableArray array];
    
    //line 1
    CLLocationCoordinate2D line1Points[2];
    line1Points[0].latitude                  = 39.925539;
    line1Points[0].longitude                 = 116.279037;
    
    line1Points[1].latitude                  = 39.925539;
    line1Points[1].longitude                 = 116.520285;
    
    MAPolyline *line1                        = [MAPolyline polylineWithCoordinates:line1Points count:1];
    [arr addObject:line1];
    
    
    //line 2
    CLLocationCoordinate2D line2Points[5];
    line2Points[0].latitude                  = 31.238068;
    line2Points[0].longitude                 = 121.501654;
    
    line2Points[1].latitude                  = 30.28;
    line2Points[1].longitude                 = 120.15;
    
    line2Points[2].latitude                  = 30.86;
    line2Points[2].longitude                 = 120.1;
    
    MAPolyline *line2                        = [MAPolyline polylineWithCoordinates:line2Points count:3];

    [arr addObject:line2];
    
    self.lines = [NSArray arrayWithArray:arr];
}

#pragma mark - Initialization
- (void)initAnnotations
{
    self.annotations                         = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[10]   = {
        {31.238068, 121.501654},
        {30.28, 120.15},
        {30.86, 120.1},};
    
    for (int i = 0; i < 3; ++i)
    {
        MAPointAnnotation *a1                = [[MAPointAnnotation alloc] init];
        a1.coordinate                        = coordinates[i];
        a1.title                             = [NSString stringWithFormat:@"anno: %d", i];
        [self.annotations addObject:a1];
    }
}

-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView                            = [[MAMapView alloc]initWithFrame:self.mapBgView.bounds];
        _mapView.showsCompass               = NO;//是否显示指南针,
        _mapView.showsScale                 = NO;//是否显示比例尺
//        _mapView.centerCoordinate           = CLLocationCoordinate2DMake(31.238068, 121.501654);
        _mapView.zoomLevel                  = 7;//缩放级别
        _mapView.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate                   = self;
    }
    return _mapView;
}


#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.strokeColor         = [UIColor blueColor];
        polylineRenderer.lineWidth           = 3.f;
        
        NSInteger index                      = [self.lines indexOfObject:overlay];
        if(index == 0) {
            polylineRenderer.lineCapType     = kCGLineCapSquare;
            polylineRenderer.lineDashType    = kMALineDashTypeSquare;
        } else {
            polylineRenderer.lineDashType    = kMALineDashTypeNone;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - Map Delegate

/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier       = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView         = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView                          = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        annotationView.pinColor                     = [self.annotations indexOfObject:annotation] % 3;
        annotationView.image                        = [UIImage imageNamed:self.imgArr[[self.annotations indexOfObject:annotation]]];
        return annotationView;
    }
    
    return nil;
}


@end
