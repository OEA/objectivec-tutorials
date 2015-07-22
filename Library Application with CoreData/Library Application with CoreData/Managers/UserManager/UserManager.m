//
//  UserManager.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "UserManager.h"
#import "UserLogManager.h"

@interface UserManager()
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) UserLogManager *userLogManager;
@end

@implementation UserManager

+ (instancetype)sharedInstance
{
    static UserManager *instance = nil;
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

- (UserLogManager *)userLogManager
{
    if (!_userLogManager) {
        _userLogManager = [UserLogManager sharedInstance];
    }
    return _userLogManager;
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

#pragma mark - User CRUD methods
- (NSArray *)getUserArrayWithUserName:(User *)user
{
    //Create query SELECT * FROM User where username = 'user.username' to handle username conflict
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", user.username];
    
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    return results;
}

- (void)createUser:(User *)user
{
    NSArray *results;
    results = [self getUserArrayWithUserName:user];
    //If username is already taken, it throws exception to handle username conflicts.
    if ([results count] > 0) {
        @throw [[NSException alloc] initWithName:@"Custom" reason:@"pickedUsername" userInfo:nil];
    }
    //Create insertable User model
    User *creationUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    //Setting all necessary fields
    [creationUser setName:user.name];
    [creationUser setUsername:user.username];
    [creationUser setPassword:user.password];
    [creationUser setName:user.name];
    
    NSNumber *isAdmin = ([self isAdmin]) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    
    [creationUser setCreationDate:[NSDate date]];
    [creationUser setIsAdmin:isAdmin];
    
   
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }

    //Creation Log
    [self.userLogManager createLog:@"createUser" :creationUser];
    
}
- (void)updateUser:(User *)user
{
    //Create query SELECT * FROM User where username = 'user.username' to get user
    User *editingUser = [self getUserFromUserName:user.username];
    //Setting all necessarry fields
    
    if (![user.name isEqualToString:editingUser.name]) {
        [editingUser setName:user.name];
    }
    if (![user.username isEqualToString:editingUser.username]) {
        [editingUser setUsername:user.username];
    }
    if (![user.password isEqualToString:editingUser.password]) {
        [editingUser setPassword:user.password];
    }
    if (user.isAdmin != editingUser.isAdmin) {
        [editingUser setIsAdmin:user.isAdmin];
    }
    NSArray *results;
    results = [self getUserArrayWithUserName:user];
    //If username is already taken, it throws exception to handle username conflicts.
    if ([results count] > 0) {
        @throw [[NSException alloc] initWithName:@"Custom" reason:@"pickedUsername" userInfo:nil];
    } else {
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    [self.userLogManager createLog:@"updateUser" :editingUser];

}
- (void)deleteUser:(User *)user
{
    User *deletingUser = [self getUserFromUserName:user.username];
    
    [self.userLogManager createLog:@"removeUser" :deletingUser];
    
    [self.managedObjectContext deleteObject:deletingUser];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
}
- (User *)getUserFromUserName:(NSString *)username
{
    //Create query SELECT * FROM User where username = 'user.username' to get user
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    User *user = [results firstObject];
    return user;
}

#pragma mark - Necessary User methods
- (User *)getLastUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    User *user = [results lastObject];
    return user;
}
- (User *)getFirstUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    User *user = [results firstObject];
    return user;
}
- (User *)getCurrentUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"user"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@)", username];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    User *user = [results firstObject];
    return user;
}

- (NSArray *)getAllUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    return results;
}

#pragma mark - Logical Methods
- (BOOL)isAdmin

{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    if ([results count] == 0)
        return YES;
    else
        return NO;
}


#pragma mark - LogIn Methods

- (void)loginUser:(NSString *)username :(NSString *)password
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)", username, password];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        User *user = [results firstObject];
        [self saveUserToDefaults:user];
    } else {
       @throw [[NSException alloc] initWithName:@"Custom" reason:@"wrongUsernameOrPassword" userInfo:nil];
    }

}

- (void)saveUserToDefaults :(User *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.username forKey:@"user"];
}

@end
