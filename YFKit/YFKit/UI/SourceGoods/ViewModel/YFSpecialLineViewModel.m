//
//  YFSpecialLineViewModel.m
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineViewModel.h"
#import "YFSpecialLineOtherFreeViewController.h"
#import "YFChooseAddressListViewController.h"
#import "YFHomeDataModel.h"
#import "YFAddressModel.h"
#import "YFOtherRequirementView.h"
#import "YFGoodsNameView.h"
#import "YFSpecialLinePaymentTypeView.h"
#import "YFInverGeoModel.h"
#import "YFTwoInverGeoModel.h"
#import "YFSpecialLineModel.h"
#import "YFTwoInverGeoModel.h"
#import "YFSpecialLineListModel.h"
#import "YFUmengTracking.h"

@interface YFSpecialLineViewModel()
@property (nonatomic, strong, nullable) YFOtherRequirementView *otherView;//其他要求
@property (nonatomic, strong, nullable) YFGoodsNameView *nameView;//货品名称
@property (nonatomic, strong, nullable) YFSpecialLinePaymentTypeView *paymentTypeView;//付款方式
@property (nonatomic, strong, nullable) YFConsignerModel *startAddressModel;//出发地 model
@property (nonatomic, strong, nullable) YFAddressModel *endAddressModel;//目的地 model
@property (nonatomic, strong, nullable) YFSpecialLineModel *specialLimodel;//其他费用 model
@property (nonatomic, assign)           NSInteger section,row;//当前用户选中的哪个区 哪一行
@property (nonatomic, assign)           double totalFree,otherMoney;//运费总和,其他运费总和
//*出发地和目的地的经纬度*/
@property (nonatomic, assign)           CGFloat startSiteLongitude,startSiteLatitude,endSiteLongitude,endSiteLatitude;
@property (nonatomic, copy, nullable)   NSString *unloadWay,*remark;//其他要求和备注
@property (nonatomic, copy, nullable)   NSString *cashMoney,*toPayMoney,*backMoney;//付款方式 到付, 现付, 回付
@property (nonatomic, strong, nullable) NSMutableArray *goodsDataArr;
@end

@implementation YFSpecialLineViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr            = [[NSMutableArray alloc]initWithCapacity:0];
        self.dataArr            = [YFHomeDataModel mj_objectArrayWithKeyValuesArray:[NSArray getSpecialLineData]];
        self.otherMoney         = 0.00;
    }
    return self;
}

- (void)setItemModel:(YFSpecialLineListModel *)itemModel{
    if (itemModel) {
        //再下一单
        [self reorderWithData:itemModel];
    }else{
        self.netWorkGroup       = dispatch_group_create();//创建队列
        [self getAddressNetWork];
    }
}

