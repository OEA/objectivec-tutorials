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
#import "NSString+CheckingEmpty.h"
#import <Photos/Photos.h>

@interface RegisterVC() <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (strong, nonatomic) UserManager *userManager;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) BOOL isRegistered;
@property (nonatomic) int seen;
@end
@implementation RegisterVC

- (void)viewDidLoad
{
    if (!_userManager)
        _userManager = [UserManager sharedInstance];
    
    self.seen = 0;
}
- (IBAction)browseButtonTapped:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    // Don't forget to add UIImagePickerControllerDelegate in your .h
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.seen++;
    
    if (self.seen > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
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
        if ([username isCompleteEmpty] || [password isCompleteEmpty] || [name isCompleteEmpty]) {
            self.isRegistered = NO;
            @throw [[NSException alloc] initWithName:@"Custom" reason:@"emptyField" userInfo:nil];
        }
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        User *user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        [user setName:name];
        [user setUsername:username];
        [user setPassword:password];
        [self.userManager createUser:user];
        [self.userManager loginUser:username :password];
        self.isRegistered = YES;
        [self clearAllUIElements];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register successful" message:@"Please log into the system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self performSegueWithIdentifier:@"registerSuccessful" sender:nil];
        
        
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"pickedUsername"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failed" message:@"you entered a picked username, please change it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Register failed" message:@"Please full the fields." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    @finally {
        
    }

}
- (IBAction)loginButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clearAllUIElements
{
    self.usernameText.text = @"";
    self.nameText.text = @"";
    self.passwordText.text = @"";
}

- (BOOL)shouldPerformSegueWithIdentifier:(nonnull NSString *)identifier sender:(nullable id)sender
{
    return NO;
}

@end
