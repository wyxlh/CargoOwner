//
//  YFPlaceOrderViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/3.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFPlaceOrderViewController.h"
#import "YFReleaseItemTableViewCell.h"
#import "YFReleaseGoodsMsgTableViewCell.h"
#import "YFReleaseFooterView.h"
#import "YFChooseDriverViewController.h"
#import "YFPlaceOrderDAddressTableViewCell.h"
#import "YFChooseAddressListViewController.h"
#import "YFPlaceOrderItemTableViewCell.h"
#import "YFAllOrderViewController.h"
#import "YFCartTypeView.h"
#import "YFGoodsNameView.h"
#import "YFOtherRequirementView.h"
#import "YFAddressPickView.h"
#import "YFHomeDataModel.h"
#import "YFDriverListModel.h"
#import "YFReleseDetailModel.h"
#import "YFChooseAddressView.h"
#import "YFAddressModel.h"
#import "YFInverGeoModel.h"
#import "YFTwoInverGeoModel.h"
#import "YFUmengTracking.h"

@interface YFPlaceOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) NSArray *dataArr;
@property (nonatomic, copy,   nullable) NSString *ProvinceId,*CityId;//省ID 市 ID 初始化的城市为安徽
@property (nonatomic, assign)           NSInteger section,row;//当前用户选中的哪个区 哪一行
@property (nonatomic, assign)           BOOL isSubmitOrder;//是否发布订单
//货源发布具体的开始时间和结束时间 订单 ID  货源单编码
@property (nonatomic, copy, nullable)   NSString *pickGoodsDateEnd,*pickGoodsDateStart,*orderId,*supplyGoodsId;
//开始详细地址 和结束详细地址 货品信息的3个 textField 运费
@property (nonatomic, strong, nullable) UITextField *leftTF,*centerTF,*rightTF,*freeTF;
//开始城市和结束城市 发货地详细地址, 和目的地详细地址  验证货源m有没有被取消 Id
@property (nonatomic, copy, nullable)   NSString *startCity,*endCity,*startDetail,*endDetail,*verificationId;
//收货人 与发货人
@property (nonatomic, copy, nullable)   NSString *destLinkMan,*destLinkTelephone,*linkMan,*linkPhone;
@property (nonatomic, strong, nullable) YFReleaseFooterView *footerView;
@property (nonatomic, strong, nonnull)  YFChooseAddressView *addressView;//选择地址
@property (nonatomic, strong, nullable) YFCartTypeView *cartTypeView;//车型车长的弹框
@property (nonatomic, strong, nullable) YFGoodsNameView *nameView;//货品名称
@property (nonatomic, strong, nullable) YFOtherRequirementView *otherView;//其他要求
@property (nonatomic, strong, nullable) YFDriverListModel *driverModel;//司机 model
@property (nonatomic, strong, nullable) YFReleseDetailModel *ReleseDetailModel;//货源详情 model
@property (nonatomic, strong) YFAddressModel *addressModel;//选择开始地址
@property (nonatomic, strong) YFConsignerModel *ConsignerModel;//目的地
//车型 车长 期望运费 装货时间 其他要求 货品名字
@property (nonatomic, copy, nullable)   NSString *carType,*carlength,*expectPrice,*pickGoodsDate, *unloadWay,*goodsName,*remark;
@property (nonatomic, assign)           CGFloat startSiteLongitude,startSiteLatitude,endSiteLongitude,endSiteLatitude;
@property (nonatomic, copy, nullable)   NSString *startSiteId,*endSiteId,*startAddressId,*endAddressId;//地址 ID
@end

@implementation YFPlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

/**
 选择地址
 */
-(void)chooseAddress{
    self.addressView.hidden                         = NO;
    [self.addressView resetData];
    [UIView animateWithDuration:0.25 animations:^{
        self.addressView.backgroundColor            = [UIColor colorWithWhite:0.00 alpha:0.299];
        self.addressView.y                          = -500;
    }];
}

/**
 选择车型车长
 */
-(void)chooseCarType{
    self.cartTypeView.hidden                        = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.cartTypeView.backgroundColor           = [UIColor colorWithWhite:0.000 alpha:0.299]
        ;
        self.cartTypeView.y                         = -500;
    }];
}

/**
 选择货品名称
 */