#pragma mark 再来一单 赋值
- (void)reorderWithData:(YFSpecialLineListModel *)detailModel{
    if (detailModel.goodsModel.count != 1) {
        //如果detailModel中的货品信息就不止一条数据就不需要添加
        [self reorderAddGoodsInformationWithData:detailModel];
    }
    for (int i = 0; i < self.dataArr.count; i ++) {
        NSArray *sectionArr                     = self.dataArr[i];
        for (int j = 0; j < sectionArr.count; j ++) {
            YFHomeDataModel *model              = self.dataArr[i][j];
            model.isCheck                       = YES;
            if (i == 0 && j == 0) {
                //始发地
                model.title                     = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:detailModel.consignerContacts],[NSString getNullOrNoNull:detailModel.consignerMobile]];
                model.placeholder               = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:detailModel.sendSite],[NSString getNullOrNoNull:detailModel.consignerAddr]];
                self.startAddressModel          = [[YFConsignerModel alloc]init];
                self.startAddressModel.consignerAddr = detailModel.consignerAddr;
                self.startAddressModel.consignerCity = detailModel.sendSite;
                self.startAddressModel.consignerContacts = detailModel.consignerContacts;
                self.startAddressModel.consignerMobile = detailModel.consignerMobile;
                self.startAddressModel.siteCode = detailModel.sendSiteId;
                self.startSiteLatitude          = detailModel.consignerLatitude;
                self.startSiteLongitude         = detailModel.consignerLongitude;
                //把地址转为经纬度
            }else if (i == 0 && j == 1){
                //目的地
                model.title                     = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:detailModel.receiverContacts],[NSString getNullOrNoNull:detailModel.receiverMobile]];
                model.placeholder               = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:detailModel.recvSite],[NSString getNullOrNoNull:detailModel.receiverAddr]];
                self.endAddressModel            = [[YFAddressModel alloc]init];
                self.endAddressModel.receiverAddr = detailModel.receiverAddr;
                self.endAddressModel.receiverCity = detailModel.recvSite;
                self.endAddressModel.receiverMobile = detailModel.receiverMobile;
                self.endAddressModel.receiverContacts = detailModel.receiverContacts;
                self.endAddressModel.siteCode   = detailModel.recvSiteId;
                self.endSiteLatitude            = detailModel.receiverLatitude;
                self.endSiteLongitude           = detailModel.receiverLongitude;
                
            }else if (i == 1 && j != 0){
                //货品信息
                for (int g = 0; g < j; g ++) {
                    model.placeholder            = [detailModel.goodsModel[g] goodsName];
                    model.countNumTF             = [detailModel.goodsModel[g] goodsNumber];
                    model.weightTF               = [detailModel.goodsModel[g] goodsWeight];
                    model.volumeTF               = [detailModel.goodsModel[g] goodsVolume];
                    model.freeTF                 = [NSString stringWithFormat:@"%.f",[detailModel.goodsModel[g] shipAmount]];
                }
            }else if (i == 2 && j == 0){
                //其他费用
                if (![NSString isBlankString:[self reorderOtherWithData:detailModel]]) {
                    model.placeholder            = [self reorderOtherWithData:detailModel];
                }else{
                    model.isCheck                = NO;
                }
                self.specialLimodel              = [[YFSpecialLineModel alloc]init];
                self.specialLimodel.adjustTotalPrice = [NSString stringWithFormat:@"%.2f",detailModel.declareValue];
                self.specialLimodel.adjustMoney  = [NSString stringWithFormat:@"%.2f",detailModel.baoJiaFee];
                self.specialLimodel.collectionTotalPrice = [NSString stringWithFormat:@"%.2f",detailModel.daiShouHuoKuanFee];
                self.specialLimodel.collectionMoney = [NSString stringWithFormat:@"%.2f",detailModel.shouXuFee];
                self.specialLimodel.informationTF = [NSString stringWithFormat:@"%.2f",detailModel.xinXiFee];
                self.specialLimodel.takeGoodsTF  = [NSString stringWithFormat:@"%.2f",detailModel.tiHuoFee];
                self.specialLimodel.giveGoodsTF  = [NSString stringWithFormat:@"%.2f",detailModel.songHuoFee];
                self.specialLimodel.returnOrderTF = [NSString stringWithFormat:@"%.2f",detailModel.huiDanFee];
            }else if (i == 2 && j == 1){
                //付款方式
                model.placeholder                = [self reorderPaymentWithData:detailModel];
                self.totalFree                   = [detailModel.xianfuFee doubleValue];
                self.cashMoney                   = detailModel.xianfuFee;
                self.toPayMoney                  = detailModel.daofuFee;
                self.backMoney                   = detailModel.huifuFee;
            }else if (i == 2 && j == 2){
                //其他要求
                if ([detailModel.remark isEqualToString:@";"]) {
                    model.isCheck                = NO;
                }else{
                    NSArray *remarkArr           = [detailModel.remark componentsSeparatedByString:@";"];
                    if ([NSString isBlankString:[remarkArr firstObject]]) {
                        model.placeholder        = [NSString getNullOrNoNull:[remarkArr lastObject]];
                    }else if ([NSString isBlankString:[remarkArr lastObject]]){
                        model.placeholder        = [NSString getNullOrNoNull:[remarkArr firstObject]];
                    }else{
                        model.placeholder        = [NSString stringWithFormat:@"%@/%@",[remarkArr firstObject],[remarkArr lastObject]];
                    }
                    self.unloadWay               = [remarkArr firstObject];
                    self.remark                  = [remarkArr lastObject];
                }
                
            }
        }
    }
    !self.operationSuccessBlock ? : self.operationSuccessBlock(0,0);
}

