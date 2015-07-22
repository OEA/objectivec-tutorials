//
//  RegisterVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "RegisterVC.h"
#import "User.h"
#import "UserManager.h"

@interface RegisterVC()
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) UserManager *userManager;
@end
@implementation RegisterVC

- (void)viewDidLoad
{
    if (!_userManager)
        _userManager = [UserManager sharedInstance];
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
    
    @try {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        User *user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        [user setName:name];
        [user setUsername:username];
        [user setPassword:password];
        [self.userManager createUser:user];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register successful" message:@"Please log into the system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"pickedUsername"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failed" message:@"you entered a picked username, please change it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            
        }
    }
    @finally {
        
    }

}
- (IBAction)loginButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
