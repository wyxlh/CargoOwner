//
//  NSString+Regular.h
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (Regular)

/**
*  移除空格
*/
-(NSString *)removeWhiteSpace;

-(NSString *)removeWhiteline;
/**
 计算文字宽高

 @param fontSize fontSize description
 @param str str description
 @param width width description
 @return return value description
 */
+(CGSize)getStringSize:(float)fontSize withString:(NSString*)str andWidth:(CGFloat)width;

//是否是数字
- (BOOL)isPureIntStr;

/**
 //邮箱

 @param email email description
 @return return value description
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 //手机号码验证

 @param mobile mobile description
 @return return value description
 */
+ (BOOL) validateMobile:(NSString *)mobile;


/**
 判断座机号
 */
+ (BOOL)isTelPhoneNumber:(NSString *)mobileNum;

/**
 用户名

 @param name name description
 @return return value description
 */
+ (BOOL) validateUserName:(NSString *)name;


+(NSString *)getDigitsOnly:(NSString*)s;

+(BOOL)isValidCardNumber:(NSString *)cardNumber;

/**
 *  //密码
 *
 *  @param passWord passWord description
 *
 *  @return return value description
 */
+ (BOOL) validatePassword:(NSString *)passWord;


/**
 *  //昵称
 *
 *  @param nickname nickname description
 *
 *  @return return value description
 */
+ (BOOL) validateNickname:(NSString *)nickname;


/**
 *  //身份证号
 *
 *  @param identityCard identityCard description
 *
 *  @return return value description
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 车牌号
 */
+ (BOOL)isValidCarID:(NSString *)carID;

/**
 *  //格式化时间时间
 *
 
 */
+(NSString *)fomartDate:(NSString *)Date;


/**
 * 安全获取字符串
 * @param mStr 字符串
 * @returns 若字符串为nil，则返回@""，否则直接返回字符串
 */
+ (NSString *)strOrEmpty:(NSString *)mStr;

/**
 *  // 生成随机订单ID
 *
 *
 */
+ (NSString *)generateTradeNO;

/**
 *
 *  //获取手机IP
 *
 */
+ (NSString *)getPhoneIP;

/**
 *  //第一次进App
 *
 *
 */
+ (BOOL)isFirstTimeEnterApp;

/**
 *  MD5 加密字符串
 */
+ (NSString *)MD5NSString:(NSString *)string;

/**
 *  判断字符串是否为空
 */
+ (BOOL) isBlankString:(NSString *)string;
/**
 *  弱密码判断
 */
- (BOOL)weakPswd;
/**
 *  string转nsdate
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/**
 护照

 */
+ (BOOL) isValidPassport:(NSString*)value;

/**
 *  判断数字
 */
- (BOOL)isNumberString;

//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string;

/**
 判断是否汉字
 */
+ (BOOL)isAllChinese:(NSString *)str;

/**
 判断是否含有汉字
 */
+ (BOOL)IsChinese:(NSString *)str;

/**
 传入两个可为空的参数 返回对应的数据
 */
+ (NSString *)getCarMessageWithFirst:(NSString *)first AndSecond:(NSString *)second;

/**
 获取版本号
 */
+ (NSString *)getAppVersion;

/**
 得到车的类型 如果操过4个字就直接截掉后面的用...代替

 @param name 车型名
 @return 车型
 */
+ (NSString *)getCarTypeName:(NSString *)name;

/**
 传入一个字符串 返回一个城市名 取的是第一格  字符串截取
 */
+ (NSString *)getCityName:(NSString *)cityName;

/**
 传入一个字符串 返回一个时间 取的是第一格  字符串截取
 */
+ (NSString *)getCreateTime:(NSString *)CreateTime;

/**
 传入一个code 返回 最后一级 code
 */
+ (NSString *)getCityCode:(NSString *)addressCode;

/**
 得到发布的具体时间
 */
+(NSString *)getGoodsDetailTime:(NSString *)year WithStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime;

/**
入物品名称 重量 体积  数量
 */
+ (NSString *)getGoodsName:(NSString *)goodsName GoodsWeight:(NSString *)goodsWeight GoodsVolume:(NSString *)goodsVolume GoodsNum:(NSString *)goodsNum;

/*专线重量为 kg*/
+ (NSString *)getMsgWithGoodsName:(NSString *)goodsName GoodsWeight:(NSString *)goodsWeight GoodsVolume:(NSString *)goodsVolume GoodsNum:(NSString *)goodsNum;

/**
 传入一个字符串 返回空 或者字符串
 */
+ (NSString *)getNullOrNoNull:(NSString *)StrNull;

/**
 得到 json 字符串
 */
+ (NSString *)dictionTransformationJson:(NSDictionary *)parms;

/**
 使用是否能报价
 */
+ (BOOL)isCanOffer:(NSString *)time Minute:(NSInteger)minute;

/**
 判断是否允许报价 装货时间小于当前时间 是不允许报价的
 */
+ (BOOL)isAllowBiddingWithPickGoodsTime:(NSString *)pickGoodsTime;

/**
 传入 一个时间  和一个分钟 返回多少秒
 */
+ (NSInteger)getSecond:(NSString *)time Minute:(NSInteger )minute;

/**
 转入多少秒 返回时分秒
 */
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

/**
 传入一个时间 返回几分钟就 就像微博一样
 */
+ (NSString *)compareCurrentTime:(NSString *)time;

/**
 判断这个时间是否是当天
 */
+ (BOOL)checkTheDate:(NSString *)string;

/**
 得到一个地址的区名
 */
+ (NSString *)getAddressAraeString:(NSString *)arae;

/**
 替换字符串
 @param replaceBefore 需要替换的string
 @param needReplaceString 需要替换的东西
 @param replaceAfterString 替换成什么
 */
+ (NSString *)getReplaceAfterWithReplaceBefore:(NSString *)replaceBefore
                             NeedReplaceString:(NSString *)needReplaceString
                            ReplaceAfterString:(NSString *)replaceAfterString;


@end
