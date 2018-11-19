//
//  YFMyMaturingCarTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFMyMaturingCarTableViewCell.h"
#import "YFInverGeoModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ReGeocodeAnnotation.h"
@interface YFMyMaturingCarTableViewCell ()

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isSearchFromDragging;
@property (nonatomic, strong) ReGeocodeAnnotation *annotation;

@end

@implementation YFMyMaturingCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.onLine, 2, 0, NavColor);
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YFCarSourceModel *)model{
    _model                          = model;
    self.name.text                  = model.driverName;
    self.carNum.text                = [NSString isBlankString:model.carLawId] ? @"车牌:暂无" : [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:model.carLawId],[NSString getCarMessageWithFirst:model.containerType AndSecond:model.carSize]];
    self.transactionsNum.text       = [NSString stringWithFormat:@"交易次数   %@次",model.transactionCount];
    if (isLogin) {
        self.address.text           = [NSString isBlankString:model.locAddr] ? @"地址:暂无" : model.locAddr;
    }else{
        self.address.text           = @"地址:登录后可查看";
    }
    self.onLine.backgroundColor     = model.onLine ? NavColor : UIColorFromRGB(0x999999);
    self.onLine.text                = model.onLine ? @"在线" : @"离线";
    
    if ([model.isLike isEqualToString:@"like"]) {
        self.likeBtn.selected       = YES;
        self.likeBtn.hidden         = YES;
    }else{
        self.likeBtn.selected       = NO;
        self.likeBtn.hidden         = NO;
    }
}

-(void)setLmodel:(YFMayBeCarModel *)Lmodel{
    _Lmodel                         = Lmodel;
    self.name.text                  = Lmodel.driverName;
    self.carNum.text                = [NSString isBlankString:Lmodel.carCode] ? @"车牌:暂无" : [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:Lmodel.carCode],[NSString getCarMessageWithFirst:Lmodel.carType AndSecond:Lmodel.carSize]];
    self.transactionsNum.text   = [NSString stringWithFormat:@"交易次数   %@次",Lmodel.times];
    if (isLogin) {
        self.address.text           = [NSString getNullOrNoNull:Lmodel.address];
    }else{
        self.address.text           = @"地址:登录后可查看";
    }
    
    self.likeBtn.hidden             = YES;
    self.onLine.backgroundColor     = Lmodel.onLine ? NavColor : UIColorFromRGB(0x999999);
    self.onLine.text                = Lmodel.onLine ? @"在线" : @"离线";
    if (![NSString isBlankString:Lmodel.address]) {
        self.address.text           = Lmodel.address;
    }else if (Lmodel.latitude != 0 && [NSString isBlankString:Lmodel.address]) {
        //逆地理编码
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location                    = [AMapGeoPoint locationWithLatitude:Lmodel.latitude longitude:Lmodel.longitude];
        regeo.requireExtension            = YES;
        
        [self.search AMapReGoecodeSearch:regeo];
    }else{
        self.address.text     = @"地址:暂无";
    }
    
    
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


- (IBAction)clickCallPhone:(id)sender {
    KUSERNOTLOGIN
    if (self.model) {
        NSString *phone                                  = [NSString stringWithFormat:@"tel:%@",self.model.driverMobile];
        if (![NSString isBlankString:self.model.driverMobile]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
    }else{
        NSString *phone                                  = [NSString stringWithFormat:@"tel:%@",self.Lmodel.phone];
        if (![NSString isBlankString:self.Lmodel.phone]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
    }
    
}

- (IBAction)clickLikeBtn:(UIButton *)sender {
    KUSERNOTLOGIN
    sender.selected            = !sender.selected;
    !self.callBackBlock ? : self.callBackBlock(sender.selected);
}
@end
