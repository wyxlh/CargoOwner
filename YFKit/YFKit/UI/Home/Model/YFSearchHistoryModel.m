//
//  YFSearchHistoryModel.m
//  YFKit
//
//  Created by 王宇 on 2018/11/23.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFSearchHistoryModel.h"
#import "YFSearchListModel.h"

@implementation YFSearchHistoryModel
/**
 写入数据

 @return return value description
 */
#pragma  mark -
- (void)saveData:(NSMutableArray *)searchArray {
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self readData]];
    [array insertObjects:searchArray atIndexes:[NSIndexSet indexSetWithIndex:0]];
    //过滤重复数据
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++){
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO){
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    if (categoryArray.count > 6) {
        [categoryArray removeLastObject];
    }
    //序列化
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:categoryArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [YFUserDefaults setObject:jsonStr forKey:@"SearchHistoryArray"];
    [YFUserDefaults synchronize];
}

/**
 读取数据

 @param NSMutableArray NSMutableArray description
 @return return value description
 */
#pragma  mark -
- (NSMutableArray *)readData {
    NSString *jsonStr = [YFUserDefaults objectForKey:@"SearchHistoryArray"];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData == nil ) {
        return [NSMutableArray new];
    }
    //反序列化
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

/**
 删除数据。使用空数据写入替换
 */
- (void)deleteData {
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    [YFUserDefaults setObject:categoryArray forKey:@"SearchHistoryArray"];
    [YFUserDefaults synchronize];
}
@end
