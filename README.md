NSMutableArray+
===============

ESMutableArrayInsertion
=======================

This Category adds the objects contained in another given array to the array's contents at a given index.

```objc
- (NSUInteger)addObjectsFromArray:(NSArray *)otherArray
                          atIndex:(NSUInteger)index
                          options:(NSDictionary *)options;
```

If index is already occupied, the objects at index and beyond are shifted by adding otherArray's count to their indices to make room.

Note that NSArray objects are not like C arrays. That is, even though you specify a size when you create an array, the specified size is regarded as a “hint”; the actual size of the array is still 0. This means that you cannot insert an object at an index greater than the current count of an array. For example, if an array contains two objects, its size is 2, so you can add objects at indices 0, 1, or 2. Index 3 is illegal and out of bounds; if you try to add an object at index 3 (when the size of the array is 2), NSMutableArray raises an exception.

### Reason

I've built this category to be able to merge any chunk of an array into a master pool of objects with the option if the chunk includes an object already inside the master pool, to bail out and stop inserting.

### Usage

See the tests. They show some use cases, but here is a snippet:

```objc
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
    NSLog(@"Array1 Before: %@", array1);
    /*
    2014-03-20 18:02:17.025 xctest[13009:303] Array1 Before: (
    "<ESCustomObject: 0x1002330a0>", //4alt
    "<ESCustomObject: 0x100235920>", //5alt
    "<ESCustomObject: 0x100235930>", //6alt
    "<ESCustomObject: 0x100234a30>"  //7alt
)
    */

    NSArray *array2 = @[obj1, obj2, obj3, obj4, obj5];
    NSLog(@"Array2: %@", array1);
    /*
    2014-03-20 18:02:17.025 xctest[13009:303] Array2: (
    "<ESCustomObject: 0x10022c680>", //1
    "<ESCustomObject: 0x100234080>", //2
    "<ESCustomObject: 0x100233630>", //3
    "<ESCustomObject: 0x10022c180>", //4
    "<ESCustomObject: 0x100234110>"  //5
)
    */
    
    NSUInteger insertionResult = [array1 addObjectsFromArray:array2 atIndex:0 options:options];
    NSArray *expectedArray = @[obj1, obj2, obj3, obj4alt, obj5alt, obj6alt, obj7alt];
    NSLog(@"Array1 After: %@", array1);
    /*
    2014-03-20 18:02:17.026 xctest[13009:303] Array1 After: (
    "<ESCustomObject: 0x10022c680>", //1
    "<ESCustomObject: 0x100234080>", //2
    "<ESCustomObject: 0x100233630>", //3
    "<ESCustomObject: 0x1002330a0>", //4alt
    "<ESCustomObject: 0x100235920>", //5alt
    "<ESCustomObject: 0x100235930>", //6alt
    "<ESCustomObject: 0x100234a30>"  //7alt
)
    */
    
    if ([array1 isEqualToArray:expectedArray])
      NSLog(@"All good. Inserted: %lu", (unsigned long)insertionResult);
    else
      NSLog(@"Damn");

    /* 2014-03-20 18:02:17.026 xctest[13009:303] All good. Inserted: 3 */
```

Wondering what [ESCustomObject](https://github.com/avioli/es-mutable-array-insertion/blob/master/arrayMerge%20Tests/ESCustomObject.m) is? It has its own implementation of `-[isEqual:]` for this category to work properly.

### Parameters

_@param_ `otherArray`

An array of objects to add to the end of the receiving array’s content. This value must not be `nil`.

**Important**  
Raises an `NSInvalidArgumentException` if `otherArray` is `nil`.

_@param_ `index`

The index in the array at which to insert the otherArray's objects. This value must not be greater than the count of elements in the array.

**Important**  
Raises an NSRangeException if index is greater than the number of elements in the array.

_@param_ `options`

A dictionary with options. If `ESMutableArrayOptionExcludeIntersectionsKey` key is @YES, allows the `otherArray` to be compared with the object at `index` and if a match occurs, stop inserting objects and return the inserted count. If `ESMutableArrayOptionDebugLoggingKey` key is @YES, some NSLog messages will be sent for debugging - log a message if index is at the end of array; log the object at the specified index; and log a message when a matching object was found.

### Returns

_@return_ `NSUInteger`

The count of inserted objects.

If you specify `ESMutableArrayOptionExcludeIntersectionsKey: @YES` in the options dictionary, and an object from otherArray equals the object at index, the insertion stops and the returned `NSUInteger` will signify the actual inserted objects count.

### Contribution and pull requests

Please, write tests if you add additional functionality.

### License & Copyright

Autor: Evo Stamatov (aka avioli).

Free for anyone to use, embed, distribute, re-distribute and sell.
