//
//  YFAddressDataTool.m
//  YFKit
//
//  Created by 王宇 on 2018/12/11.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFAddressDataTool.h"

@implementation YFAddressDataTool

static YFAddressDataTool *_shareInstance;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[YFAddressDataTool alloc] init];
    });
    return _shareInstance;
}

#pragma mark 地址管理接口
- (void)getSendAddress:(void(^)(NSArray <YFAddressModel *> *models))resultBlock {
    [WKRequest getWithURLString:@"userConsigner/list.do" parameters:nil success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            NSArray <YFConsignerModel *> *sendModels = [YFConsignerModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            NSMutableArray <YFAddressModel *> *models = [NSMutableArray array];
            //因为后台返回的字段不一样, 所以转一下 model 同意一下
            for (YFConsignerModel *model in sendModels) {
                YFAddressModel *aModel = [[YFAddressModel alloc] init];
                aModel.Id = model.Id;
                aModel.isSelect = model.isSelect;
                aModel.isDefault = model.isDefault;
                aModel.receiverAddr = model.consignerAddr;
                aModel.receiverCity = model.consignerCity;
                aModel.receiverMobile = model.consignerMobile;
                aModel.receiverContacts = model.consignerContacts;
                aModel.siteCode = model.siteCode;
                aModel.remark = model.remark;
                [models addObject:aModel];
            }
            return resultBlock(models);
        }else {
            [YFToast showMessage:baseModel.message inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getReceiverAddress:(void(^)(NSArray <YFAddressModel *> *models))resultBlock {
    [WKRequest getWithURLString:@"userReceiver/list.do" parameters:nil success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            NSArray <YFAddressModel *> *models = [YFAddressModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            return resultBlock(models);
        }else {
            [YFToast showMessage:baseModel.message inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setDefaultAddressId:(NSString *)addressId
                addressType:(YFAddressType)addressType
               successBlock:(void(^)(void))successBlock {
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms safeSetObject:addressId forKey:@"id"];
    NSString *path = addressType == YFSendAddressType ? @"userConsigner/defaultAddr.do" :@"userReceiver/defaultAddr.do";
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            successBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setDeleteAddressId:(NSString *)addressId
               addressType:(YFAddressType)addressType
              successBlock:(void(^)(void))successBlock {
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms safeSetObject:addressId forKey:@"id"];
    NSString *path = addressType == YFSendAddressType ? @"userConsigner/delete.do" :@"userReceiver/delete.do";
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            successBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