/**
 计算付款方式
 */
- (NSString *)reorderPaymentWithData:(YFSpecialLineListModel *)model{
    if ([model.xianfuFee doubleValue] == 0.00) {
        //如果现付为0
        return @"现付：0.00";
    }else if ([model.xianfuFee doubleValue] != 0.00 && [model.daofuFee doubleValue] != 0 && [model.huifuFee doubleValue] != 0){
        //如果现付 到付, 回付都不为0
        return [NSString stringWithFormat:@"现付%@/到付../回付..",model.xianfuFee];
    }else if ([model.xianfuFee doubleValue] != 0.00 && [model.daofuFee doubleValue] == 0 && [model.huifuFee doubleValue] != 0){
        //现付 回付不为0 到付为0
        return [NSString stringWithFormat:@"现付%@/回付..",model.xianfuFee];
    }else if ([model.xianfuFee doubleValue] != 0.00 && [model.daofuFee doubleValue] != 0 && [model.huifuFee doubleValue] == 0){
        //现付 到付 不为0  回付 为0
        return [NSString stringWithFormat:@"现付%@/到付..",model.xianfuFee];
    }else if ([model.xianfuFee doubleValue] != 0.00 && [model.daofuFee doubleValue] == 0 && [model.huifuFee doubleValue] == 0){
        return [NSString stringWithFormat:@"现付%@",model.xianfuFee];
    }
    return @"";
}

/**
 计算其他费用
 */
- (NSString *)reorderOtherWithData:(YFSpecialLineListModel *)model{
    double sum = model.baoJiaFee + model.shouXuFee+ model.xinXiFee + model.tiHuoFee + model.songHuoFee + model.huiDanFee;
    if (sum == 0.00) {
        return @"";
    }
    return [NSString stringWithFormat:@"%.2f元",sum];
}

/**
 更具货品信息添加 数据从而达到增加 cell 的目的 如果是 一个货品则不需要添加,两个货品那么增加1 以此类推
 */
- (void)reorderAddGoodsInformationWithData:(YFSpecialLineListModel *)model{
    for (int i = 1; i < model.goodsModel.count; i ++) {
        NSDictionary *dict          = @{@"title":@"货品名称",@"imgName":@"free",@"placeholder":@"点击选择",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""};
        //拿到第二个section的数据在添加到sectionArr
        NSMutableArray *sectionArr  = [NSMutableArray arrayWithArray:self.dataArr[1]];
        [sectionArr addObject:dict];
        //移除数据源的中第二个 section
        [self.dataArr removeObjectAtIndex:1];
        //添加数据到数据源中
        [self.dataArr insertObject:sectionArr atIndex:1];
        self.dataArr                = [YFHomeDataModel mj_objectArrayWithKeyValuesArray:self.dataArr];
    }
}

#pragma mark 添加货品信息
- (void)addGoodsInformationWithSection:(NSInteger)section selectIndex:(NSInteger)selectIndex{
    if ([self.dataArr[1] count] == 11) {
        return;
    }
    NSDictionary *dict          = @{@"title":@"货品名称",@"imgName":@"free",@"placeholder":@"点击选择",@"isCheck":@0,@"countNumTF":@"",@"weightTF":@"",@"volumeTF":@"",@"freeTF":@""};
    //拿到第二个section的数据在添加到sectionArr
    NSMutableArray *sectionArr  = [NSMutableArray arrayWithArray:self.dataArr[section]];
    [sectionArr addObject:dict];
    //移除数据源的中第二个 section
    [self.dataArr removeObjectAtIndex:section];
    //添加数据到数据源中
    [self.dataArr insertObject:sectionArr atIndex:section];
    self.dataArr            = [YFHomeDataModel mj_objectArrayWithKeyValuesArray:self.dataArr];
    !self.operationSuccessBlock ? : self.operationSuccessBlock(section,selectIndex);
}