-(void)chooseGoodsName{
    self.nameView.hidden                            = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.nameView.backgroundColor               = [UIColor colorWithWhite:0.000 alpha:0.299]
        ;
        self.nameView.y                             = -350;
    }];
}


/**
 选择其他要求
 */
-(void)chooseOtherRequirement{
    self.otherView.hidden                            = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.otherView.backgroundColor               = [UIColor colorWithWhite:0.000 alpha:0.299]
        ;
        self.otherView.y                             = -350;
    }];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//地址
        YFPlaceOrderItemTableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"YFPlaceOrderItemTableViewCell" forIndexPath:indexPath];
        cell.model                                 = self.dataArr[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 1){// 货物信息
        if (indexPath.row == 0) {
            YFReleaseItemTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
            cell.model                             = self.dataArr[indexPath.section][indexPath.row];
            return cell;
        }
        YFReleaseGoodsMsgTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseGoodsMsgTableViewCell" forIndexPath:indexPath];
        self.leftTF                                = cell.leftTF;
        self.centerTF                              = cell.centerTF;
        self.rightTF                               = cell.rightTF;
        cell.model                                 = self.dataArr[indexPath.section][indexPath.row];
        return cell;
    }else{//货车类型及需求
        YFReleaseItemTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
        cell.model                                 = self.dataArr[indexPath.section][indexPath.row];
        cell.placeholder.enabled                   = indexPath.row == 2 ? YES : NO;
        if (self.oldOrderType == 1 && self.detailModel) {
            //确认报价 不能修改实际运费
            cell.placeholder.enabled               = NO;
        }
        cell.accessoryType = indexPath.row == 2 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        cell.rightCons.constant                    = indexPath.row == 2 ? 35 : 0;
        if (indexPath.row == 2) {
            self.freeTF                            = cell.placeholder;
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 86.0f;
        }
    }else if (indexPath.section == 0){
        return 60.0f;
    }
    return 48.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section < 2 ? 5.0f : 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    self.section                                    = indexPath.section;
    self.row                                        = indexPath.row;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //始发地
            YFChooseAddressListViewController *list = [YFChooseAddressListViewController new];
            list.isConsignor                        = true;
            list.chooseAddressType                  = AssignOrderType;
            list.addressId                          = self.startAddressId;
            WS(weakSelf)
            list.backCaddressBlock                  = ^(YFConsignerModel *addressModel){
                weakSelf.startCity                  = addressModel.consignerCity;
                weakSelf.startDetail                = addressModel.consignerAddr;
                weakSelf.linkMan                    = addressModel.consignerContacts;
                weakSelf.linkPhone                  = addressModel.consignerMobile;
                weakSelf.startSiteId                = addressModel.siteCode;
                weakSelf.startAddressId             = addressModel.Id;
                YFHomeDataModel *model              = self.dataArr[indexPath.section][indexPath.row];
                model.isCheck                       = YES;
                model.title                         = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:addressModel.consignerContacts],[NSString getNullOrNoNull:addressModel.consignerMobile]];
                model.placeholder                   = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:addressModel.consignerCity],[NSString getNullOrNoNull:addressModel.consignerAddr]];
                //把地址转为经纬度
                [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:model.placeholder];
                [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                    //出发地
                    weakSelf.startSiteLatitude      = latitude;
                    weakSelf.startSiteLongitude     = longitude;
                };
                [weakSelf reloadTableItemCell:indexPath.section row:indexPath.row];
            };
            [self.navigationController pushViewController:list animated:YES];
        }else if (indexPath.row == 1){
            //目的地
            YFChooseAddressListViewController *list = [YFChooseAddressListViewController new];
            list.chooseAddressType                  = AssignOrderType;
            list.addressId                          = self.endAddressId;
            WS(weakSelf)
            list.backAddressBlock                   = ^(YFAddressModel *addressModel){
                weakSelf.endCity                    = addressModel.receiverCity;
                weakSelf.endDetail                  = addressModel.receiverAddr;
                weakSelf.destLinkMan                = addressModel.receiverContacts;
                weakSelf.destLinkTelephone          = addressModel.receiverMobile;
                weakSelf.endSiteId                  = addressModel.siteCode;
                weakSelf.endAddressId               = addressModel.Id;
                YFHomeDataModel *model              = self.dataArr[indexPath.section][indexPath.row];
                model.isCheck                       = YES;
                model.title                         = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:addressModel.receiverContacts],[NSString getNullOrNoNull:addressModel.receiverMobile]];
                model.placeholder                   = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:addressModel.receiverCity],[NSString getNullOrNoNull:addressModel.receiverAddr]];
                //把地址转为经纬度
                [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:model.placeholder];
                [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                    //出发地
                    weakSelf.endSiteLatitude        = latitude;
                    weakSelf.endSiteLongitude       = longitude;
                };
                [weakSelf reloadTableItemCell:indexPath.section row:indexPath.row];
            };
            [self.navigationController pushViewController:list animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //选择货品名称
            [self.nameView refresh];
            [self chooseGoodsName];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //车型车长
            [self chooseCarType];
        }else if (indexPath.row == 1){
            // 装货时间
            [self loadingTime];
        }else if (indexPath.row == 2){
            // 期望运费
        }else if (indexPath.row == 3){
            //其他要求
            [self chooseOtherRequirement];
        }else if (indexPath.row == 4){
            //指定司机
            if (!self.isSubmitOrder) {
                [self chooseDriver];
            }else{
                [YFToast showMessage:@"司机已确认不能修改" inView:self.view];
            }
            
        }
    }
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        _tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView              = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseItemTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseGoodsMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseGoodsMsgTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFPlaceOrderDAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFPlaceOrderDAddressTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFPlaceOrderItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFPlaceOrderItemTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark footerView
-(YFReleaseFooterView *)footerView{
    if (!_footerView) {
        _footerView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseFooterView" owner:nil options:nil] lastObject];
        [_footerView.submitBtn setTitle:@"确认下单" forState:UIControlStateNormal];
        _footerView.autoresizingMask            = 0;
        @weakify(self)
        [[_footerView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.detailModel && self.oldOrderType == 1) {
                //如果是确认报价需要验证该货源是否取消了
                [self verificationIsCanOfferWithSuccess:^{
                     [self postGoodsSource];
                }];
            }else{
               [self postGoodsSource];
            }
            
        }];
    }
    return _footerView;
}

