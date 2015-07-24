//
//  TransactionManager.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 23/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "TransactionManager.h"
#import "UserManager.h"
#import "Book.h"

@interface TransactionManager()
@property (strong, nonatomic) UserManager *userManager;
@end

@implementation TransactionManager

+ (instancetype)sharedInstance
{
    static TransactionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [self.class sharedInstance];
}

- (UserManager *)userManager
{
    if(!_userManager)
        _userManager = [UserManager sharedInstance];
    return _userManager;
}

#pragma mark - Core Data method
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)createTransaction:(Book *)book
{
    Transaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    NSDate *startDate = [NSDate date];
    NSDate *finishDate = [startDate dateByAddingTimeInterval:15];
    
    User *user = [self.userManager getCurrentUser];
    
    [transaction setValue:startDate forKey:@"transactionStartDate"];
    [transaction setValue:finishDate forKey:@"transactionFinishDate"];
    [transaction setValue:book forKey:@"book"];
    [transaction setValue:user forKey:@"user"];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)deleteTransaction:(Book *)book
{
    Transaction *transaction = [self getTransaction:book];
    [self.managedObjectContext deleteObject:transaction];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
}

- (Transaction *)getTransaction:(Book *)book
{
    //Create query SELECT * FROM User where username = 'user.username' to get user
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
    request.predicate = [NSPredicate predicateWithFormat:@"book.title = %@", book.title];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    Transaction *transaction = [results lastObject];
    return transaction;
}


@end
