//
//  ESCustomObject.m
//  arrayMerge
//
//  Created by Evo Stamatov on 20/03/2014.
//  Copyright (c) 2014 Ionata. All rights reserved.
//

#import "ESCustomObject.h"

@implementation ESCustomObject

- (instancetype)initWithRandomId
{
    self = [super init];
    if (self)
    {
        _id = [NSNumber numberWithLong:(arc4random() * 100000)];
    }
    return self;
}

- (instancetype)initWithIntegerId:(NSInteger)integerId
{
    self = [super init];
    if (self)
    {
        _id = [[NSNumber alloc] initWithInteger:integerId];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    else if ([object isKindOfClass:[ESCustomObject class]])
    {
        ESCustomObject *customObject = (ESCustomObject *)object;
        return [self.id isEqualToNumber:customObject.id];
    }
    
    return NO;
}

@end
