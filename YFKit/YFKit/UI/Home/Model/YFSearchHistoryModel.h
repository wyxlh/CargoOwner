//
//  YFSearchHistoryModel.h
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFSearchHistoryModel : NSObject
/**
 *  保存数据
 *
 */
-(void)saveData:(NSString *)searchKey;

/**
 *  读取数据
 *
 */
-(NSMutableArray *)readData;

/**
 *
 *   删除数据
 */
-(void)deleteData;
@end

NS_ASSUME_NONNULL_END
