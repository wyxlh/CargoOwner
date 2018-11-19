//
//  YFDriverMapDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/21.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFDriverMapDetailViewController.h"

@interface YFDriverMapDetailViewController ()<MAMapViewDelegate>
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

@implementation YFDriverMapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                               = @"当前位置";
    [self setUI];
}

-(void)setUI{
    if (self.TrajectoryArr.count == 0) {
        [self.mapBgView addSubview:self.mapView];
        return;
    }
    NSMutableArray *arr                      = [NSMutableArray array];
    
    //line 1  这个是为了花直线 如果不设置这个就会变成虚线 我也不知道为啥
    CLLocationCoordinate2D line1Points[2];
    line1Points[0].latitude                  = 39.925539;
    line1Points[0].longitude                 = 116.279037;
    
    line1Points[1].latitude                  = 39.925539;
    line1Points[1].longitude                 = 116.520285;
    
    MAPolyline *line1                        = [MAPolyline polylineWithCoordinates:line1Points count:1];
    [arr addObject:line1];
    
    
    //line 2
    CLLocationCoordinate2D line2Points[self.TrajectoryArr.count];
    
    for (int i = 0; i < self.TrajectoryArr.count; i ++) {
        DLog(@"%f ---%f",[[self.TrajectoryArr[i] lat] floatValue],[[self.TrajectoryArr[i] lon] floatValue]);
        line2Points[i].latitude              = [[self.TrajectoryArr[i] lat] floatValue];
        line2Points[i].longitude             = [[self.TrajectoryArr[i] lon] floatValue];
    }
    
    MAPolyline *line2                        = [MAPolyline polylineWithCoordinates:line2Points count:self.TrajectoryArr.count];
    
    [arr addObject:line2];
    
    self.lines = [NSArray arrayWithArray:arr];
    
    //获取图片如果说没有司机的位置 说明已经完成了 就不需要司机位置信息
    if (self.location) {
        self.imgArr                             = [NSArray getDriverLogo];
    }else{
        self.imgArr                             = [NSArray getOnlyRoadLogo];
    }
    
    NSMutableArray *locationArr = [NSMutableArray new];
    for (int i = 0; i < 2; i ++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (i == 0) {
            //取第一个 为开始地址
            NSString *lat = [NSString stringWithFormat:@"%f",[[[self.TrajectoryArr firstObject] lat] floatValue]];
            NSString *lon = [NSString stringWithFormat:@"%f",[[[self.TrajectoryArr firstObject] lon] floatValue]];
            [dict safeSetObject:lat forKey:@"lat"];
            [dict safeSetObject:lon forKey:@"lon"];
        }else if(i == 1){
            //货主位置
            if (self.location) {
                NSString *lat = [NSString stringWithFormat:@"%f",[self.location.lat floatValue]];
                NSString *lon = [NSString stringWithFormat:@"%f",[self.location.lon floatValue]];
                [dict safeSetObject:lat forKey:@"lat"];
                [dict safeSetObject:lon forKey:@"lon"];
            }else{
                NSString *lat = [NSString stringWithFormat:@"%f",[[[self.TrajectoryArr lastObject] lat] floatValue]];
                NSString *lon = [NSString stringWithFormat:@"%f",[[[self.TrajectoryArr lastObject] lon] floatValue]];
                [dict safeSetObject:lat forKey:@"lat"];
                [dict safeSetObject:lon forKey:@"lon"];
            }
        }
        [locationArr addObject:dict];
    }
    
    [self initAnnotations:locationArr];
    
    [self.mapBgView addSubview:self.mapView];
    [self.mapView addOverlays:self.lines];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations animated:YES];
}

#pragma mark - Initialization 图片
- (void)initAnnotations:(NSMutableArray *)location
{
    self.annotations                         = [NSMutableArray array];
    
    //    CLLocationCoordinate2D coordinates[10]   = {
    //        {31.238068, 121.501654},
    //        {30.28, 120.15},
    //        {30.86, 120.1},};
    //    CLLocationCoordinate2D coordinates[2]   = {
    //        {31.238068, 121.501654},
    //        {30.28, 120.15},
    //        {30.86, 120.1},};
    
    CLLocationCoordinate2D coordinates[location.count];
    for (int i = 0; i < location.count; i++) {
        NSString *latitude = [location[i] safeJsonObjForKey:@"lat"];
        NSString *longitude = [location[i] safeJsonObjForKey:@"lon"];
        coordinates[i] = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    }
    
    for (int i = 0; i < location.count; ++i)
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
        _mapView.zoomLevel                  = 13;//缩放级别
        _mapView.rotateCameraEnabled=NO;
        _mapView.zoomingInPivotsAroundAnchorPoint=YES;
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
        //                annotationView.pinColor                     = [self.annotations indexOfObject:annotation] % 3;
        DLog(@"%ld",[self.annotations indexOfObject:annotation]);
        if ([self.annotations indexOfObject:annotation] == 0) {
            annotationView.image                = [UIImage imageNamed:self.imgArr[0]];
        }else if ([self.annotations indexOfObject:annotation] == 1){
            annotationView.image                = [UIImage imageNamed:self.imgArr[1]];
        }else if([self.annotations indexOfObject:annotation] == 2){
            annotationView.image                = [UIImage imageNamed:self.imgArr[2]];
        }else{
            annotationView.image                = [UIImage imageNamed:@"mapLogo"];
        }
        
        
        return annotationView;
    }
    
    return nil;
}
- (IBAction)clickDriverPhone:(id)sender {
    NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",self.phone];
    if (![NSString isBlankString:self.phone]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
    }else{
        [YFToast showMessage:@"该司机电话号码为空" inView:self.view];
    }
}


@end
