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

@interface YFLogisticsTrackViewController ()
@property (nonatomic, strong) YFLogisticsTrackMapView *mapView;
@property (nonatomic, assign) BOOL isComplet;
@end

@implementation YFLogisticsTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流动态";
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
        _mapView.startCoordinate         = CLLocationCoordinate2DMake(self.mainModel.sendSiteLatitude, self.mainModel.sendSiteLongitude);
        if (self.isComplet) {
            //如果已经签收的单子就只需要 起始地和目的地
            _mapView.destinationCoordinate   = CLLocationCoordinate2DMake(self.mainModel.recvSiteLatitude, self.mainModel.recvSiteLongitude);
        }else {
            //没有签收的单子,目的地的位置就是司机的位置
            self.mapView.destinationCoordinate  = CLLocationCoordinate2DMake(self.mainModel.driverLatitude, self.mainModel.driverLongitude);
        }
        _mapView.isCompleteOrder         = self.isComplet;
    }
    return _mapView;
}


@end