#pragma mark 删除货品信息
- (void)deleteGoodsInformationWithSection:(NSInteger)section selectIndex:(NSInteger)selectIndex{
    //拿到第二个section的数据在添加到sectionArr
    NSMutableArray *sectionArr  = [NSMutableArray arrayWithArray:self.dataArr[section]];
    //删除对应的数据
    [sectionArr removeObjectAtIndex:selectIndex];
    //删除指定section
    [self.dataArr removeObjectAtIndex:section];
    //添加数据到数据源中
    [self.dataArr insertObject:sectionArr atIndex:section];
    !self.operationSuccessBlock ? : self.operationSuccessBlock(section,selectIndex);
    //重新计算运费
    [self calculatedTotalFree];
}

#pragma mark 选择货品名称
- (void)chooseGoodsNameWithSection:(NSInteger)section selectIndex:(NSInteger)selectIndex{
    self.section                                        = section;
    self.row                                            = selectIndex;
    [self chooseGoodsName];
}

#pragma mark 获取出发地与目的地地址
-(void)getAddressNetWork{
    WS(weakSelf)
    dispatch_group_async(_netWorkGroup, dispatch_get_main_queue(), ^{
        dispatch_group_enter(_netWorkGroup);
        [weakSelf getStartAddress];
    });
    
    dispatch_group_async(_netWorkGroup, dispatch_get_main_queue(), ^{
        dispatch_group_enter(_netWorkGroup);
        [weakSelf getEndAddress];
    });
    
    dispatch_group_notify(_netWorkGroup, dispatch_get_main_queue(), ^{
        !weakSelf.operationSuccessBlock ? : weakSelf.operationSuccessBlock (0,0);
    });
    
}

- (void)getStartAddress{
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"userConsigner/list.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSArray *dataArr                            = [YFConsignerModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            for (YFConsignerModel *Cmodel in dataArr) {
                if (Cmodel.isDefault) {
                    YFHomeDataModel *model              = self.dataArr[0][0];
                    NSString *name                      = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:Cmodel.consignerContacts],[NSString getNullOrNoNull:Cmodel.consignerMobile]];
                    NSString *addressStr                = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:Cmodel.consignerCity],[NSString getNullOrNoNull:Cmodel.consignerAddr]];
                    model.placeholder                   = addressStr;
                    model.title                         = name;
                    model.isCheck                       = YES;
                    //得到出发地相关数据
                    self.startAddressModel              = Cmodel;
                    //把地址转为经纬度
                    [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:addressStr];
                    [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                        //出发地
                        self.startSiteLatitude      = latitude;
                        self.startSiteLongitude     = longitude;
                    };
                }
            }
            dispatch_group_leave(self.netWorkGroup);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getEndAddress{
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"userReceiver/list.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            NSArray *dataArr                        = [YFAddressModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            for (YFAddressModel *Cmodel in dataArr) {
                if (Cmodel.isDefault) {
                    YFHomeDataModel *model          = self.dataArr[0][1];
                    NSString *name                  = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:Cmodel.receiverContacts],[NSString getNullOrNoNull:Cmodel.receiverMobile]];
                    NSString *addressStr            = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:Cmodel.receiverCity],[NSString getNullOrNoNull:Cmodel.receiverAddr]];
                    model.placeholder               = addressStr;
                    model.title                     = name;
                    model.isCheck                   = YES;
                    //得到目的地相关数据
                    self.endAddressModel            = Cmodel;
                    //把地址转为经纬度
                    YFTwoInverGeoModel *geoModel    = [[YFTwoInverGeoModel alloc]init];
                    [geoModel getLatitudeAndlongitudeWithAddress:addressStr];
                    geoModel.latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                        //目的地
                        self.endSiteLatitude        = latitude;
                        self.endSiteLongitude       = longitude;
                    };
                }
            }
            dispatch_group_leave(self.netWorkGroup);
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 计算运费总和
- (void)calculatedTotalFree{
    //遍历第二组的数据 拿到每个货品名称的运费价格
    self.totalFree                           = 0.0;
    for (YFHomeDataModel *model in self.dataArr[1]) {
        self.totalFree                       = self.totalFree + [model.freeTF doubleValue];
    }
    DLog(@"%.2f",self.totalFree);
    self.totalFree                           = self.totalFree + self.otherMoney;
    if (self.totalFree != 0) {
        //    sumFree
        //设置付款方式的金额
        YFHomeDataModel *totalMoneyModel         = self.dataArr[2][1];
        totalMoneyModel.isCheck                  = YES;
        totalMoneyModel.placeholder              = [NSString stringWithFormat:@"现付%.2f",self.totalFree];
        self.cashMoney                           = [NSString stringWithFormat:@"%.2f",self.totalFree];
    }else{
        YFHomeDataModel *totalMoneyModel         = self.dataArr[2][1];
        totalMoneyModel.isCheck                  = NO;
        totalMoneyModel.placeholder              = @"请选择付款方式";
    }
    !self.operationSuccessBlock ? : self.operationSuccessBlock (2,1);
}

