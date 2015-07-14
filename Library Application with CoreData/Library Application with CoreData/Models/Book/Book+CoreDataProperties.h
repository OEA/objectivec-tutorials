//
//  Book+CoreDataProperties.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSNumber *pages;
@property (nullable, nonatomic, retain) NSDate *publishDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Author *author;
@property (nullable, nonatomic, retain) NSSet<Subject *> *subjects;

@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addSubjectsObject:(Subject *)value;
- (void)removeSubjectsObject:(Subject *)value;
- (void)addSubjects:(NSSet<Subject *> *)values;
- (void)removeSubjects:(NSSet<Subject *> *)values;

@end

NS_ASSUME_NONNULL_END
