//
//  SubjectManager.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 22/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "SubjectManager.h"
#import "NSString+CheckingEmpty.h"

@interface SubjectManager()
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end

@implementation SubjectManager

//Book CRUD methods
- (void)createSubject:(Subject *)subject
{
    NSArray *results;
    results = [self getSubjectArrayFromName:subject];
    //If username is already taken, it throws exception to handle username conflicts.
    if ([results count] > 0) {
        @throw [[NSException alloc] initWithName:@"Custom" reason:@"pickedSubject" userInfo:nil];
    }
    
    if ([subject.name isCompleteEmpty]) {
        @throw [[NSException alloc] initWithName:@"Custom" reason:@"emptySubject" userInfo:nil];
    } else {
        //Create insertable Book model
        Subject *creationSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
        //Setting all necessary fields
        [creationSubject setName:subject.name];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        //Creation Log
        //[self.userLogManager createLog:@"createUser" :creationUser];
    }
}
- (void)updateSubject:(Subject *)subject
{
    Subject *creationSubject = [self getSubjectFromName:subject.name];
    //Setting all necessary fields
    [creationSubject setName:subject.name];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //Creation Log
    //[self.userLogManager createLog:@"createUser" :creationUser];
}
- (void)deleteSubject:(Subject *)subject
{
    Subject *deletingSubject = [self getSubjectFromName:subject.name];
    
    [self.managedObjectContext deleteObject:deletingSubject];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }

}
- (Subject *)getSubjectFromName:(NSString *)name
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    Subject *subject = [results firstObject];
    return subject;
}

//Necessary Methods
- (NSArray *)getAllSubjects
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    return results;
}

- (NSArray *)getSubjectArrayFromName:(Subject *)subject
{
    //Create query SELECT * FROM User where username = 'user.username' to handle username conflict
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", subject.name];
    
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    return results;
}

+ (instancetype)sharedInstance
{
    static SubjectManager *instance = nil;
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

@end