#pragma mark 发布货源
-(void)postGoodsSource{
    [self.view endEditing:YES];
    NSString *alertMsg;
    if ([NSString isBlankString:[self.dataArr[0][0] title]]) {
        alertMsg                                 = @"请完善发货地址和联系人";
    }else if ([[self.dataArr[0][0] title] isEqualToString:@"请选择发货地址和联系人"]){
        alertMsg                                 = @"请完善发货地址和联系人";
    }else if ([NSString isBlankString:[self.dataArr[0][1] title]]){
        alertMsg                                 = @"请完善收货地址和联系人";
    }else if ([[self.dataArr[0][1] title] isEqualToString:@"请选择收货地址和联系人"]){
        alertMsg                                 = @"请完善收货地址和联系人";
    }else if ([NSString isBlankString:self.goodsName]){
        alertMsg                                 = @"请选择货品名称";
    }else if ([NSString isBlankString:self.leftTF.text]){
        alertMsg                                 = @"重量必填";
    }else if (![NSString isBlankString:self.leftTF.text] && [self.leftTF.text integerValue] > 10000){
        alertMsg                                 = @"重量不能大于1万吨";
    }else if (![NSString isBlankString:self.centerTF.text] && [self.centerTF.text integerValue] > 10000){
        alertMsg                                 = @"体积不能大于1万立方";
    }else if (![NSString isBlankString:self.rightTF.text] && [self.rightTF.text integerValue] > 100000){
        alertMsg                                 = @"数量不能大于10万件";
    }else if ([NSString isBlankString:self.carType]){
        alertMsg                                 = @"请选择车型";
    }else if ([NSString isBlankString:self.carlength]){
        alertMsg                                 = @"请选择车长";
    }else if ([NSString isBlankString:self.pickGoodsDate]){
        alertMsg                                 = @"请选择装货时间";
    }else if ([NSString isBlankString:self.freeTF.text]){
        alertMsg                                 = @"请输入实际运费";
    }else if ([NSString isBlankString:self.freeTF.text]){
        alertMsg                                 = @"请输入实际运费";
    }else if (![NSString isBlankString:self.freeTF.text] && [self.freeTF.text integerValue] > 5000000){
        alertMsg                                 = @"实际运费不能超过500万";
    }else if ([NSString isBlankString:self.driverModel.driverId]){
        alertMsg                                 = @"请选择指定司机";
    }else if (self.startSiteLatitude == 0) {
        alertMsg                                 = @"位置转化失败,请重新选择出发地";
    }else if (self.endSiteLatitude == 0) {
        alertMsg                                 = @"位置转化失败,请重新选择出目的地";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms                   = [NSMutableDictionary dictionary];
    NSMutableArray *goodsItemArr                 = [NSMutableArray new];
    [parms safeSetObject:self.driverModel.driverId forKey:@"driverId"];//司机ID
    [parms safeSetObject:self.driverModel.driverName forKey:@"driverName"];//司机名称
    [parms safeSetObject:self.driverModel.driverMobile forKey:@"driverPhone"];//司机电话
    [parms safeSetObject:self.endCity forKey:@"endSite"];//目的地
    [parms safeSetObject:self.startCity forKey:@"startSite"];//开始地
    [parms safeSetObject:self.startDetail forKey:@"startAddress"];//开始详细地址
    [parms safeSetObject:self.endDetail forKey:@"endAddress"];//目的地详细地址
    [parms safeSetObject:self.freeTF.text forKey:@"quotedPrice"];//期望运费
    if (self.isSubmitOrder ) {
        //调用订单
        if ([self.pickGoodsDate containsString:@"全天"]) {
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"0:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"24:00" forKey:@"pickGoodsDateEnd"];
        }else if ([self.pickGoodsDate containsString:@"上午"]){
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"6:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"12:00" forKey:@"pickGoodsDateEnd"];
        }else if ([self.pickGoodsDate containsString:@"下午"]){
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"12:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"18:00" forKey:@"pickGoodsDateEnd"];
        }else if ([self.pickGoodsDate containsString:@"晚上"]){
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"18:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"24:00" forKey:@"pickGoodsDateEnd"];
        }else{
            [parms safeSetObject:self.pickGoodsDate forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:self.pickGoodsDateStart forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:self.pickGoodsDateEnd forKey:@"pickGoodsDateEnd"];
        }
        [parms safeSetObject:self.orderId forKey:@"id"];
        [parms safeSetObject:self.supplyGoodsId forKey:@"supplyGoodsId"];
    }else{
        //调用货源单
        if ([self.pickGoodsDate containsString:@"全天"]) {
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"0:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"24:00" forKey:@"pickGoodsDateEnd"];
        }else if ([self.pickGoodsDate containsString:@"上午"]){
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"6:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"12:00" forKey:@"pickGoodsDateEnd"];
        }else if ([self.pickGoodsDate containsString:@"下午"]){
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"12:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"18:00" forKey:@"pickGoodsDateEnd"];
        }else if ([self.pickGoodsDate containsString:@"晚上"]){
            NSString *timer = [[self.pickGoodsDate componentsSeparatedByString:@" "] firstObject];
            [parms safeSetObject:timer forKey:@"pickGoodsDate"];//装货时间
            [parms safeSetObject:@"18:00" forKey:@"pickGoodsDateStart"];
            [parms safeSetObject:@"24:00" forKey:@"pickGoodsDateEnd"];
        }
    }
    [parms safeSetObject:self.unloadWay forKey:@"unloadWay"];//其他要求
    [parms safeSetObject:self.carlength forKey:@"vehicleCarLength"];//车长
    [parms safeSetObject:self.carType forKey:@"vehicleCarType"];//车型
    [parms safeSetObject:self.remark forKey:@"remark"];//车型
    [parms safeSetObject:@(self.startSiteLongitude) forKey:@"startSiteLongitude"];//出发地经纬度
    [parms safeSetObject:@(self.startSiteLatitude) forKey:@"startSiteLatitude"];//出发地经纬度
    [parms safeSetObject:@(self.endSiteLongitude) forKey:@"endSiteLongitude"];//目的地经纬度
    [parms safeSetObject:@(self.endSiteLatitude) forKey:@"endSiteLatitude"];//目的地经纬度
    [parms safeSetObject:self.startSiteId forKey:@"startSiteId"];//目的地经纬度
    [parms safeSetObject:self.endSiteId forKey:@"endSiteId"];//目的地经纬度
    
    [parms safeSetObject:self.destLinkMan forKey:@"destLinkMan"];//目的地经纬度
    [parms safeSetObject:self.destLinkTelephone forKey:@"destLinkTelephone"];//目的地经纬度
    [parms safeSetObject:self.linkMan forKey:@"linkMan"];//目的地经纬度
    [parms safeSetObject:self.linkPhone forKey:@"linkPhone"];//目的地经纬度
    //货品信息
    NSMutableDictionary *goodsItemDict            = [NSMutableDictionary dictionary];
    [goodsItemDict safeSetObject:self.rightTF.text forKey:@"goodsCount"];
    [goodsItemDict safeSetObject:self.goodsName forKey:@"goodsName"];
    [goodsItemDict safeSetObject:self.centerTF.text forKey:@"goodsVolume"];
    [goodsItemDict safeSetObject:self.leftTF.text forKey:@"goodsWeight"];
    [goodsItemArr addObject:goodsItemDict];
    
    [parms safeSetObject:goodsItemArr forKey:@"goodsItem"];//货物信息
    //调用货源单 和订单 根据 isSubmitOrder
    NSString *path = self.isSubmitOrder ? @"v1/goods/complete.do" : @"v1/goods/add.do";
    @weakify(self)
    [WKRequest postWithURLString:path parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            //发布成功之后 统计
            [YFUmengTracking umengEvent:@"AssignOrders"];
            
            //确认报价之后把状态改为发货
            self.isSubmitOrder                 = NO;
            [self jumpCtrl];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}


/**
 直接下单 跳转订单列表 确认报价跳转未承运
 */
- (void)jumpCtrl{
    if (self.isNewOrder) {
        YFAllOrderViewController * all = [YFAllOrderViewController new];
        [self.navigationController pushViewController:all animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
        [YFNotificationCenter postNotificationName:@"JumpNonCarrierKeys" object:nil];
    }
}

#pragma mark 再来一单 重新赋值
-(void)againAOrder:(YFReleseDetailModel *)detailModel{
    [self.tableView reloadData];
    self.orderId                                = detailModel.Id;
    self.supplyGoodsId                          = detailModel.supplyGoodsId;
    self.verificationId                         = detailModel.verificationId;
    for (int i = 0; i < self.dataArr.count;  i ++) {
        NSArray *sectionArr                     = self.dataArr[i];
        for (int j = 0; j < sectionArr.count ; j ++) {
            YFHomeDataModel *model              = self.dataArr[i][j];
            model.isCheck                       = YES;
            if (i == 0 && j == 0) {
                //始发地
                if ([NSString isBlankString:detailModel.consignerName]) {
                    model.title                 = @"请选择发货地址和联系人";
                }else{
                    model.title                 = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:detailModel.consignerName],[NSString getNullOrNoNull:detailModel.consignerMobile]];
                    self.linkMan                = detailModel.consignerName;
                    self.linkPhone              = detailModel.consignerMobile;
                }
                model.placeholder               = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:detailModel.startSite],[NSString getNullOrNoNull:detailModel.startAddress]];
                self.startCity                  = detailModel.startSite;
                self.startDetail                = detailModel.startAddress;
                
                //把地址转为经纬度
            }else if (i == 0 && j == 1){
                //目的地
                if ([NSString isBlankString:detailModel.receiverName]) {
                    model.title                 = @"请选择收货地址和联系人";
                }else{
                    model.title                 = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:detailModel.receiverName],[NSString getNullOrNoNull:detailModel.receiverMobile]];
                    self.destLinkMan            = detailModel.receiverName;
                    self.destLinkTelephone      = detailModel.receiverMobile;
                }
                model.placeholder               = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:detailModel.endSite],[NSString getNullOrNoNull:detailModel.endAddress]];
                self.endCity                    = detailModel.endSite;
                self.endDetail                  = detailModel.endAddress;
                
            }else if (i == 1 && j == 0){
                //货品名称
                if (detailModel.goodsItem.count > 0) {
                    model.placeholder           = [detailModel.goodsItem[0] goodsName];
                    self.goodsName              = [detailModel.goodsItem[0] goodsName];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                    YFReleaseGoodsMsgTableViewCell *cell = (YFReleaseGoodsMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    cell.leftTF.text            = [detailModel.goodsItem[0] goodsWeight];
                    cell.centerTF.text          = [detailModel.goodsItem[0] goodsVolume];
                    cell.rightTF.text           = [detailModel.goodsItem[0] goodsCount];
                    self.leftTF                 = cell.leftTF;
                    self.centerTF               = cell.centerTF;
                    self.rightTF                = cell.rightTF;
                }else{
                    model.placeholder           = @"点击选择";
                    model.isCheck               = NO;
                    self.leftTF.text            = self.centerTF.text = self.rightTF.text = @"";
                }
                
            }else if (i == 2 && j == 0){
                //车型车长
                model.placeholder               = [NSString stringWithFormat:@"%@/%@",detailModel.vehicleCarType,detailModel.vehicleCarLength];
                self.carType                    = detailModel.vehicleCarType;
                self.carlength                  = detailModel.vehicleCarLength;
            }else if (i == 2 && j == 1){
                //装货时间 暂时去掉
                model.isCheck                   = NO;
                model.placeholder               = @"点击选择";
            }else if (i == 2 && j == 2){
                //实际运费
                model.placeholder               = detailModel.quotedPrice;
                self.freeTF.text                = detailModel.quotedPrice;
            }else if (i == 2 && j == 3){
                //其他要求
                NSString *otherStr              =[NSString stringWithFormat:@"%@ %@",[NSString getNullOrNoNull:detailModel.unloadWay],[NSString getNullOrNoNull:detailModel.remark]];
                model.placeholder               = [NSString isBlankString:otherStr] ? @"装卸要求、其他等" : otherStr;
                model.isCheck                   = ![NSString isBlankString:otherStr];
                self.unloadWay                  = [NSString getNullOrNoNull:detailModel.unloadWay];
                self.remark                     = [NSString getNullOrNoNull:detailModel.remark];
            }else if (i == 2 && j == 4){
                //指定司机
                model.placeholder               = [NSString isBlankString:detailModel.driverName] ? detailModel.driverPhone : detailModel.driverName;
                self.driverModel                = [[YFDriverListModel alloc]init];
                self.driverModel.driverName     = detailModel.driverName;
                self.driverModel.driverMobile   = detailModel.driverPhone;
                self.driverModel.driverId       = detailModel.driverId;
                DLog(@"%@-------%@",detailModel.driverName,detailModel.driverPhone);
            }
        }
    }
    [self.tableView reloadData];
}

