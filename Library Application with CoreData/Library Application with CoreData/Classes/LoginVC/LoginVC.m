//
//  LoginVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//


#import "LoginVC.h"
#import "User.h"

@interface LoginVC()
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;


@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
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
- (IBAction)loginTapped:(id)sender {
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)", username, password];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    User *user = [results objectAtIndex:0];
    
    if ([results count] > 0) {
        //LOGIN
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successfully logged in" message:@"you successfully logged in to system." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"you entered wrong username or password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}

@end
