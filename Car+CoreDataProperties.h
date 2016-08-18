//
//  Car+CoreDataProperties.h
//  TestFileStorage
//
//  Created by An, Fowafolo on 16/8/16.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Car.h"

NS_ASSUME_NONNULL_BEGIN

@interface Car (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSDate *createdDate;

@end

NS_ASSUME_NONNULL_END
