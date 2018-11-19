//
//  WKRequest.m
//  YukiFramework
//
//  Created by 王宇 on 2017/11/13.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "WKRequest.h"
#import "Reachability.h"
#define TIMEOUT 15
#define ERROE @"服务端繁忙,请稍后再试!"
@implementation WKRequest


/**
 *  是否显示HUD,YES  is show
 */
+ (void)isHiddenActivityView:(BOOL)isHidden{
    objc_setAssociatedObject(self,@"ISSHOW", isHidden?@"YES":@"NO", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 网络监听
 */
+ (BOOL)YFNetWorkReachability{
    BOOL netState = NO;
    Reachability *reMan = [Reachability reachabilityForInternetConnection];
    NetworkStatus  Status = [reMan currentReachabilityStatus];
    
    switch (Status) {
        case NotReachable:
//            DLog(@"网络未连接");
            netState = NO;
            break;
            
        case ReachableViaWiFi:
//            DLog(@"WIFI网络");
            netState = YES;
            break;
            
        case ReachableViaWWAN:
//            DLog(@"2G,3G,4G网络");
            netState = YES;
            break;
            
        default:
            netState = NO;
            break;
    }
    
    return netState;
}

/**
 *  get 网络请求
 *
 *  @param urlString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)getWithURLString:(NSString *)urlString
             parameters:(id)parameters
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock{

    NSString *isShow =  objc_getAssociatedObject(self, @"ISSHOW");
    if ([isShow isEqualToString:@"NO"] || [NSString isBlankString:isShow]) {
        [GiFHUD showWithOverlay];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //可以接受的类型 AFHTTPResponseSerializer 手动解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    NSString *header = [UserData userInfo].token;
//
    [manager.requestSerializer setValue:header forHTTPHeaderField:@"token"];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //请求超时的时间
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    //请求url
    NSString *hostUrl = [NSString stringWithFormat:@"%@%@",HOST_URL,urlString];
    
    //把请求头进行 UTF-8编码
    NSString *path = [hostUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    DLog(@"接口 + 参数:%@-----------%@",hostUrl,[self dictionTransformationJson:parameters]);
    WS(weakSelf)
    [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        [weakSelf isHiddenActivityView:NO];
        if (successBlock) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            WKBaseModel *baseModel = [[WKBaseModel alloc]initWithJsonObject:dic];
            [weakSelf tokenInvalid:baseModel];
            successBlock(baseModel);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        [YFToast showMessage:ERROE inView: [[[YFKeyWindow shareInstance] getCurrentVC] view]];
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

/**
 get 请求  请求注册协议
 
 @param urlString 请求地址
 @param parameters 请求参数
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 */
+(void)getRegisterWithURLString:(NSString *)urlString
                     parameters:(id)parameters
                        success:(void(^)(NSString *))successBlock
                        failure:(FailureBlock)failureBlock{
    NSString *isShow =  objc_getAssociatedObject(self, @"ISSHOW");
    if (![isShow isEqualToString:@"NO"]) {
        dispatch_barrier_async(dispatch_get_main_queue(), ^(void){
            [GiFHUD showWithOverlay];
        });
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //可以接受的类型 AFHTTPResponseSerializer 手动解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //请求超时的时间
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    //请求url
    NSString *hostUrl = [NSString stringWithFormat:@"%@%@",HOST_URL,urlString];
    
    //把请求头进行 UTF-8编码
    NSString *path = [hostUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    DLog(@"接口 + 参数:%@-----------%@",hostUrl,[self dictionTransformationJson:parameters]);

    [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (successBlock) {
            successBlock(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        [YFToast showMessage:ERROE inView: [[[YFKeyWindow shareInstance] getCurrentVC] view]];
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


/**
 *  post网络请求
 *
 *  @param urlString    请求的网址字符串
 *  @param parameters   请求的参数
 *  @param isJson 现在YES 或者 NO 都是一样的 
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)postWithURLString:(NSString *)urlString
              parameters:(id)parameters
                  isJson:(BOOL)isJson
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock{
    
    NSString *isShow =  objc_getAssociatedObject(self, @"ISSHOW");
    if ([isShow isEqualToString:@"NO"] || [NSString isBlankString:isShow]) {
        [GiFHUD showWithOverlay];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //可以接受的类型
    if (isJson) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }else{
        //AFJSONRequestSerializer 自动解析 在我们 app 中的 post 请求必须用这个
        manager.requestSerializer = [AFJSONRequestSerializer serializer];//
    }

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    NSString *header = [UserData userInfo].token;
    // 注册接口 需要把把参数进行 UTF-8编码
    if ([urlString isEqualToString:@"register/regBase.do"]) {
        
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
    }else{
        [manager.requestSerializer setValue:header forHTTPHeaderField:@"token"];
        
//        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    // 请求超时时间
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    //请求url
    NSString *hostUrl=[NSString stringWithFormat:@"%@%@",HOST_URL,urlString];

    //把请求头进行 UTF-8编码
    NSString *path = [hostUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *parms = [parameters mutableCopy];

    DLog(@"接口 + 参数:%@-----------%@",hostUrl,[self dictionTransformationJson:parameters]);
    WS(weakSelf)
    [manager POST:path parameters:parms progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        [weakSelf isHiddenActivityView:NO];
        if (successBlock) {
            if (isJson) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                WKBaseModel *baseModel = [[WKBaseModel alloc]initWithJsonObject:dic];
                [weakSelf tokenInvalid:baseModel];
                successBlock(baseModel);
            }else{
                WKBaseModel *baseModel = [[WKBaseModel alloc]initWithJsonObject:responseObject];
                [weakSelf tokenInvalid:baseModel];
                successBlock(baseModel);
            }

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        [YFToast showMessage:ERROE inView: [[[YFKeyWindow shareInstance] getCurrentVC] view]];
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    

}

/**
 post 请求上传图片
 
 @param urlString 请求地址
 @param parameters 请求参数
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 */
+ (void)postWithUrlString:(NSString *)urlString
               parameters:(id)parameters
              uploadImage:(UIImage *)image
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock{
    [GiFHUD showWithOverlay];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置token
    NSString *header = [UserData userInfo].token;
    [manager.requestSerializer setValue:header forHTTPHeaderField:@"token"];
    //2.上传文件
    NSString *hostUrl=[NSString stringWithFormat:@"%@%@",HOST_URL,urlString];
    WS(weakSelf)
    [manager POST:hostUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = UIImageJPEGRepresentation(image, 0.1);
        //上传文件参数
        [formData appendPartWithFileData:data name:@"userHeader" fileName:@"userHeader.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        DLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        if (successBlock) {
            WKBaseModel *baseModel = [[WKBaseModel alloc]initWithJsonObject:responseObject];
            [weakSelf tokenInvalid:baseModel];
            successBlock(baseModel);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        //请求失败
        [YFToast showMessage:ERROE inView: [[[YFKeyWindow shareInstance] getCurrentVC] view]];
        if (failureBlock) {
            failureBlock(error);
        }
        
    }];
}

/**
 字典转 Json

 @param parms 传入的字典,
 @return 返回的 json 字符串
 */
+ (NSString *)dictionTransformationJson:(NSDictionary *)parms{
    NSError *error;
    NSString *jsonStr = @"";
    if ([parms isKindOfClass:[NSDictionary class]]) {
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parms options:NSJSONWritingPrettyPrinted error:&error];
         jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}

/**
  token 失效
 @param baseModel 网络请求的返回值
 */
+ (void)tokenInvalid:(WKBaseModel *)baseModel{
    if (CODE_TOKEN) {
        //token 失效
        [UserData userInfo:nil];
//        KUSERNOTLOGIN
    }
}
@end
