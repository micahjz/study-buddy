//
//  Dict+CoreDataProperties.h
//  Study Buddy
//
//  Created by Micah Zirn on 5/19/16.
//  Copyright © 2016 Micah Zirn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dict.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dict (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *pairs;

@end

@interface Dict (CoreDataGeneratedAccessors)

- (void)addPairsObject:(NSManagedObject *)value;
- (void)removePairsObject:(NSManagedObject *)value;
- (void)addPairs:(NSSet<NSManagedObject *> *)values;
- (void)removePairs:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
