//
//  YFReleaseViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseViewController.h"
#import "YFReleaseItemTableViewCell.h"
#import "YFReleaseGoodsMsgTableViewCell.h"
#import "YFReleaseFooterView.h"
#import "YFChooseDriverViewController.h"
#import "YFCartTypeView.h"
#import "YFGoodsNameView.h"
#import "YFOtherRequirementView.h"
#import "YFHomeDataModel.h"
#import "YFAddressPickView.h"
#import "YFDriverListModel.h"
#import "YFDriverListModel.h"
#import "YFReleseDetailModel.h"
#import "YFChooseAddressView.h"
#import "YFInverGeoModel.h"
#import "YFTwoInverGeoModel.h"
#import "YFUmengTracking.h"

@interface YFReleaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) NSArray *dataArr;
@property (nonatomic, copy,   nullable) NSString *ProvinceId,*CityId;//省ID 市 ID 初始化的城市为安徽
@property (nonatomic, assign)           NSInteger section,row;//当前用户选中的哪个区 哪一行
@property (nonatomic, strong, nullable) UITextField *leftTF,*centerTF,*rightTF,*freeTF;//货品信息的3个 textField 运费
//货源发布具体的开始时间和结束时间 订单 ID  货源单编码
@property (nonatomic, copy, nullable)   NSString *pickGoodsDateEnd,*pickGoodsDateStart;
@property (nonatomic, strong, nullable) YFReleaseFooterView *footerView;//底部 View
@property (nonatomic, strong, nullable)  YFChooseAddressView *addressView;//选择地址
@property (nonatomic, strong, nullable) YFCartTypeView *cartTypeView;//车型车长的弹框
@property (nonatomic, strong, nullable) YFGoodsNameView *nameView;//货品名称
@property (nonatomic, strong, nullable) YFOtherRequirementView *otherView;//其他要求
@property (nonatomic, strong, nullable) YFDriverListModel *driverModel;//司机 model
@property (nonatomic, strong, nullable) YFReleseDetailModel *ReleseDetailModel;//货源详情 model
//车型 车长 期望运费 装货时间 其他要求 货品名字
@property (nonatomic, copy, nullable)   NSString *carType,*carlength,*expectPrice,*pickGoodsDate,*unloadWay,*goodsName,*remark;
//出发地和目的地的经纬度
@property (nonatomic, assign)           CGFloat startSiteLongitude,startSiteLatitude,endSiteLongitude,endSiteLatitude;
@property (nonatomic, copy, nullable)   NSString *startSiteId,*endSiteId;
@end

@implementation YFReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    
    self.title                                  = @"发布货源";
    self.dataArr                                = [YFHomeDataModel mj_objectArrayWithKeyValuesArray:[NSArray getHomeData]];
    
    //再来一单
    if (self.detailModel) {
        self.ReleseDetailModel                  = self.detailModel;
        [self againAOrder:self.ReleseDetailModel];
    }
    [self.tableView reloadData];
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
        self.cartTypeView.backgroundColor           = [UIColor colorWithWhite:0.000 alpha:0.299];
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
        self.nameView.y                             = -310;
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
        self.otherView.y                             = -300;
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//地址
        YFReleaseItemTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
        cell.model                                 = self.dataArr[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 1){// 货物信息
        if (indexPath.row == 0) {
            YFReleaseItemTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
            cell.model                                 = self.dataArr[indexPath.section][indexPath.row];
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
        cell.accessoryType = indexPath.row == 2 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        cell.rightCons.constant                    = indexPath.row == 2 ? 35 : 0;
        if (indexPath.row == 2) {
            self.freeTF                            = cell.placeholder;
        }
        return cell;
    }
    
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
            [self chooseAddress];
            
        }else{
            //目的地
            [self chooseAddress];
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
            [self chooseDriver];
        }
    }
}

#pragma mark TableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate                     = self;
        _tableView.dataSource                   = self;
        _tableView.estimatedRowHeight           = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle               = 0;
        _tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView              = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseItemTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YFReleaseGoodsMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFReleaseGoodsMsgTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 确认发布
