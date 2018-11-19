//
//  YFDriverDetailViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/5.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFDriverDetailViewController.h"
#import "YFDriverDetailModel.h"
#import "YFInverGeoModel.h"
@interface YFDriverDetailViewController ()<MAMapViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapBgView;
@property (weak, nonatomic) IBOutlet UIView *driverMsgView;
@property (weak, nonatomic) IBOutlet UILabel *name;//名字
@property (weak, nonatomic) IBOutlet UILabel *carMsg;//车牌号
@property (weak, nonatomic) IBOutlet UILabel *carNum;//交易次数
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;//电话
@property (weak, nonatomic) IBOutlet UILabel *onLine;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;//是否喜欢
/**
 注册时间
 */
@property (weak, nonatomic) IBOutlet UILabel *registerTime;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSArray *lines;
//标记开始于结束的位置
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, copy)   NSString *driverLocation;//司机位置
/**
 开始结束和货车图标
 */
@property (nonatomic, strong) NSArray *imgArr;

@property (nonatomic, strong) YFDriverDetailModel *mainModel;
@property (nonatomic, strong) MAPointAnnotation *a1;
@end

@implementation YFDriverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                              = @"司机详情";
    SKViewsBorder(self.mapBgView, 3, 0, NavColor);
    SKViewsBorder(self.onLine, 2, 0, NavColor);
    self.view.backgroundColor               = UIColorFromRGB(0xF4F5F6);
    self.imgArr                             = [NSArray getDriverLogo];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.mapBgView addSubview:self.mapView];
    UITapGestureRecognizer *tap             = [[UITapGestureRecognizer alloc]init];
    [self.mapView addGestureRecognizer:tap];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.mapView selectAnnotation:self.a1 animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self netWork];
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
            [self.navigationController popViewControllerAnimated:YES];
//            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)requestSuccess:(NSString *)dict{
    self.mainModel                           = [YFDriverDetailModel mj_objectWithKeyValues:dict];
    self.name.text                           = [NSString getNullOrNoNull:self.mainModel.driverName];
    self.carMsg.text                         = [NSString isBlankString:self.mainModel.carLawId] ? @"车牌:暂无" : [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:self.mainModel.carLawId],[NSString getCarMessageWithFirst:self.mainModel.containerType AndSecond:self.mainModel.carSize]];
    self.carNum.text                         = [NSString stringWithFormat:@"交易次数 %@次",self.mainModel.transactionCount];
    if (isLogin) {
        self.phoneLbl.text                   = [NSString getNullOrNoNull:self.mainModel.driverMobile];
    }else{
        self.phoneLbl.text                   = @"登录后可查看";
    }
    self.onLine.backgroundColor              = self.mainModel.onLine ? NavColor : UIColorFromRGB(0x999999);
    self.onLine.text                         = self.mainModel.onLine ? @"在线" : @"离线";
    if ([self.mainModel.isLike isEqualToString:@"like"]) {
        self.likeBtn.selected                = YES;
        [self.likeBtn setImage:[UIImage imageNamed:@"xing"] forState:0];
    }else{
        self.likeBtn.selected                = NO;
        [self.likeBtn setImage:[UIImage imageNamed:@"noXing"] forState:0];
    }
    if (![NSString isBlankString:self.mainModel.createTime]) {
        NSArray *timeArr                     = [self.mainModel.createTime componentsSeparatedByString:@" "];
        NSString *timeStr                    = [[timeArr firstObject] substringToIndex:7];
        self.registerTime.text               = [NSString stringWithFormat:@"%@ 注册",timeStr];
    }else{
        self.registerTime.hidden             = YES;
    }

    if (![NSString isBlankString:self.mainModel.locAddr]) {
        //有地址的时候直接展示地址
        self.driverLocation                  = isLogin ? self.mainModel.locAddr : @"登录后可查看";
        NSMutableArray *locationArr = [NSMutableArray new];
        
        NSMutableDictionary *locationDict    = [NSMutableDictionary dictionary];
        [locationDict safeSetObject:@(self.mainModel.latitude )forKey:@"lat"];
        [locationDict safeSetObject:@(self.mainModel.longitude) forKey:@"lon"];
        [locationArr addObject:locationDict];
        
        [self initAnnotations:locationArr];
        _mapView.centerCoordinate            = CLLocationCoordinate2DMake(self.mainModel.latitude, self.mainModel.longitude);
        //显示司机位置
        [self.mapView addAnnotations:self.annotations];
        [self.mapView showAnnotations:self.annotations animated:YES];
        
    }else if (self.mainModel.latitude != 0.00 && [NSString isBlankString:self.mainModel.locAddr]) {
        //没有地址的时候 根据经纬度展示地址
        NSMutableArray *locationArr = [NSMutableArray new];
        
        NSMutableDictionary *locationDict    = [NSMutableDictionary dictionary];
        [locationDict safeSetObject:@(self.mainModel.latitude )forKey:@"lat"];
        [locationDict safeSetObject:@(self.mainModel.longitude) forKey:@"lon"];
        [locationArr addObject:locationDict];
        
        [[YFInverGeoModel sharedYFInverGeoModel] getDriverAddressWithLatitude:self.mainModel.latitude Longitude:self.mainModel.longitude];
        @weakify(self)
        [YFInverGeoModel sharedYFInverGeoModel].driverAddressBlock = ^(NSString *address){
            @strongify(self)
            self.driverLocation                 = isLogin ? address : @"登录后查看";
            [self initAnnotations:locationArr];
            _mapView.centerCoordinate           = CLLocationCoordinate2DMake(self.mainModel.latitude, self.mainModel.longitude);
            //显示司机位置
            [self.mapView addAnnotations:self.annotations];
            [self.mapView showAnnotations:self.annotations animated:YES];
        };
        
    }else{
        self.mapView.hidden                     = YES;
    }
}