/**
 验证是否能确认报价
 */
- (void)verificationIsCanOfferWithSuccess:(void(^)(void))success{
    NSMutableDictionary *parms                = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.verificationId forKey:@"id"];
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"v1/supply/goods/quote/count.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            BOOL isNotHave                    = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"isNotHave"] boolValue];
            if (isNotHave) {
                success();
            }else{
                [YFToast showMessage:@"司机已取消报价"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 选择地址
-(YFChooseAddressView *)addressView{
    if (!_addressView) {
        _addressView                            = [[[NSBundle mainBundle] loadNibNamed:@"YFChooseAddressView" owner:nil options:nil] lastObject];
        _addressView.frame                      = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 500);
        @weakify(self)
        _addressView.chooseDetailAddressBlock   = ^(NSString *addressStr,NSString *addressCode){
            @strongify(self)
            YFHomeDataModel *model                   = self.dataArr[self.section][self.row];
            model.placeholder                        = addressStr;
            model.isCheck                            = YES;
            [self reloadTableItemCell:self.section row:self.row];
        };
        [YFWindow addSubview:_addressView];
    }
    return _addressView;
}

#pragma mark - 弹出picker 现在不用这个了
-(void)ShowPickview{
    [self.view endEditing:YES];
    NSArray *ProvinceArr                         = [NSArray readLocalFileWithName:@"Province"];
    NSDictionary *CityArr                        = (NSDictionary *)[NSArray readLocalFileWithName:@"CityArea"];
    YFAddressPickView *addressPickView           = [YFAddressPickView shareInstance];
    [addressPickView getPickerDataWithProvince:ProvinceArr CityArr:CityArr ProvinceId:self.ProvinceId CityId:self.CityId DistrictId:@"0"];
    @weakify(self)
    addressPickView.startPlaceBlock              = ^(NSString *address){
        @strongify(self)
        YFHomeDataModel *model                   = self.dataArr[self.section][self.row];
        model.placeholder                        = address;
        model.isCheck                            = YES;
        [self reloadTableItemCell:self.section row:self.row];
    };
    [YFWindow addSubview:addressPickView];
}

#pragma mark  货品名称
-(YFGoodsNameView *)nameView{
    if (!_nameView) {
        _nameView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFGoodsNameView" owner:nil options:nil] lastObject];
        _nameView.frame                         = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 350);
        @weakify(self)
        _nameView.callBackCarTypeBlock          = ^(NSString *googsName){
            @strongify(self)
            DLog(@"%@",googsName);
            self.goodsName                      = googsName;
            YFHomeDataModel *model              = self.dataArr[self.section][self.row];
            model.placeholder                   = googsName;
            model.isCheck                       = YES;
            [self reloadTableItemCell:self.section row:self.row];
        };
        [YFWindow addSubview:_nameView];
    }
    return _nameView;
}

