//
//  Person.m
//  TestFileStorage
//
//  Created by An, Fowafolo on 16/8/15.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

#import "Person.h"

@implementation Person

/**
 *  解档
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([super init]) {
        self.avator = [aDecoder decodeObjectForKey:@"avator"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    
    return self;
}

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.avator forKey:@"avator"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

@end
