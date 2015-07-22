//
//  AuthorManager.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 22/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "AuthorManager.h"

@interface AuthorManager()
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end

@implementation AuthorManager


+ (instancetype)sharedInstance
{
    static AuthorManager *instance = nil;
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

- (void)createAuthor:(Author *)author
{
       
    //Create insertable Book model
    Author *creationAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self.managedObjectContext];
    //Setting all necessary fields
    [creationAuthor setName:author.name];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //Creation Log
    //[self.userLogManager createLog:@"createUser" :creationUser];
}

- (Author *)getAuthor:(NSString *)name
{
    //Create query SELECT * FROM User where username = 'user.username' to handle username conflict
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    Author *author;
    if ([results count] > 0) {
        author = [results firstObject];
    } else {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:self.managedObjectContext];
        Author *creationAuthor = [[Author alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        [creationAuthor setName:name];
        [self createAuthor:creationAuthor];
        return [self getAuthor:name];
    }
    return author;
}

- (NSArray *)getAuthorsArrayFromName:(NSString *)name
{
    //Create query SELECT * FROM User where username = 'user.username' to handle username conflict
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    return results;
}



@end