#pragma mark  车型车长
-(YFCartTypeView *)cartTypeView{
    if (!_cartTypeView) {
        _cartTypeView                           = [[[NSBundle mainBundle] loadNibNamed:@"YFCartTypeView" owner:nil options:nil] lastObject];
        _cartTypeView.frame                    = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 500);
        @weakify(self)
        _cartTypeView.callBackCarTypeBlock      = ^(NSString *carType,NSString *carlength){
            @strongify(self)
            DLog(@"%@",[NSString getCarMessageWithFirst:carType AndSecond:carlength]);
            self.carType                        = carType;
            self.carlength                      = carlength;
            YFHomeDataModel *model              = self.dataArr[self.section][self.row];
            model.placeholder                   = [NSString getCarMessageWithFirst:carType AndSecond:carlength];
            model.isCheck                       = YES;
            [self reloadTableItemCell:self.section row:self.row];
        };
        [YFWindow addSubview:_cartTypeView];
        
    }
    return _cartTypeView;
}

#pragma mark 其他要求
-(YFOtherRequirementView *)otherView{
    if (!_otherView) {
        _otherView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFOtherRequirementView" owner:nil options:nil] lastObject];
        _otherView.frame                         = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 350);
        @weakify(self)
        _otherView.callBackCarTypeBlock          = ^(NSString *otherRequire, NSString *remark){
            @strongify(self)
            DLog(@"%@",otherRequire);
            self.unloadWay                       = otherRequire;
            self.remark                          = remark;
            YFHomeDataModel *model               = self.dataArr[self.section][self.row];
            model.placeholder                    = [NSString stringWithFormat:@"%@%@",otherRequire,remark];
            model.isCheck                        = YES;
            [self reloadTableItemCell:self.section row:self.row];
        };
        [YFWindow addSubview:_otherView];
    }
    return _otherView;
}

