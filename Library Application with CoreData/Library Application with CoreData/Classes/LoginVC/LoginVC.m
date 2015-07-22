//
//  LoginVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//


#import "LoginVC.h"
#import "User.h"
#import "BookListVC.h"
#import "UserManager.h"

@interface LoginVC()
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) UserManager *userManager;

@property (nonatomic)BOOL isLoggedIn;
@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (UserManager *)userManager
{
    if (!_userManager) {
        _userManager = [UserManager sharedInstance];
    }
    return _userManager;
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
    
    @try {
        [self.userManager loginUser:username :password];
        self.isLoggedIn = YES;
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"you entered wrong username or password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        self.isLoggedIn = NO;
    }
    @finally {
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login"]) {
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]){
        return self.isLoggedIn;
    } else {
        return YES;
    }
}

@end
