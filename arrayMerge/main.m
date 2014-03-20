//
//  main.m
//  arrayMerge
//
//  Created by Evo Stamatov on 20/03/2014.
//  Copyright (c) 2014 Ionata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+ESMutableArrayInsertion.h"

#define COLORLOG(bgColor, fgColor, fmt, ...) \
    do {				\
	__PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        char *xcode_colors = getenv("XcodeColors"); \
        if (xcode_colors && (strcmp(xcode_colors, "YES") == 0)) { \
            NSLog( @"\033[bg" bgColor @";\033[fg" fgColor @"; " fmt @" \033[;", ##__VA_ARGS__ );\
        } else { \
            NSLog( fmt, ##__VA_ARGS__ );\
        } \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)

#define FAIL(fmt, ...) \
    do {				\
	__PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        COLORLOG( @"255,0,0", @"255,255,255", fmt, ##__VA_ARGS__ ); \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)

#define PASS(fmt, ...) \
    do {				\
	__PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
        COLORLOG( @"0,255,0", @"0,0,0", fmt, ##__VA_ARGS__ ); \
        __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS \
    } while(0)

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        //setenv("XcodeColors", "YES", 0);
        
        NSMutableArray *numDicts = [NSMutableArray new];
        for (int i = 0; i < 10; i++)
            [numDicts addObject:@{@"id":@(i), @"random": @(arc4random() * 100000) }];
        
        NSDictionary *zero, *one, *two, *three, *four, *five, *six, *seven, *eight, *nine;
        
        zero = numDicts[0];
        one = numDicts[1];
        two = numDicts[2];
        three = numDicts[3];
        four = numDicts[4];
        five = numDicts[5];
        six = numDicts[6];
        seven = numDicts[7];
        eight = numDicts[8];
        nine = numDicts[9];
        
        NSMutableArray *base = [@[seven, six, five] mutableCopy];
        NSArray *adds = @[nine, eight, seven, six];
        NSMutableArray *master;
        NSDictionary *options;
        NSArray *expectedArray;
        NSNumber *debugLogging = @2;
        NSUInteger insertionResult;
        
        NSLog(@"TEST 1: Insert subArray at index 0");
        NSLog(@"==================================");
        master = [base mutableCopy];
        NSLog(@"Before: %@", master);
        options = @{
                    ESMutableArrayOptionDebugLoggingKey: debugLogging,
                    };
        @try {
            insertionResult = [master addObjectsFromArray:adds atIndex:0 options:options];
            expectedArray = @[nine, eight, seven, six, seven, six, five];
            NSCAssert([master isEqualToArray:expectedArray], @"don't match");
            NSCAssert(insertionResult == 4, @"should have inserted 4 objects");
            PASS(@"PASS");
            NSLog(@"After: %@", master);
        }
        @catch (NSException *exception) {
            FAIL(@"FAIL");
            NSLog(@"EXCEPTION: %@", exception);
        }
        
        NSLog(@"TEST 2: Insert subArray at index master.count, excluding intersections");
        NSLog(@"======================================================================");
        master = [base mutableCopy];
        NSLog(@"Before: %@", master);
        options = @{
                    ESMutableArrayOptionDebugLoggingKey: debugLogging,
                    ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                    };
        @try {
            insertionResult = [master addObjectsFromArray:adds atIndex:master.count options:options];
            expectedArray = @[seven, six, five, nine, eight, seven, six];
            NSCAssert([master isEqualToArray:expectedArray], @"don't match");
            NSCAssert(insertionResult == 4, @"should have inserted 4 objects");
            PASS(@"PASS");
            NSLog(@"After: %@", master);
        }
        @catch (NSException *exception) {
            FAIL(@"FAIL");
            NSLog(@"EXCEPTION: %@", exception);
        }
        
        NSLog(@"TEST 3: Insert subArray at index master.count-1, excluding intersections");
        NSLog(@"========================================================================");
        master = [base mutableCopy];
        NSLog(@"Before: %@", master);
        options = @{
                    ESMutableArrayOptionDebugLoggingKey: debugLogging,
                    ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                    };
        @try {
            insertionResult = [master addObjectsFromArray:adds atIndex:(master.count - 1) options:options];
            expectedArray = @[seven, six, nine, eight, seven, six, five];
            NSCAssert([master isEqualToArray:expectedArray], @"don't match");
            NSCAssert(insertionResult == 4, @"should have inserted 4 objects");
            PASS(@"PASS");
            NSLog(@"After: %@", master);
        }
        @catch (NSException *exception) {
            FAIL(@"FAIL");
            NSLog(@"EXCEPTION: %@", exception);
        }
        
        NSLog(@"TEST 4: Insert subArray at index 0, excluding intersections");
        NSLog(@"===========================================================");
        master = [base mutableCopy];
        NSLog(@"Before: %@", master);
        options = @{
                    ESMutableArrayOptionDebugLoggingKey: debugLogging,
                    ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                    };
        @try {
            insertionResult = [master addObjectsFromArray:adds atIndex:0 options:options];
            expectedArray = @[nine, eight, seven, six, five];
            NSCAssert([master isEqualToArray:expectedArray], @"don't match");
            NSCAssert(insertionResult == 2, @"should have inserted 2 objects");
            PASS(@"PASS");
            NSLog(@"After: %@", master);
        }
        @catch (NSException *exception) {
            FAIL(@"FAIL");
            NSLog(@"EXCEPTION: %@", exception);
        }
        
        NSLog(@"TEST 5: Insert nil at index 0, excluding intersections");
        NSLog(@"======================================================");
        master = [base mutableCopy];
        NSLog(@"Before: %@", master);
        options = @{
                    ESMutableArrayOptionDebugLoggingKey: debugLogging,
                    ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                    };
        @try {
            insertionResult = [master addObjectsFromArray:nil atIndex:0 options:options];
            FAIL(@"FAIL");
        }
        @catch (NSException *exception) {
            PASS(@"PASS");
            NSLog(@"Exception raised: %@", exception);
        }
        
        NSLog(@"TEST 6: Insert subArray at invalid index, excluding intersections");
        NSLog(@"=================================================================");
        master = [base mutableCopy];
        NSCAssert(master.count == 3, @"master has wrong number of objects");
        NSLog(@"Before: %@", master);
        options = @{
                    ESMutableArrayOptionDebugLoggingKey: debugLogging,
                    ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                    };
        @try {
            insertionResult = [master addObjectsFromArray:adds atIndex:4 options:options];
            FAIL(@"FAIL");
        }
        @catch (NSException *exception) {
            PASS(@"PASS");
            NSLog(@"Exception raised: %@", exception);
        }
    }
    return 0;
}

