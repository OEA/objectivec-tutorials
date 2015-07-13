//
//  Subject+CoreDataProperties.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Subject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Subject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Book *newRelationship;

@end

NS_ASSUME_NONNULL_END
