//
//  SKSafeObject.h
//  SKKit
//
//  Created by 王宇 on 15/11/28.
//  Copyright (c) 2015年  wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(SKSafeObject)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSDictionary (SKSafeObject)

//针对系统返回的<Null>进行处理
- (id)stringObjectForKey:(id)key;

//return object or nil
- (id)safeJsonObjForKey:(id)key;

@end

@interface NSMutableDictionary(SKSafeObject)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

