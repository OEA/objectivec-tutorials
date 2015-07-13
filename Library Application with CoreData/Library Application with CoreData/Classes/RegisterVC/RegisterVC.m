//
//  RegisterVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "RegisterVC.h"
#import "BookListVC.h"
#import "User.h"
#import "UserLog.h"

@interface RegisterVC()
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;


@end
@implementation RegisterVC


- (NSMutableArray *)books
{
    if (!_books)
        _books = [NSMutableArray new];
    return _books;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)registerButtonTapped:(id)sender {

    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    NSString *name = self.nameText.text;
    NSNumber *isAdmin = [self isAdmin];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register Failed" message:@"you entered a picked username, please change it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        
        [user setValue:name forKey:@"name"];
        [user setValue:username forKey:@"username"];
        [user setValue:password forKey:@"password"];
        [user setValue:[NSDate date] forKey:@"creationDate"];
        [user setValue:isAdmin forKey:@"isAdmin"];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successfully registered." message:@"You successfully registered !" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];

    }

}
- (UserLog *)createLog:(User *)user
{
    
    UserLog *userLog = [NSEntityDescription insertNewObjectForEntityForName:@"UserLog" inManagedObjectContext:self.managedObjectContext];
    [userLog setValue:user forKey:@"user"];
    [userLog setValue:@"User created by himself/herself" forKey:@"transaction"];
    [userLog setValue:[NSDate date] forKey:@"transactionDate"];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    return userLog;
    
}

- (NSNumber *)isAdmin
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] == 0)
        return [NSNumber numberWithInt:1];
    else 
        return [NSNumber numberWithInt:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"listBooks"]) {
        BookListVC *vc = segue.destinationViewController;
        vc.books = self.books;
    }
}

@end
