NSMutableArray+
===============

ESMutableArrayInsertion
=======================

This Category adds the objects contained in another given array to the array's contents at a given index.

If index is already occupied, the objects at index and beyond are shifted by adding otherArray's count to their indices to make room.

Note that NSArray objects are not like C arrays. That is, even though you specify a size when you create an array, the specified size is regarded as a “hint”; the actual size of the array is still 0. This means that you cannot insert an object at an index greater than the current count of an array. For example, if an array contains two objects, its size is 2, so you can add objects at indices 0, 1, or 2. Index 3 is illegal and out of bounds; if you try to add an object at index 3 (when the size of the array is 2), NSMutableArray raises an exception.

### Parameters

_@param_ otherArray An array of objects to add to the end of the receiving array’s content. This value must not be `nil`.

                  **Important**

                  Raises an `NSInvalidArgumentException` if `otherArray` is `nil`.

_@param_ index The index in the array at which to insert the otherArray's objects. This value must not be greater than the count of elements in the array.

             **Important**

             Raises an NSRangeException if index is greater than the number of elements in the array.

_@param_ options A dictionary with options. If `ESMutableArrayOptionExcludeIntersectionsKey` key is @YES, allows the `otherArray` to be compared with the object at `index` and if a match occurs, stop inserting objects and return the inserted count. If `ESMutableArrayOptionDebugLoggingKey` key is @YES, some NSLog messages will be sent for debugging - log a message if index is at the end of array; log the object at the specified index; and log a message when a matching object was found.

### Returns

_@return_ Returns the count of inserted objects.

        If you specify `ESMutableArrayOptionExcludeIntersectionsKey: @YES` in the options dictionary, and an object from otherArray equals the object at index, the insertion stops and the returned `NSUInteger` will signify the actual inserted objects count.
