//
//  UserAddVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "UserAddVC.h"
#import "User.h"
#import "UserManager.h"
@interface UserAddVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UISwitch *adminValue;
@property (strong, nonatomic) UserManager *userManager;
@end

@implementation UserAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UserManager *)userManager
{
    if (!_userManager) {
        _userManager = [UserManager sharedInstance];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add Button Method
- (IBAction)addButtonTapped:(id)sender {
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    NSString *name = self.nameText.text;
    NSNumber *isAdmin = (self.adminValue.on) ? @1 : @0;
    
    @try {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        User *user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        [user setName:name];
        [user setUsername:username];
        [user setPassword:password];
        [user setIsAdmin:isAdmin];
        [self.userManager createUser:user];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User creation successful" message:@"You added the user to system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"pickedUsername"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User creation failed" message:@"you entered a picked username, please change it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            
        }
    }
    @finally {
        
    }
}

@end
