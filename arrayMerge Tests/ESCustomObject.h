//
//  ESCustomObject.h
//  arrayMerge
//
//  Created by Evo Stamatov on 20/03/2014.
//  Copyright (c) 2014 Ionata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCustomObject : NSObject

- (instancetype)initWithRandomId;
- (instancetype)initWithIntegerId:(NSInteger)integerId;

@property (nonatomic, copy) NSNumber *id;

@end