#pragma mark 页面跳转
- (void)jumpCtrlWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index{
    WS(weakSelf)
    if (section == 0) {
        if (index == 0) {
            //出发地
            YFChooseAddressListViewController *address      = [YFChooseAddressListViewController new];
            address.isConsignor                             = YES;
            address.addressId                               = self.startAddressModel.Id;
            address.chooseAddressType                       = SpecialLineSourceGoods;
            address.backCaddressBlock                       = ^(YFConsignerModel *addressModel){
                //得到出发地相关数据
                weakSelf.startAddressModel                  = addressModel;
                YFHomeDataModel *model                      = self.dataArr[section][index];
                model.isCheck                               = YES;
                model.title                                 = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:addressModel.consignerContacts],[NSString getNullOrNoNull:addressModel.consignerMobile]];
                model.placeholder                           = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:addressModel.consignerCity],[NSString getNullOrNoNull:addressModel.consignerAddr]];
                //把地址转为经纬度
                [[YFInverGeoModel sharedYFInverGeoModel] getLatitudeAndlongitudeWithAddress:model.placeholder];
                [YFInverGeoModel sharedYFInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                    //出发地
                    weakSelf.startSiteLatitude              = latitude;
                    weakSelf.startSiteLongitude             = longitude;
                };
                !weakSelf.operationSuccessBlock ? : weakSelf.operationSuccessBlock (section,index);
            };
            [self.superVC.navigationController pushViewController:address animated:YES];
        }else{
            //目的地
            YFChooseAddressListViewController *address      = [YFChooseAddressListViewController new];
            address.chooseAddressType                       = SpecialLineSourceGoods;
            address.addressId                               = self.endAddressModel.Id;
            address.backAddressBlock                        = ^(YFAddressModel *addressModel){
                //得到目的地相关数据
                weakSelf.endAddressModel                    = addressModel;
                YFHomeDataModel *model                      = self.dataArr[section][index];
                model.isCheck                               = YES;
                model.title                                 = [NSString stringWithFormat:@"%@  %@",[NSString getNullOrNoNull:addressModel.receiverContacts],[NSString getNullOrNoNull:addressModel.receiverMobile]];
                model.placeholder                           = [NSString stringWithFormat:@"%@%@",[NSString getNullOrNoNull:addressModel.receiverCity],[NSString getNullOrNoNull:addressModel.receiverAddr]];
                //把地址转为经纬度
                [[YFTwoInverGeoModel sharedYFTwoInverGeoModel] getLatitudeAndlongitudeWithAddress:model.placeholder];
                [YFTwoInverGeoModel sharedYFTwoInverGeoModel].latitudeAndlongitudeBlock = ^(CGFloat latitude, CGFloat longitude){
                    //出发地
                    weakSelf.endSiteLatitude                = latitude;
                    weakSelf.endSiteLongitude               = longitude;
                };
                !weakSelf.operationSuccessBlock ? : weakSelf.operationSuccessBlock (section,index);
            };
            [self.superVC.navigationController pushViewController:address animated:YES];
        }
    }else if (section == 2){
        self.section                                        = section;
        self.row                                            = index;
        if (index == 0) {
            //其他费用
            YFSpecialLineOtherFreeViewController *other     = [YFSpecialLineOtherFreeViewController new];
            other.specilLineModel                           = self.specialLimodel;
            other.allOtherFreeBlock                         = ^(YFSpecialLineModel *specialModel, double otherFree){
                DLog(@"%.2f",otherFree);
                YFHomeDataModel *totalMoneyModel            = self.dataArr[section][index];
                totalMoneyModel.isCheck                     = YES;
                totalMoneyModel.placeholder                 = [NSString stringWithFormat:@"%.2f",otherFree];
                weakSelf.otherMoney                         = otherFree;
                weakSelf.specialLimodel                     = specialModel;
                !weakSelf.operationSuccessBlock ? : weakSelf.operationSuccessBlock (section,index);
                [weakSelf calculatedTotalFree];
            };
            [self.superVC.navigationController pushViewController:other animated:YES];
        }else if (index == 1){
            YFHomeDataModel *pModel                         = self.dataArr[section][index];
            //付款方式
            self.paymentTypeView.sumPrice                   = self.totalFree;
            self.paymentTypeView.cashPrice                  = self.cashMoney;
            if ([pModel.placeholder isEqualToString:[NSString stringWithFormat:@"现付%.2f",self.totalFree]]) {
                //如果说运费有改动 需要重新设置到付 和回付
                self.paymentTypeView.toPrice                = @"0";
                self.paymentTypeView.backPrice              = @"0";
            }else{
                self.paymentTypeView.toPrice                = self.toPayMoney;
                self.paymentTypeView.backPrice              = self.backMoney;
            }
            [self.paymentTypeView show:YES];
        }else if (index == 2){
            //其他要求
            [self chooseOtherRequirement];
        }
    }
}

