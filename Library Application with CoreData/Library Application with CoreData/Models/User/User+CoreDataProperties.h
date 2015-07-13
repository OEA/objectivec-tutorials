//
//  User+CoreDataProperties.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSNumber *isAdmin;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSSet<UserLog *> *logs;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addLogsObject:(UserLog *)value;
- (void)removeLogsObject:(UserLog *)value;
- (void)addLogs:(NSSet<UserLog *> *)values;
- (void)removeLogs:(NSSet<UserLog *> *)values;

@end

NS_ASSUME_NONNULL_END
