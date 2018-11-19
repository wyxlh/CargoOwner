//
//  SKSafeObject.m
//  SKKit
//
//  Created by 王宇 on 15/11/28.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#define SolveNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#import "SKSafeObject.h"

@implementation NSArray(SKSafeObject)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if(self.count == 0)
    {
        return (nil);
    }
    if(index > self.count - 1)
    {
        return (nil);
    }
    return ([self objectAtIndex:index]);
}
@end

@implementation NSDictionary (SKSafeObject)

- (id)stringObjectForKey:(id)key
{
    return (SolveNull([self objectForKey:key]));
}
- (id)safeJsonObjForKey:(id)key
{
    return (([self objectForKey:key] == [NSNull null]) ? (nil) : ([self objectForKey:key]));
}

@end


@implementation NSMutableDictionary(SKSafeObject)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(aKey)
    {
        if(!anObject)
        {
            anObject = @"";
        }
        
        [self setObject:anObject forKey:aKey];
    }
}

@end