#pragma mark 发布专线数据
- (void)postSpecialLineData{
    [self.superVC.view endEditing:YES];
    
    NSString *alertMsg;
    if ([NSString isBlankString:[self.dataArr[0][0] title]]) {
        alertMsg                                    = @"请选择发货地址和联系人";
    }else if ([[self.dataArr[0][0] title] isEqualToString:@"请选择发货地址和联系人"]){
        alertMsg                                    = @"请选择发货地址和联系人";
    }else if ([NSString isBlankString:[self.dataArr[0][1] title]]){
        alertMsg                                    = @"请选择收货地址和联系人";
    }else if ([[self.dataArr[0][1] title] isEqualToString:@"请选择收货地址和联系人"]){
        alertMsg                                    = @"请选择收货地址和联系人";
    }else{
        for (int i = 0; i < [[self getGoodsInformationDataArray] count]; i ++) {
            NSDictionary *dict                      = [self getGoodsInformationDataArray][i];
            YFSpecialGoodsInformationModel *model   = [YFSpecialGoodsInformationModel mj_objectWithKeyValues:dict];
            if ([NSString isBlankString:model.goodsName]) {
                alertMsg                            = [NSString stringWithFormat:@"请输入第%d个的货品名称",i+1];
                 break;
            }else if ([NSString isBlankString:model.goodsNumber]){
                alertMsg                            = [NSString stringWithFormat:@"请输入第%d个的货品件数",i+1];
                break;
            }else if ([NSString isBlankString:model.goodsWeight]){
                alertMsg                            = [NSString stringWithFormat:@"请输入第%d个的货品重量",i+1];
                break;
            }else if ([NSString isBlankString:model.goodsVolume]){
                alertMsg                            = [NSString stringWithFormat:@"请输入第%d个的货品体积",i+1];
                break;
            }else if ([NSString isBlankString:model.fee]){
                alertMsg                            = [NSString stringWithFormat:@"请输入第%d个的货品运费",i+1];
                break;
            }
        }
    }
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.superVC.view];
        return;
    }
    
    NSMutableDictionary *parms                       = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.startAddressModel.consignerAddr forKey:@"consignerAddr"];//发货人详细地址
//    [parms safeSetObject:self.startAddressModel.Id forKey:@"consignerAddrId"];
    [parms safeSetObject:self.startAddressModel.consignerCity forKey:@"consignerCity"];//发货人省市区
    [parms safeSetObject:self.startAddressModel.consignerContacts forKey:@"consignerContacts"];//联系人
    [parms safeSetObject:self.startAddressModel.consignerMobile forKey:@"consignerMobile"];//手机号
    [parms safeSetObject:self.startAddressModel.consignerContacts forKey:@"consignerName"];//发货方姓名
    [parms safeSetObject:self.startAddressModel.siteCode forKey:@"consignerSiteCode"];//发货方地址编码
    [parms safeSetObject:@(self.startSiteLatitude) forKey:@"consignerLatitude"];
    [parms safeSetObject:@(self.startSiteLongitude) forKey:@"consignerLongitude"];
    [parms safeSetObject:[self getGoodsInformationDataArray] forKey:@"goodsModels"];//货品信息
    [parms safeSetObject:self.endAddressModel.receiverAddr forKey:@"receiverAddr"];//详细地址
    [parms safeSetObject:self.endAddressModel.receiverCity forKey:@"receiverCity"];//省市区
    [parms safeSetObject:self.endAddressModel.receiverContacts forKey:@"receiverContacts"];//联系人
    [parms safeSetObject:self.endAddressModel.receiverMobile forKey:@"receiverMobile"];//电话
    [parms safeSetObject:self.endAddressModel.receiverContacts forKey:@"receiverName"];//
