//
//  YFGoodsDetailDriverTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/7/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsDetailDriverTableViewCell.h"
#import "YFDriverDetailModel.h"
#import "YFInverGeoModel.h"
#import "YFCarSourceModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ReGeocodeAnnotation.h"
#import "YFPlaceOrderViewController.h"
#import "YFDriverListModel.h"

@interface YFGoodsDetailDriverTableViewCell ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isSearchFromDragging;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;

@end

@implementation YFGoodsDetailDriverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    SKViewsBorder(self.callPhoneBtn, 2, 0.5, UIColorFromRGB(0x0083E2));
    SKViewsBorder(self.createOrderBtn, 2, 0.5, UIColorFromRGB(0x0083E2));
    @weakify(self)
    [[self.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self likeDriver];
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDriverModel:(YFDriverDetailModel *)driverModel{
    _driverModel                             = driverModel;
    self.lookTime.hidden                     = YES;
    self.driverName.text                     = [NSString getNullOrNoNull:self.driverModel.driverName];
    self.count.text                          = [NSString stringWithFormat:@"交易次数    %@次",self.driverModel.transactionCount];
    self.carNum.text                         = [NSString getNullOrNoNull:self.driverModel.carLawId];
//    self.address.text                        = [NSString getNullOrNoNull:self.driverModel.locAddr];
    if ([driverModel.isLike isEqualToString:@"unlike"]) {
        self.likeBtn.selected                = NO;
        self.likeBtn.hidden                  = NO;
    }else{
        self.likeBtn.hidden                  = YES;
    }
    
    if (![NSString isBlankString:driverModel.locAddr]) {
        self.address.text                    = driverModel.locAddr;
    }else if (driverModel.latitude != 0) {
        NSMutableArray *locationArr = [NSMutableArray new];
        
        NSMutableDictionary *locationDict = [NSMutableDictionary dictionary];
        [locationDict safeSetObject:@(self.driverModel.latitude )forKey:@"lat"];
        [locationDict safeSetObject:@(self.driverModel.longitude) forKey:@"lon"];
        
        [locationArr addObject:locationDict];
        
        [[YFInverGeoModel sharedYFInverGeoModel] getDriverAddressWithLatitude:self.driverModel.latitude Longitude:self.driverModel.longitude];
        @weakify(self)
        [YFInverGeoModel sharedYFInverGeoModel].driverAddressBlock = ^(NSString *address){
            @strongify(self)
            self.address.text                = address;
        };
    }else{
        self.address.text                    = @"地址:暂无";
    }
    
    
}

-(void)setLmodel:(YFMayBeCarModel *)Lmodel{
    _Lmodel                                 = Lmodel;
    self.driverName.text                    = Lmodel.name;
    self.carNum.text                        = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:Lmodel.carCode],[NSString getCarMessageWithFirst:Lmodel.carType AndSecond:Lmodel.carLong]];
    self.count.text                         = [NSString stringWithFormat:@"交易次数    %@次",Lmodel.transactionCount];
    if ([Lmodel.isLike isEqualToString:@"unLike"]) {
        self.likeBtn.selected               = NO;
        self.likeBtn.hidden                 = NO;
    }else{
        self.likeBtn.hidden                 = YES;
    }
    if (![NSString isBlankString:Lmodel.time] && [Lmodel.count integerValue] == 1) {
        //count ==1
        if ([NSString checkTheDate:Lmodel.time]) {
            //如果是当天 显示时分
            NSArray *timeArr                = [Lmodel.time componentsSeparatedByString:@" "];
            NSString *timeStr               = [[timeArr lastObject] substringToIndex:5];
            if (self.selectIndex == 0) {
                self.lookTime.text          = [NSString stringWithFormat:@"%@查看",timeStr];
            }else{
                self.lookTime.text          = [NSString stringWithFormat:@"%@联系",timeStr];
            }
            
        }else{
            //显示年月日 时分
            if (self.selectIndex == 0) {
                self.lookTime.text          = [NSString stringWithFormat:@"%@查看",[Lmodel.time substringToIndex:16]];
            }else{
                self.lookTime.text          = [NSString stringWithFormat:@"%@联系",[Lmodel.time substringToIndex:16]];
            }
            
        }
    }else if (![NSString isBlankString:Lmodel.time] && [Lmodel.count integerValue] != 1){
        //count != 1 需要展示查看几次
        if (self.selectIndex == 0) {
            self.lookTime.text              = [NSString stringWithFormat:@"查看%@次",Lmodel.count];
        }else{
            self.lookTime.text              = [NSString stringWithFormat:@"联系%@次",Lmodel.count];
        }
        
    } else{
        self.lookTime.text                  = @"";
    }
    
    if (Lmodel.latitude != 0) {
        //逆地理编码
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location                    = [AMapGeoPoint locationWithLatitude:Lmodel.latitude longitude:Lmodel.longitude];
        regeo.requireExtension            = YES;
        
        [self.search AMapReGoecodeSearch:regeo];
    }else{
        self.address.text                 = @"地址:暂无";
    }
    
    if (![NSString isBlankString:Lmodel.address]) {
        self.address.text                 = [NSString getNullOrNoNull:Lmodel.address];
    }
    
    
}

/**
 联系司机

 @param sender sender description
 */
- (IBAction)clickcallPhone:(id)sender {
    NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",self.Lmodel.phone];
    if (![NSString isBlankString:self.Lmodel.phone]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
    }else{
        [YFToast showMessage:@"该司机电话号码为空"];
    }
}

/**
 指派下单

 @param sender sender description
 */
- (IBAction)clickcreateOrder:(id)sender {
    YFDriverListModel *driverModel          = [[YFDriverListModel alloc]init];
    driverModel.driverName                  = self.Lmodel.name;
    driverModel.driverPhone                 = self.Lmodel.phone;
    driverModel.driverId                    = self.Lmodel.driverId;
    YFPlaceOrderViewController *place       = [YFPlaceOrderViewController new];
    place.driverListModel                   = driverModel;
    place.isNewOrder                        = YES;
    [self.superVC.navigationController pushViewController:place animated:YES];
}

- (void)likeDriver{
    NSMutableDictionary *dict             = [NSMutableDictionary dictionary];
    if (self.driverModel) {
        [dict safeSetObject:self.driverModel.carId forKey:@"carId"];
        [dict safeSetObject:self.driverModel.driverId forKey:@"driverId"];
    }else{
        [dict safeSetObject:self.Lmodel.carId forKey:@"carId"];
        [dict safeSetObject:self.Lmodel.driverId forKey:@"driverId"];
    }
    @weakify(self)
    [WKRequest postWithURLString:@"app/consignerCar/addLikeCar.do" parameters:dict isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"关注成功" inView:self.superVC.view];
            self.likeBtn.hidden            = YES;
        }else{
            [YFToast showMessage:baseModel.message];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    //    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil && _isSearchFromDragging == NO)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        DLog(@"%@",reGeocodeAnnotation.reGeocode.formattedAddress);
        self.address.text = reGeocodeAnnotation.reGeocode.formattedAddress;
        //        [self.mapView addAnnotation:reGeocodeAnnotation];
        //        [self.mapView selectAnnotation:reGeocodeAnnotation animated:YES];
    }
    else /* from drag search, update address */
    {
        [self.annotation setAMapReGeocode:response.regeocode];
        //        [self.mapView selectAnnotation:self.annotation animated:YES];
    }
}

@end
