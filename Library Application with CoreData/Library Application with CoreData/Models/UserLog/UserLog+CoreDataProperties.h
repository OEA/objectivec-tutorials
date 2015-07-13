//
//  UserLog+CoreDataProperties.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "UserLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserLog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *transaction;
@property (nullable, nonatomic, retain) NSDate *transactionDate;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
