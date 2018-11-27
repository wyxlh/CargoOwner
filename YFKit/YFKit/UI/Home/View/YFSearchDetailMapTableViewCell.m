//
//  YFSearchDetailMapTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/11/26.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchDetailMapTableViewCell.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark mapView
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView                            = [[MAMapView alloc]initWithFrame:self.mapBgView.bounds];
        _mapView.showsCompass               = NO;//是否显示指南针,
        _mapView.showsScale                 = NO;//是否显示比例尺
        _mapView.showsUserLocation          = YES;
        _mapView.zoomLevel                  = 11;//缩放级别
        _mapView.autoresizingMask           = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _mapView.delegate                   = self;
    }
    return _mapView;
}

@end
