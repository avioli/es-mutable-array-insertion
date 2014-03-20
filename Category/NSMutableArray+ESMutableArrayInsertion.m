//
//  NSMutableArray+ESMutableArrayInsertion.h
//
//  Created by Evo Stamatov on 20/03/2014.
//
//  Free for anyone to use, embed, distribute, re-distribute and sell.
//

#import "NSMutableArray+ESMutableArrayInsertion.h"

NSString *const ESMutableArrayOptionExcludeIntersectionsKey = @"ESMutableArrayOptionExcludeIntersectionsKey";
NSString *const ESMutableArrayOptionDebugLoggingKey = @"ESMutableArrayOptionDebugLoggingKey";

@implementation NSMutableArray (ESMutableArrayInsertion)

- (NSUInteger)addObjectsFromArray:(NSArray *)otherArray atIndex:(NSUInteger)index options:(NSDictionary *)options
{
    NSAssert(index != NSNotFound, @"Index must not be equal to NSNotFound");
    
    if (otherArray == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The otherArray cannot be nil" userInfo:nil];
    
    if (index > self.count)
        @throw [NSException exceptionWithName:NSRangeException reason:[NSString stringWithFormat:@"Index should be within range {0, %lu}", self.count] userInfo:nil];
    
    BOOL excludeIntersections = NO;
    id objectAtInsertionIndex;
    int debugLogging = [options[ESMutableArrayOptionDebugLoggingKey] intValue];
    
    if ([options[ESMutableArrayOptionExcludeIntersectionsKey] boolValue] == YES)
    {
        excludeIntersections = YES;
        if (index == self.count)
        {
            if (debugLogging)
                NSLog(@"Index at end of self. No need to exclude intersections.");
            excludeIntersections = NO;
        }
        else
        {
            objectAtInsertionIndex = [self objectAtIndex:index];
            NSAssert(objectAtInsertionIndex, @"When excluding intersections the object at provided index mustn't be of NSNull class");
            if (debugLogging > 1)
                NSLog(@"Object at index %lu: %@", (unsigned long)index, objectAtInsertionIndex);
        }
    }
    
    NSUInteger insertedCount = 0;
    if (excludeIntersections)
    {
        NSUInteger i = index;
        for (id objectToInsert in otherArray)
        {
            if ([objectToInsert isEqual:objectAtInsertionIndex])
            {
                if (debugLogging)
                    NSLog(@"Found intersection object");
                break;
            }
            [self insertObject:objectToInsert atIndex:i++];
            insertedCount ++;
        }
    }
    else if (self.count == 0)
    {
        // Fastest if absolutely empty
        if (debugLogging)
            NSLog(@"Empty receiver. Using the fastest insertion.");
        [self addObjectsFromArray:otherArray];
        insertedCount = otherArray.count;
    }
    else
    {
        // Quicker when not comparing
        if (debugLogging)
            NSLog(@"No comparison. Using range insertion.");
        NSRange range = NSMakeRange(index, otherArray.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self insertObjects:otherArray atIndexes:indexSet];
        insertedCount = otherArray.count;
    }
    
    return insertedCount;
}

@end