//    [parms safeSetObject:self.endAddressModel.Id forKey:@"receiverAddrId"];//
    [parms safeSetObject:self.endAddressModel.siteCode forKey:@"receiverSiteCode"];//收货方地址编码
    [parms safeSetObject:@(self.endSiteLatitude) forKey:@"receiverLatitude"];//收货方经度
    [parms safeSetObject:@(self.endSiteLongitude) forKey:@"receiverLongitude"];//收货方纬度
    [parms safeSetObject:self.unloadWay forKey:@"unloadWay"];//其他要求
    [parms safeSetObject:self.remark forKey:@"remark"];
    [parms safeSetObject:self.specialLimodel.adjustTotalPrice forKey:@"declareValue"];//申明价值
    [parms safeSetObject:self.specialLimodel.adjustMoney forKey:@"baoJiaFee"];//保价费
    [parms safeSetObject:self.specialLimodel.collectionTotalPrice forKey:@"daiShouHuoKuanFee"];//代收货款
    [parms safeSetObject:self.specialLimodel.collectionMoney forKey:@"shouXuFee"];//手续费
    [parms safeSetObject:self.specialLimodel.informationTF forKey:@"xinXiFee"];//信息费
    [parms safeSetObject:self.specialLimodel.takeGoodsTF forKey:@"tiHuoFee"];//提货费
    [parms safeSetObject:self.specialLimodel.giveGoodsTF forKey:@"songHuoFee"];//送货费
    [parms safeSetObject:self.specialLimodel.returnOrderTF forKey:@"huiDanFee"];//回单费
    [parms safeSetObject:self.cashMoney forKey:@"xianfuFee"];//现付费
    [parms safeSetObject:self.toPayMoney forKey:@"daofuFee"];//到付费
    [parms safeSetObject:self.backMoney forKey:@"huifuFee"];//回付费
    WS(weakSelf)
    [GiFHUD showWithOverlay];
    [WKRequest postWithURLString:@"app/special/ordered.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        [GiFHUD dismiss];
        if (CODE_ZERO) {
            //发布成功之后 统计
            [YFUmengTracking umengEvent:@"PostSpecialLine"];
            
            [YFToast showMessage:@"发布成功" inView:weakSelf.superVC.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [weakSelf.superVC selectTabbarIndex:2];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [weakSelf.superVC.navigationController popViewControllerAnimated:NO];
                        [YFNotificationCenter postNotificationName:@"JumpSpecialLineKeys" object:nil];
                    }];
                }];
            });
        }else{
            [YFToast showMessage:baseModel.message inView:weakSelf.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 得到货品信息相关数据
 */
- (NSMutableArray *)getGoodsInformationDataArray{
    self.goodsDataArr                                = [[NSMutableArray alloc]initWithCapacity:0];
    //因为第一条数据不是货品信息 所以需要从第二条数据开始
    for (int i = 1; i < [self.dataArr[1] count] ; i ++) {
        YFHomeDataModel *model                       = self.dataArr[1][i];
        NSMutableDictionary *dict                    = [NSMutableDictionary dictionary];
        [dict safeSetObject:model.freeTF forKey:@"fee"];
        [dict safeSetObject:[model.placeholder isEqualToString:@"点击选择"] ? @"" : model.placeholder forKey:@"goodsName"];
        [dict safeSetObject:model.countNumTF forKey:@"goodsNumber"];
        [dict safeSetObject:model.volumeTF forKey:@"goodsVolume"];
        [dict safeSetObject:model.weightTF forKey:@"goodsWeight"];
        [self.goodsDataArr addObject:dict];
    }
    return self.goodsDataArr;
}

#pragma mark 其他要求
-(void)chooseOtherRequirement{
    self.otherView.hidden                            = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.otherView.backgroundColor               = [UIColor colorWithWhite:0.000 alpha:0.299]
        ;
        self.otherView.y                             = -300;
    }];
}

