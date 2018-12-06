//
//  YFLogisticsTrackViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/11/28.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFLogisticsTrackViewController.h"
#import "YFLogisticsTrackMapView.h"
#import "YFSearchDetailModel.h"
#import "YFInverGeoModel.h"
#import "YFTwoInverGeoModel.h"

@interface YFLogisticsTrackViewController ()
@property (nonatomic, strong) YFLogisticsTrackMapView *mapView;
@property (nonatomic, assign) BOOL isComplet;
@end

@implementation YFLogisticsTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流动态";
    
    if (self.isComplet) {
        //订单已完成
        if (self.mainModel.sendSiteLatitude == 0 || self.mainModel.recvSiteLatitude == 0) {
            //如果经纬度出现空的情况
            [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:self.mainModel.startingPlace];
            WS(weakSelf)
            [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat startLatitude, CGFloat startLongitude) {
                //经纬度完整的情况
                weakSelf.mapView.startCoordinate = CLLocationCoordinate2DMake(startLatitude, startLongitude);
                [[YFTwoInverGeoModel sharedYFTwoInverGeoModel] getLatitudeAndlongitudeWithAddress:self.mainModel.destination];
                [YFTwoInverGeoModel sharedYFTwoInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat endLatitude, CGFloat endLongitude) {
                    weakSelf.mapView.destinationCoordinate = CLLocationCoordinate2DMake(endLatitude, endLongitude);
                    weakSelf.mapView.isCompleteOrder    = self.isComplet;
                };
            };
        }else {
            //经纬度完整的情况
            self.mapView.startCoordinate            = CLLocationCoordinate2DMake(self.mainModel.sendSiteLatitude, self.mainModel.sendSiteLongitude);
            //如果已经签收的单子就只需要 起始地和目的地
            self.mapView.destinationCoordinate      = CLLocationCoordinate2DMake(self.mainModel.recvSiteLatitude, self.mainModel.recvSiteLongitude);
            self.mapView.isCompleteOrder            = self.isComplet;
        }
    }else {
        //订单未完成
        if (self.mainModel.sendSiteLatitude == 0 && self.mainModel.driverLatitude != 0) {
            //经纬度为空
            [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:self.mainModel.startingPlace];
            WS(weakSelf)
            [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat startLatitude, CGFloat startLongitude) {
                //经纬度完整的情况
                weakSelf.mapView.startCoordinate       = CLLocationCoordinate2DMake(startLatitude, startLongitude);
                weakSelf.mapView.destinationCoordinate = CLLocationCoordinate2DMake(self.mainModel.driverLatitude, self.mainModel.driverLongitude);
                weakSelf.mapView.isCompleteOrder       = self.isComplet;
            };
        }else {
            //经纬度完整
            self.mapView.startCoordinate             = CLLocationCoordinate2DMake(self.mainModel.sendSiteLatitude, self.mainModel.sendSiteLongitude);
            //没有签收的单子,目的地的位置就是司机的位置
            self.mapView.destinationCoordinate       = CLLocationCoordinate2DMake(self.mainModel.driverLatitude, self.mainModel.driverLongitude);
            self.mapView.isCompleteOrder             = self.isComplet;
        }
    }
    [self.view addSubview:self.mapView];
}

- (void)setMainModel:(YFSearchDetailModel *)mainModel {
    _mainModel                           = mainModel;
    
    self.isComplet                       = NO;
    for (detailsModel *dModel in mainModel.details) {
        if ([dModel.status containsString:@"签收"]) {
            self.isComplet               = YES;
            break;
        }
    }
}

#pragma mark 地图
- (YFLogisticsTrackMapView *)mapView {
    if (!_mapView) {
        _mapView                         = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"YFLogisticsTrackMapView" owner:nil options:nil] firstObject];
        _mapView.frame                   = self.view.bounds;
    }
    return _mapView;
}

@end
