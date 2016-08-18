//
//  Person.h
//  TestFileStorage
//
//  Created by An, Fowafolo on 16/8/15.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject <NSCoding>

@property (strong, nonatomic) UIImage *avator;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;

@end