-(YFOtherRequirementView *)otherView{
    if (!_otherView) {
        _otherView                                   = [[[NSBundle mainBundle] loadNibNamed:@"YFOtherRequirementView" owner:nil options:nil] lastObject];
        _otherView.frame                             = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
        @weakify(self)
        _otherView.callBackCarTypeBlock              = ^(NSString *otherRequire , NSString *remark){
            @strongify(self)
            DLog(@"%@",otherRequire);
            self.unloadWay                           = otherRequire;
            self.remark                              = remark;
            YFHomeDataModel *model                   = self.dataArr[self.section][self.row];
            model.placeholder                        = [NSString getCarMessageWithFirst:otherRequire AndSecond:remark];;
            model.isCheck                            = YES;
            !self.operationSuccessBlock ? : self.operationSuccessBlock (self.section,self.row);
        };
        [YFWindow addSubview:_otherView];
    }
    return _otherView;
}

#pragma mark  货品名称
-(void)chooseGoodsName{
    self.nameView.hidden                            = NO;
    [self.nameView refresh];
    [UIView animateWithDuration:0.25 animations:^{
        self.nameView.backgroundColor               = [UIColor colorWithWhite:0.000 alpha:0.299]
        ;
        self.nameView.y                             = -310;
    }];
}

-(YFGoodsNameView *)nameView{
    if (!_nameView) {
        _nameView                                   = [[[NSBundle mainBundle] loadNibNamed:@"YFGoodsNameView" owner:nil options:nil] lastObject];
        _nameView.frame                             = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 310);
        @weakify(self)
        _nameView.callBackCarTypeBlock              = ^(NSString *googsName){
            @strongify(self)
            DLog(@"%@",googsName);
            YFHomeDataModel *model                  = self.dataArr[self.section][self.row];
            model.placeholder                       = googsName;
            model.isCheck                           = YES;
            !self.operationSuccessBlock ? : self.operationSuccessBlock (self.section,self.row);
        };
        [YFWindow addSubview:_nameView];
    }
    return _nameView;
}

#pragma mark 付款方式
- (YFSpecialLinePaymentTypeView *)paymentTypeView{
    if (!_paymentTypeView) {
        _paymentTypeView                               = [[[NSBundle mainBundle] loadNibNamed:@"YFSpecialLinePaymentTypeView" owner:nil options:nil] lastObject];
        @weakify(self)
        _paymentTypeView.payMentTypeMoneyDetailBlock   = ^(NSString *cashMoney, NSString *toPayMoney, NSString *backMoney,NSString *moneyString){
            //确定
            @strongify(self)
            DLog(@"%@--%@---%@",cashMoney,toPayMoney,backMoney);
            self.cashMoney                             = cashMoney;
            self.toPayMoney                            = toPayMoney;
            self.backMoney                             = backMoney;
            YFHomeDataModel *model                     = self.dataArr[self.section][self.row];
            model.placeholder                          = moneyString;
            model.isCheck                              = YES;
            !self.operationSuccessBlock ? : self.operationSuccessBlock (self.section,self.row);
        };
        _paymentTypeView.cancelPayMentTypeMoneyDetailBlock = ^(NSString *cashMoney, NSString *toPayMoney, NSString *backMoney, NSString *moneyString) {
            @strongify(self)
            //取消
            self.cashMoney                             = cashMoney;
            self.toPayMoney                            = toPayMoney;
            self.backMoney                             = backMoney;
            self.totalFree                             = [cashMoney doubleValue];
            YFHomeDataModel *model                     = self.dataArr[self.section][self.row];
            model.placeholder                          = moneyString;
            model.isCheck                              = YES;
            !self.operationSuccessBlock ? : self.operationSuccessBlock (self.section,self.row);
        };
        [YFWindow addSubview:_paymentTypeView];
    }
    return _paymentTypeView;
}


@end
