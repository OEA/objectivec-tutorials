//
//  Transaction+CoreDataProperties.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Transaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface Transaction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *transactionStartDate;
@property (nullable, nonatomic, retain) NSDate *transactionFinishDate;
@property (nullable, nonatomic, retain) Book *book;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
