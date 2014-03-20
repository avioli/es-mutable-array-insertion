//
//  arrayMerge_Tests.m
//  arrayMerge Tests
//
//  Created by Evo Stamatov on 20/03/2014.
//  Copyright (c) 2014 Ionata. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableArray+ESMutableArrayInsertion.h"
#import "ESCustomObject.h"

@interface arrayMerge_Tests : XCTestCase

@end

@implementation arrayMerge_Tests
{
    NSMutableArray *master;
    NSArray *adds;
    NSDictionary *zero, *one, *two, *three, *four, *five, *six, *seven, *eight, *nine;
    NSNumber *debugLogging;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSMutableArray *numDicts = [NSMutableArray new];
    for (int i = 0; i < 10; i++)
        [numDicts addObject:@{@"id":@(i), @"random": @(arc4random() * 100000) }];
    
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
    
    master = [NSMutableArray arrayWithArray:@[seven, six, five]];
    adds = @[nine, eight, seven, six];
    
    debugLogging = @NO;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInsertionOfNil
{
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              };
    XCTAssertThrows([master addObjectsFromArray:nil atIndex:0 options:options]);
}

- (void)testInsertionAtOutOfRangeIndex
{
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              };
    XCTAssertThrows([master addObjectsFromArray:adds atIndex:4 options:options]);
}

- (void)testInsertionOfSubArrayIntoEmptyMaster
{
    NSDictionary *options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                              };
    NSMutableArray *emptyMaster = [NSMutableArray array];
    NSUInteger insertionResult = [emptyMaster addObjectsFromArray:adds atIndex:0 options:options];
    NSArray *expectedArray = @[nine, eight, seven, six];
    
    XCTAssertTrue([emptyMaster isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 4, @"Inserted objects should be 4");
    XCTAssertEqual(emptyMaster.count, 4, @"Resulting array objects should be 4");
}

- (void)testInsertionOfSubArrayAtBeginning
{
    NSDictionary *options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              };
    NSUInteger insertionResult = [master addObjectsFromArray:adds atIndex:0 options:options];
    NSArray *expectedArray = @[nine, eight, seven, six, seven, six, five];
    
    XCTAssertTrue([master isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 4, @"Inserted objects should be 4");
    XCTAssertEqual(master.count, 7, @"Resulting array objects should be 7");
}

- (void)testInsertionAtEndExcludingIntersections
{
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                              };
    NSUInteger insertionResult = [master addObjectsFromArray:adds atIndex:master.count options:options];
    NSArray *expectedArray = @[seven, six, five, nine, eight, seven, six];
    
    XCTAssertTrue([master isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 4, @"Inserted objects should be 4");
    XCTAssertEqual(master.count, 7, @"Resulting array objects should be 7");
}

- (void)testInsertionAtSpecificIndexExcludingIntersections
{
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                              };
    NSUInteger insertionResult = [master addObjectsFromArray:adds atIndex:2 options:options];
    NSArray *expectedArray = @[seven, six, nine, eight, seven, six, five];
    
    XCTAssertTrue([master isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 4, @"Inserted objects should be 4");
    XCTAssertEqual(master.count, 7, @"Resulting array objects should be 7");
}

- (void)testInsertionAtBeginningExcludingIntersections
{
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                              };
    NSUInteger insertionResult = [master addObjectsFromArray:adds atIndex:0 options:options];
    NSArray *expectedArray = @[nine, eight, seven, six, five];
    
    XCTAssertTrue([master isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 2, @"Inserted objects should be 2");
    XCTAssertEqual(master.count, 5, @"Resulting array objects should be 5");
}

- (void)testInsertionWithCustomObjectCopies
{
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                              };
    
    ESCustomObject *obj1 = [[ESCustomObject alloc] initWithRandomId];
    ESCustomObject *obj2 = [[ESCustomObject alloc] initWithRandomId];
    ESCustomObject *obj3 = [[ESCustomObject alloc] initWithRandomId];
    ESCustomObject *obj4 = [[ESCustomObject alloc] initWithRandomId];
    ESCustomObject *obj5 = [[ESCustomObject alloc] initWithRandomId];
    ESCustomObject *obj6 = [[ESCustomObject alloc] initWithRandomId];
    ESCustomObject *obj7 = [[ESCustomObject alloc] initWithRandomId];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:@[obj4, obj5, obj6, obj7]];
    NSArray *array2 = @[obj1, obj2, obj3, obj4, obj5];
    NSUInteger insertionResult = [array1 addObjectsFromArray:array2 atIndex:0 options:options];
    NSArray *expectedArray = @[obj1, obj2, obj3, obj4, obj5, obj6, obj7];
    
    XCTAssertTrue([array1 isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 3, @"Inserted objects should be 3");
    XCTAssertEqual(array1.count, 7, @"Resulting array objects should be 7");
}

- (void)testInsertionWithUniqueCustomObjects
{
    NSLog(@"ATTENTION: This test only passes if the custom object implements proper -[isEqual:]");
    
    NSDictionary* options = @{
                              ESMutableArrayOptionDebugLoggingKey: debugLogging,
                              ESMutableArrayOptionExcludeIntersectionsKey: @YES,
                              };
    
    ESCustomObject *obj1 = [[ESCustomObject alloc] initWithIntegerId:1];
    ESCustomObject *obj2 = [[ESCustomObject alloc] initWithIntegerId:2];
    ESCustomObject *obj3 = [[ESCustomObject alloc] initWithIntegerId:3];
    ESCustomObject *obj4 = [[ESCustomObject alloc] initWithIntegerId:4];
    ESCustomObject *obj5 = [[ESCustomObject alloc] initWithIntegerId:5];
    
    ESCustomObject *obj4alt = [[ESCustomObject alloc] initWithIntegerId:4];
    ESCustomObject *obj5alt = [[ESCustomObject alloc] initWithIntegerId:5];
    ESCustomObject *obj6alt = [[ESCustomObject alloc] initWithIntegerId:6];
    ESCustomObject *obj7alt = [[ESCustomObject alloc] initWithIntegerId:7];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithArray:@[obj4alt, obj5alt, obj6alt, obj7alt]];
    //NSLog(@"Array1 Before: %@", array1);
    NSArray *array2 = @[obj1, obj2, obj3, obj4, obj5];
    //NSLog(@"Array2: %@", array1);
    NSUInteger insertionResult = [array1 addObjectsFromArray:array2 atIndex:0 options:options];
    NSArray *expectedArray = @[obj1, obj2, obj3, obj4alt, obj5alt, obj6alt, obj7alt];
    //NSLog(@"Array1 After: %@", array1);
    
    XCTAssertTrue([array1 isEqualToArray:expectedArray], @"Expected result doesn't match");
    XCTAssertEqual(insertionResult, 3, @"Inserted objects should be 3");
    XCTAssertEqual(array1.count, 7, @"Resulting array objects should be 7");
}

@end