#pragma mark 关注与不关注
- (IBAction)clickLikeBtn:(UIButton *)sender {
    KUSERNOTLOGIN
    if (sender.selected) {
        //取消关注
        NSMutableDictionary *dict            = [NSMutableDictionary dictionary];
        [dict safeSetObject:self.mainModel.carId forKey:@"carId"];
        [dict safeSetObject:self.mainModel.Id forKey:@"driverId"];
        @weakify(self)
        [WKRequest postWithURLString:@"app/consignerCar/unsubscribe.do" parameters:dict isJson:YES success:^(WKBaseModel *baseModel) {
            @strongify(self)
            if (CODE_ZERO) {
                [YFToast showMessage:@"取消关注成功" inView:self.view];
                sender.selected               = NO;
                [self.likeBtn setImage:[UIImage imageNamed:@"noXing"] forState:0];
            }else{
                [YFToast showMessage:baseModel.message inView:self.view];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        NSMutableDictionary *dict             = [NSMutableDictionary dictionary];
        [dict safeSetObject:self.mainModel.carId forKey:@"carId"];
        [dict safeSetObject:self.mainModel.driverId forKey:@"driverId"];
        @weakify(self)
        [WKRequest postWithURLString:@"app/consignerCar/addLikeCar.do" parameters:dict isJson:YES success:^(WKBaseModel *baseModel) {
            @strongify(self)
            if (CODE_ZERO) {
                [YFToast showMessage:@"关注成功" inView:self.view];
                sender.selected               = YES;
                [self.likeBtn setImage:[UIImage imageNamed:@"xing"] forState:0];
            }else{
                [YFToast showMessage:baseModel.message inView:self.view];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark - Initialization
- (void)initAnnotations:(NSMutableArray *)location
{
    self.annotations = [NSMutableArray array];

    CLLocationCoordinate2D coordinates[location.count];
    for (int i = 0; i < location.count; i++) {
        NSString *latitude = [location[i] safeJsonObjForKey:@"lat"];
        NSString *longitude = [location[i] safeJsonObjForKey:@"lon"];
        coordinates[i] = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    }
    for (int i = 0; i < location.count; ++i)
    {
        self.a1                = [[MAPointAnnotation alloc] init];
        self.a1.coordinate                        = coordinates[i];
        
        self.a1.title                             = self.driverLocation;
        self.a1.subtitle                          = self.mainModel.onLine ? @"" : [NSString stringWithFormat:@"离线时间:%@",self.mainModel.locTimeStr];
        [self.annotations addObject:self.a1];
    }
    
}


-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView                                = [[MAMapView alloc]initWithFrame:self.mapBgView.bounds];
        _mapView.showsCompass                   = NO;//是否显示指南针,
        _mapView.showsScale                     = NO;//是否显示比例尺
        _mapView.zoomLevel                      = 15;//缩放级别
//         _mapView.showsUserLocation         = YES;
        _mapView.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate                       = self;
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
        annotationView.draggable                    = NO;
        annotationView.image                        = [UIImage imageNamed:self.mainModel.onLine ? @"driverLocation" : @"driverNoLine"];        return annotationView;
    }
    
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.mapView selectAnnotation:self.a1 animated:YES];

    [self.mapView addOverlays:self.lines];
}

- (IBAction)clickDiiverBtn:(id)sender {
    KUSERNOTLOGIN
    NSString *phone                                  = [NSString stringWithFormat:@"tel:%@",self.mainModel.driverMobile];
    if (![NSString isBlankString:self.mainModel.driverMobile]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count ==1) {
        return NO;
    }else{
        !self.refreashDriverDataBlock ? : self.refreashDriverDataBlock();
        return YES;
    }
    
}

-(void)backButtonClick:(UIButton *)sender{
    [self goBack];
    !self.refreashDriverDataBlock ? : self.refreashDriverDataBlock();
}


@end
