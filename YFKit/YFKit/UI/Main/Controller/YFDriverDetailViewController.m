//
//  YFDriverDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFDriverDetailViewController.h"
#import "YFDriverDetailModel.h"
@interface YFDriverDetailViewController ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *carNum;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *lines;
//标记开始于结束的位置
@property (nonatomic, strong) NSMutableArray *annotations;
/**
 开始结束和货车图标
 */
@property (nonatomic, strong) NSArray *imgArr;

@property (nonatomic, strong) YFDriverDetailModel *mainModel;
@end

@implementation YFDriverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLines];
    [self initAnnotations];
    [self setUI];
    [self netWork];
}

-(void)setUI{
    self.title                              = @"司机详情";
    SKViewsBorder(self.mapBgView, 3, 0, NavColor);
    self.imgArr                             = [NSArray getDriverLogo];
    [self.mapBgView addSubview:self.mapView];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations animated:YES];
}

-(void)netWork{
    NSMutableDictionary *parms               = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.driveId forKey:@"driveId"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/goods/driver/details.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [self requestSuccess:baseModel.data];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)requestSuccess:(NSString *)dict{
    self.mainModel                           = [YFDriverDetailModel mj_objectWithKeyValues:dict];
    self.name.text                           = [NSString getNullOrNoNull:self.mainModel.driverName];
    self.phone.text                          = [NSString getNullOrNoNull:self.mainModel.driverMobile];
    self.carNum.text                         = [NSString stringWithFormat:@"车牌号 %@",[NSString getNullOrNoNull:self.mainModel.carLawId]];
    if ([self.mainModel.certifiedStatus containsString:@"已认证"]) {
        self.logo.hidden                     = NO;
    }
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
    CLLocationCoordinate2D line2Points[10];
    line2Points[0].latitude                  = 39.992520;
    line2Points[0].longitude                 = 116.336170;
    
    line2Points[1].latitude                  = 39.992520;
    line2Points[1].longitude                 = 116.336170;
    
    line2Points[2].latitude                  = 39.998293;
    line2Points[2].longitude                 = 116.352343;
    
    line2Points[3].latitude                  = 40.004087;
    line2Points[3].longitude                 = 116.348904;
    
    line2Points[4].latitude                  = 40.001442;
    line2Points[4].longitude                 = 116.353915;
    
    line2Points[5].latitude                  = 39.989105;
    line2Points[5].longitude                 = 116.353915;
    
    line2Points[6].latitude                  = 39.989098;
    line2Points[6].longitude                 = 116.360200;
    
    line2Points[7].latitude                  = 39.998439;
    line2Points[7].longitude                 = 116.360201;
    
    line2Points[8].latitude                  = 39.979590;
    line2Points[8].longitude                 = 116.324219;
    
    line2Points[9].latitude                  = 39.978234;
    line2Points[9].longitude                 = 116.352792;
    
    MAPolyline *line2                        = [MAPolyline polylineWithCoordinates:line2Points count:10];

    [arr addObject:line2];
    
    self.lines = [NSArray arrayWithArray:arr];
}

#pragma mark - Initialization
- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[10] = {
        {39.992520, 116.336170},
        {39.992520, 116.336170},
        {39.998293, 116.352343},
        {40.004087, 116.348904},
        {40.001442, 116.353915},
        {39.989105, 116.353915},
        {39.989098, 116.360200},
        {39.998439, 116.360201},
        {39.979590, 116.324219},
        {39.978234, 116.352792}};
    
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"anno: %d", i];
        [self.annotations addObject:a1];
    }
}

-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView                            = [[MAMapView alloc]initWithFrame:self.mapBgView.bounds];
        _mapView.showsCompass               = NO;//是否显示指南针,
        _mapView.showsScale                 = NO;//是否显示比例尺
//        _mapView.centerCoordinate           = CLLocationCoordinate2DMake(31.238068, 121.501654);
        _mapView.zoomLevel                  = 18;//缩放级别
        _mapView.centerCoordinate           = CLLocationCoordinate2DMake(31.238068, 121.501654);
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
        annotationView.pinColor                     = [self.annotations indexOfObject:annotation] % 3;
//        annotationView.image                        = [UIImage imageNamed:self.imgArr[[self.annotations indexOfObject:annotation]]];
        return annotationView;
    }
    
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.mapView addOverlays:self.lines];
}

- (IBAction)clickDiiverBtn:(id)sender {
    NSString *phone                                  = [NSString stringWithFormat:@"tel:%@",self.mainModel.driverMobile];
    if (![NSString isBlankString:self.mainModel.driverMobile]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
    
}


@end