#pragma mark 装货时间
-(void)loadingTime{
    MHDatePicker *selectDatePicker          = [[MHDatePicker alloc] init];
    @weakify(self)
    selectDatePicker.DataTimeSelectBlock    = ^(NSString *selectTime){
        @strongify(self)
        self.pickGoodsDate                  = selectTime;
        YFHomeDataModel *model              = self.dataArr[self.section][self.row];
        model.placeholder                   = selectTime;
        model.isCheck                       = YES;
        [self reloadTableItemCell:self.section row:self.row];
    };
}

#pragma mark 指定司机
-(void)chooseDriver{
    YFChooseDriverViewController *driver = [YFChooseDriverViewController new];
    driver.hidesBottomBarWhenPushed      = YES;
    driver.isChooseDriver                = YES;
    @weakify(self)
    driver.backDriverMsgBlock            = ^(YFDriverListModel *Dmodel){
        @strongify(self)
        self.driverModel             = Dmodel;
        YFHomeDataModel *model       = self.dataArr[self.section][self.row];
        model.placeholder            = [NSString isBlankString:Dmodel.driverName] ? Dmodel.driverMobile : Dmodel.driverName;
        model.isCheck                = YES;
        [self reloadTableItemCell:self.section row:self.row];
    };
    [self.navigationController pushViewController:driver animated:YES];
}

