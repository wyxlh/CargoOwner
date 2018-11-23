//
//  YFSearchHistoryModel.m
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchHistoryModel.h"

@implementation YFSearchHistoryModel
/**
 写入数据

 @return return value description
 */
#pragma  mark -
-(void)saveData:(NSString *)searchKey{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self readData]];
    [array addObject:searchKey];
    //过滤重复数据
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++){
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO){
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    if (categoryArray.count > 6) {
        [categoryArray removeObjectAtIndex:0];
    }
    [YFUserDefaults setObject:categoryArray forKey:@"SearchHistoryArray"];
    [YFUserDefaults synchronize];
}

/**
 读取数据

 @param NSMutableArray NSMutableArray description
 @return return value description
 */
#pragma  mark -
-(NSMutableArray *)readData{
    NSMutableArray *array =  [YFUserDefaults objectForKey:@"SearchHistoryArray"];
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

/**
 删除数据。使用空数据写入替换
 */
-(void)deleteData{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    [YFUserDefaults setObject:categoryArray forKey:@"SearchHistoryArray"];
    [YFUserDefaults synchronize];
}
@end