-(YFReleaseFooterView *)footerView{
    if (!_footerView) {
        _footerView                             = [[[NSBundle mainBundle] loadNibNamed:@"YFReleaseFooterView" owner:nil options:nil] lastObject];
//        _footerView.frame                       = CGRectMake(0, ScreenHeight-NavHeight-50, ScreenWidth, 50);
        _footerView.autoresizingMask            = 0;
        @weakify(self)
        [[_footerView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self postGoodsSource];
        }];
//        [self.view addSubview:_footerView];
    }
    return _footerView;
}

#pragma mark 发布货源
-(void)postGoodsSource{
    
    [self.view endEditing:YES];
    
    NSString *alertMsg;
    if ([NSString isBlankString:[self.dataArr[0][0] placeholder]]) {
        alertMsg                                 = @"请选择始发地";
    }else if ([[self.dataArr[0][0] placeholder] isEqualToString:@"点击选择"]){
        alertMsg                                 = @"请选择始发地";
    }else if ([NSString isBlankString:[self.dataArr[0][1] placeholder]]){
        alertMsg                                 = @"请选择目的地";
    }else if ([[self.dataArr[0][1] placeholder] isEqualToString:@"点击选择"]){
        alertMsg                                 = @"请选择目的地";
    }else if ([NSString isBlankString:self.goodsName]){
        alertMsg                                 = @"请选择货品名称";
    }else if ([NSString isBlankString:self.leftTF.text]){
        alertMsg                                 = @"重量必填";
    }else if (![NSString isBlankString:self.leftTF.text] && [self.leftTF.text doubleValue] > 10000){
        alertMsg                                 = @"重量不能大于1万吨";
    }else if (![NSString isBlankString:self.centerTF.text] && [self.centerTF.text doubleValue] > 10000){
        alertMsg                                 = @"体积不能大于1万立方";
    }else if (![NSString isBlankString:self.rightTF.text] && [self.rightTF.text doubleValue] > 100000){
        alertMsg                                 = @"数量不能大于10万件";
    }else if ([NSString isBlankString:self.carType]){
        alertMsg                                 = @"请选择车型";
    }else if ([NSString isBlankString:self.carlength]){
        alertMsg                                 = @"请选择车长";
    }else if ([NSString isBlankString:self.pickGoodsDate]){
        alertMsg                                 = @"请选择装货时间";
    }else if (![NSString isBlankString:self.freeTF.text]){
        if ([self.freeTF.text integerValue] >5000000) {
            alertMsg                             = @"期望运费不能超过500万";
        }
    }else if (self.startSiteLatitude == 0) {
        alertMsg                                 = @"位置转化失败,请重新选择出发地";
    }else if (self.endSiteLatitude == 0) {
        alertMsg                                 = @"位置转化失败,请重新选择出目的地";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    //判断是否有小数点重量体积是否有小数
    if (![NSString isBlankString:self.leftTF.text] && [self.leftTF.text containsString:@"."]){
        self.leftTF.text                         = [NSString stringWithFormat:@"%.2f",[self.leftTF.text doubleValue]];
        [YFToast showMessage:@"重量和体积自动保存两位小数" inView:self.view];
    }
    
    if (![NSString isBlankString:self.centerTF.text] && [self.centerTF.text containsString:@"."]) {
        self.centerTF.text                       = [NSString stringWithFormat:@"%.2f",[self.centerTF.text doubleValue]];
        [YFToast showMessage:@"重量和体积自动保存两位小数" inView:self.view];
    }
    
    NSMutableDictionary *parms                   = [NSMutableDictionary dictionary];
    NSMutableArray *goodsItemArr                 = [NSMutableArray new];
    [parms safeSetObject:[self.dataArr[0][1] placeholder] forKey:@"endSite"];//目的地
    [parms safeSetObject:[self.dataArr[0][0] placeholder] forKey:@"startSite"];//开始地
    [parms safeSetObject:self.freeTF.text forKey:@"expectPrice"];//期望运费
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
    //货品信息
    NSMutableDictionary *goodsItemDict            = [NSMutableDictionary dictionary];
    [goodsItemDict safeSetObject:self.rightTF.text forKey:@"goodsCount"];
    [goodsItemDict safeSetObject:self.goodsName forKey:@"goodsName"];
    [goodsItemDict safeSetObject:self.centerTF.text forKey:@"goodsVolume"];
    [goodsItemDict safeSetObject:self.leftTF.text forKey:@"goodsWeight"];
    [goodsItemArr addObject:goodsItemDict];

    [parms safeSetObject:goodsItemArr forKey:@"goodsItem"];//货物信息
    @weakify(self)
    [WKRequest postWithURLString:@"v1/goods/add.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            //发布成功之后 统计
            [YFUmengTracking umengEvent:@"PostSourceOfGoods"];
            [self selectTabbarIndex:2];
            [self.navigationController popViewControllerAnimated:NO];
            [YFNotificationCenter postNotificationName:@"JumpPostKeys" object:nil];
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 发布成功之后数据清空
-(void)reloadTableView{
    self.dataArr                                = [YFHomeDataModel mj_objectArrayWithKeyValuesArray:[NSArray getHomeData]];
    [self.tableView reloadData];
}

#pragma mark 再来一单 重新赋值
-(void)againAOrder:(YFReleseDetailModel *)detailModel{
    [self.tableView reloadData];
//    self.pickGoodsDateEnd                       = detailModel.pickGoodsDateEnd;
//    self.pickGoodsDateStart                     = detailModel.pickGoodsDateStart;
    for (int i = 0; i < self.dataArr.count;  i ++) {
        NSArray *sectionArr                     = self.dataArr[i];
        for (int j = 0; j < sectionArr.count ; j ++) {
            YFHomeDataModel *model              = self.dataArr[i][j];
            model.isCheck                       = YES;
            if (i == 0 && j == 0) {
                //始发地
                model.placeholder               = detailModel.startSite;
            }else if (i == 0 && j == 1){
                //目的地
                model.placeholder               = detailModel.endSite;
            }else if (i == 1 && j == 0){
                //货品名称
                if (detailModel.goodsItem.count > 0) {
                    model.placeholder           = [detailModel.goodsItem[0] goodsName];
                    self.goodsName              = [detailModel.goodsItem[0] goodsName];
                    self.leftTF.text            = [detailModel.goodsItem[0] goodsWeight];
                    self.centerTF.text          = [detailModel.goodsItem[0] goodsVolume];
                    self.rightTF.text           = [[detailModel.goodsItem[0] goodsCount] integerValue] == 0 ? @"" : [detailModel.goodsItem[0] goodsCount];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                    YFReleaseGoodsMsgTableViewCell *cell = (YFReleaseGoodsMsgTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    cell.leftTF.text            = [detailModel.goodsItem[0] goodsWeight];
                    cell.centerTF.text          = [detailModel.goodsItem[0] goodsVolume];
                    cell.rightTF.text           = [[detailModel.goodsItem[0] goodsCount] integerValue] == 0 ? @"" : [detailModel.goodsItem[0] goodsCount];
                    self.leftTF                 = cell.leftTF;
                    self.centerTF               = cell.centerTF;
                    self.rightTF                = cell.rightTF;
                }else{
                    model.placeholder               = @"点击选择";
                    model.isCheck               = NO;
                    self.leftTF.text            = self.centerTF.text = self.rightTF.text = @"";
                }
                
            }else if (i == 2 && j == 0){
                //车型车长
                model.placeholder               = [NSString stringWithFormat:@"%@/%@",detailModel.vehicleCarType,detailModel.vehicleCarLength];
                self.carType                    = detailModel.vehicleCarType;
                self.carlength                  = detailModel.vehicleCarLength;
            }else if (i == 2 && j == 1){
                //装货时间 不带过来
//                NSString *time                  = [NSString stringWithFormat:@"%@",[NSString getGoodsDetailTime:detailModel.pickGoodsDate WithStartTime:detailModel.pickGoodsDateStart WithEndTime:detailModel.pickGoodsDateEnd]];
//                model.placeholder               = time;
//                self.pickGoodsDate              = time;
                model.isCheck                   = NO;
            }else if (i == 2 && j == 2){
                //期望运费
                model.placeholder               = detailModel.expectPrice;
                self.freeTF.text                = detailModel.expectPrice;
            }else if (i == 2 && j == 3){
                //其他要求
                NSString *otherStr              =[NSString stringWithFormat:@"%@ %@",[NSString getNullOrNoNull:detailModel.unloadWay],[NSString getNullOrNoNull:detailModel.remark]];
                model.placeholder               = [NSString isBlankString:otherStr] ? @"装卸要求、其他等" : otherStr;
                model.isCheck                   = ![NSString isBlankString:otherStr];
                self.unloadWay                  = [NSString getNullOrNoNull:detailModel.unloadWay];
                self.remark                     = [NSString getNullOrNoNull:detailModel.remark];
            }else if (i == 2 && j == 4){
                //指定司机
                model.placeholder               = detailModel.driverName;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 弹出picker  现在不用这个了
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

#pragma mark 选择地址
-(YFChooseAddressView *)addressView{
    if (!_addressView) {
        _addressView                            = [[[NSBundle mainBundle] loadNibNamed:@"YFChooseAddressView" owner:nil options:nil] lastObject];
        _addressView.frame                      = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 500);
        @weakify(self)
        _addressView.chooseDetailAddressBlock   = ^(NSString *addressStr,NSString *addressCode){
            @strongify(self)
            YFHomeDataModel *model              = self.dataArr[self.section][self.row];
            model.placeholder                   = addressStr;
            model.isCheck                       = YES;
            //地址 code
            if (self.row == 0) {
                self.startSiteId                = [NSString getCityCode:addressCode];
                //把地址转为经纬度
                [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:model.placeholder];
                [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                    //出发地
                    self.startSiteLatitude      = latitude;
                    self.startSiteLongitude     = longitude;
                };
            }else{
                self.endSiteId                  = [NSString getCityCode:addressCode];
                //把地址转为经纬度
                [[YFTwoInverGeoModel sharedYFTwoInverGeoModel] getLatitudeAndlongitudeWithAddress:model.placeholder];
                [YFTwoInverGeoModel sharedYFTwoInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                    //目的地
                    self.endSiteLatitude        = latitude;
                    self.endSiteLongitude       = longitude;
                };
            }
            
            [self reloadTableItemCell:self.section row:self.row];
        };
        [YFWindow addSubview:_addressView];
    }
    return _addressView;
}


#pragma mark  货品名称
-(YFGoodsNameView *)nameView{
    if (!_nameView) {
        _nameView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFGoodsNameView" owner:nil options:nil] lastObject];
        _nameView.frame                         = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 310);
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
        _cartTypeView                            = [[[NSBundle mainBundle] loadNibNamed:@"YFCartTypeView" owner:nil options:nil] lastObject];
         _cartTypeView.frame                     = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 500);
        @weakify(self)
        _cartTypeView.callBackCarTypeBlock       = ^(NSString *carType,NSString *carlength){
            @strongify(self)
            DLog(@"%@",[NSString getCarMessageWithFirst:carType AndSecond:carlength]);
            self.carType                         = carType;
            self.carlength                       = carlength;
            YFHomeDataModel *model               = self.dataArr[self.section][self.row];
            model.placeholder                    = [NSString getCarMessageWithFirst:carType AndSecond:carlength];
            model.isCheck                        = YES;
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
        _otherView.frame                         = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
        @weakify(self)
        _otherView.callBackCarTypeBlock          = ^(NSString *otherRequire , NSString *remark){
            @strongify(self)
            DLog(@"%@",otherRequire);
            self.unloadWay                       = otherRequire;
            self.remark                          = remark;
            YFHomeDataModel *model               = self.dataArr[self.section][self.row];
            model.placeholder                    = [NSString getCarMessageWithFirst:otherRequire AndSecond:remark];;
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
    driver.hidesBottomBarWhenPushed      = driver.isChooseDriver = YES;
    @weakify(self)
    driver.backDriverMsgBlock            = ^(YFDriverListModel *Dmodel){
        @strongify(self)
        if (![NSString isBlankString:Dmodel.driverName]) {
            self.driverModel             = Dmodel;
            YFHomeDataModel *model       = self.dataArr[self.section][self.row];
            model.placeholder            = Dmodel.driverName;
            model.isCheck                = YES;
        }else{
            YFHomeDataModel *model       = self.dataArr[self.section][self.row];
            model.placeholder            = @"选择好友(非必填)";
            model.isCheck                = NO;
        }
        [self reloadTableItemCell:self.section row:self.row];
    };
    [self.navigationController pushViewController:driver animated:YES];
}

#pragma mark 刷新单个cell
-(void)reloadTableItemCell:(NSInteger )section row:(NSInteger )row{
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //TODO: 页面Disappear 启用
//    [[IQKeyboardManager sharedManager] setEnable:YES];
}


-(void)dealloc{
    [YFNotificationCenter removeObserver:self];
}

@end