#pragma mark 刷新单个cell
-(void)reloadTableItemCell:(NSInteger )section row:(NSInteger )row{
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 重新报价
-(void)againOffer{
    self.isSubmitOrder                     = YES;
    self.ReleseDetailModel                 = self.detailModel;
    [self againAOrder:self.ReleseDetailModel];
}

#pragma 常用司机
- (void)commonDriver{
    YFDriverListModel *dModel    = self.driverListModel;
    self.driverModel             = dModel;
    YFHomeDataModel *model       = self.dataArr[2][4];
    model.placeholder            = [NSString isBlankString:dModel.driverName] ? dModel.driverMobile : dModel.driverName;
    model.isCheck                = YES;
    [self reloadTableItemCell:2 row:4];
}

#pragma mark 选择地址
-(void)chooseStartAddress{
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"userConsigner/list.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSArray *dataArr                = [YFConsignerModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            for (YFConsignerModel *Cmodel in dataArr) {
                if (Cmodel.isDefault && ![NSString isBlankString:Cmodel.consignerAddr]) {
                    YFHomeDataModel *model  = self.dataArr[0][0];
                    NSString *name          = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:Cmodel.consignerContacts],[NSString getNullOrNoNull:Cmodel.consignerMobile]];
                    NSString *addressStr    = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:Cmodel.consignerCity],[NSString getNullOrNoNull:Cmodel.consignerAddr]];
                    model.placeholder       = addressStr;
                    model.title             = name;
                    model.isCheck           = YES;
                    self.startCity          = Cmodel.consignerCity;
                    self.startDetail        = Cmodel.consignerAddr;
                    self.linkMan            = Cmodel.consignerContacts;
                    self.linkPhone          = Cmodel.consignerMobile;
                    self.startSiteId        = Cmodel.siteCode;
                    self.startAddressId     = Cmodel.Id;
                    //把地址转为经纬度
                    [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:addressStr];
                    [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                        //出发地
                        self.startSiteLatitude      = latitude;
                        self.startSiteLongitude     = longitude;
                    };
                    
                    [self reloadTableItemCell:0 row:0];
                }
            }
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)chooseEndAddress{
    @weakify(self)
    [WKRequest getWithURLString:@"userReceiver/list.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSArray *dataArr               = [YFAddressModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            for (YFAddressModel *Cmodel in dataArr) {
                if (Cmodel.isDefault) {
                    YFHomeDataModel *model = self.dataArr[0][1];
                    NSString *name         = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:Cmodel.receiverContacts],[NSString getNullOrNoNull:Cmodel.receiverMobile]];
                    NSString *addressStr   = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:Cmodel.receiverCity],[NSString getNullOrNoNull:Cmodel.receiverAddr]];
                    model.placeholder      = addressStr;
                    model.title            = name;
                    model.isCheck          = YES;
                    self.endCity           = Cmodel.receiverCity;
                    self.endDetail         = Cmodel.receiverAddr;
                    self.destLinkMan       = Cmodel.receiverContacts;
                    self.destLinkTelephone = Cmodel.receiverMobile;
                    self.endSiteId         = Cmodel.siteCode;
                    self.endAddressId      = Cmodel.Id;
                    //把地址转为经纬度
                    YFTwoInverGeoModel *geoModel    = [[YFTwoInverGeoModel alloc]init];
                    [geoModel getLatitudeAndlongitudeWithAddress:addressStr];
                    geoModel.latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                        //目的地
                        self.endSiteLatitude        = latitude;
                        self.endSiteLongitude       = longitude;
                    };
                    [self reloadTableItemCell:0 row:1];
                }
            }
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)setUI{
    self.title                             = @"下单";
    self.dataArr                           = [YFHomeDataModel mj_objectArrayWithKeyValuesArray:[NSArray getOrderData]];
    //确认报价重新赋值
    if (self.detailModel && self.oldOrderType == 1) {
        [self againOffer];
    }
    //如果是直接下单 或者是常用司机下单需要条用这两个接口 如果是确认报价 则不需要
    if (self.isNewOrder) {
        [self chooseEndAddress];
        [self chooseStartAddress];
    }
    
    //重新下单
    if (self.detailModel && self.oldOrderType == 2) {
        self.isSubmitOrder                 = NO;
        self.ReleseDetailModel             = self.detailModel;
        [self againAOrder:self.ReleseDetailModel];
    }
    
    // 常用司机
    if (self.driverListModel) {
        [self commonDriver];
    }
    
    [self.tableView reloadData];
}

@end
