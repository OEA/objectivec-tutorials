//
//  UserAddVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "UserAddVC.h"
#import "User.h"
#import "UserLog.h"

@interface UserAddVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UISwitch *adminValue;

@end

@implementation UserAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)addButtonTapped:(id)sender {
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    NSString *name = self.nameText.text;
    NSNumber *isAdmin = (self.adminValue.on) ? @1 : @0;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User Adding Failed" message:@"you entered a picked username, please change it." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        [user setValue:name forKey:@"name"];
        [user setValue:username forKey:@"username"];
        [user setValue:password forKey:@"password"];
        [user setValue:[NSDate date]
        
                forKey:@"creationDate"];
        [user setValue:isAdmin forKey:@"isAdmin"];
        
        UserLog *log = [self createLog:user];
        [user addLogsObject:log];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
