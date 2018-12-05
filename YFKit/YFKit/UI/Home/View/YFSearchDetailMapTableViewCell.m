//
//  YFSearchDetailMapTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchDetailMapTableViewCell.h"
#import "YFLogisticsTrackMapView.h"
#import "YFSearchDetailModel.h"
#import "YFInverGeoModel.h"
#import "YFTwoInverGeoModel.h"

@implementation YFSearchDetailMapTableViewCell

static NSString *const cellID = @"YFSearchDetailMapTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    YFSearchDetailMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:cellID owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [self.mapBgView addSubview:self.mapView];
}

- (void)setModel:(YFSearchDetailModel *)model {
    BOOL isComplet                      = NO;
    for (detailsModel *dModel in model.details) {
        if ([dModel.status containsString:@"签收"]) {
            isComplet                   = YES;
            break;
        }
    }
    
    if (isComplet) {
        //订单已完成
        if (model.sendSiteLatitude == 0 || model.recvSiteLatitude == 0) {
            //如果经纬度出现空的情况
            [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:model.startingPlace];
            WS(weakSelf)
            [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat startLatitude, CGFloat startLongitude) {
                //经纬度完整的情况
                weakSelf.mapView.startCoordinate = CLLocationCoordinate2DMake(startLatitude, startLongitude);
                [[YFTwoInverGeoModel sharedYFTwoInverGeoModel] getLatitudeAndlongitudeWithAddress:model.destination];
                [YFTwoInverGeoModel sharedYFTwoInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat endLatitude, CGFloat endLongitude) {
                    weakSelf.mapView.destinationCoordinate = CLLocationCoordinate2DMake(endLatitude, endLongitude);
                    weakSelf.mapView.isCompleteOrder    = isComplet;
                };
            };
        }else {
            //经纬度完整的情况
            self.mapView.startCoordinate            = CLLocationCoordinate2DMake(model.sendSiteLatitude, model.sendSiteLongitude);
            //如果已经签收的单子就只需要 起始地和目的地
            self.mapView.destinationCoordinate      = CLLocationCoordinate2DMake(model.recvSiteLatitude, model.recvSiteLongitude);
            self.mapView.isCompleteOrder            = isComplet;
        }
    }else {
        //订单未完成
        if (model.sendSiteLatitude == 0 && model.driverLatitude != 0) {
            //经纬度为空
            [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:model.startingPlace];
            WS(weakSelf)
            [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat startLatitude, CGFloat startLongitude) {
                //经纬度完整的情况
                weakSelf.mapView.startCoordinate       = CLLocationCoordinate2DMake(startLatitude, startLongitude);
                weakSelf.mapView.destinationCoordinate = CLLocationCoordinate2DMake(model.driverLatitude, model.driverLongitude);
                weakSelf.mapView.isCompleteOrder       = isComplet;
            };
        }else {
            //经纬度完整
            if (model.driverLatitude == 0) {
                return;
            }
            self.mapView.startCoordinate             = CLLocationCoordinate2DMake(model.sendSiteLatitude, model.sendSiteLongitude);
            //没有签收的单子,目的地的位置就是司机的位置
            self.mapView.destinationCoordinate       = CLLocationCoordinate2DMake(model.driverLatitude, model.driverLongitude);
            self.mapView.isCompleteOrder             = isComplet;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (YFLogisticsTrackMapView *)mapView {
    if (!_mapView) {
        _mapView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"YFLogisticsTrackMapView" owner:nil options:nil] firstObject];
        _mapView.frame = self.mapBgView.bounds;
    }
    return _mapView;
}


@end
