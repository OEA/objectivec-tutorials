//
//  BookDetailVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "BookDetailVC.h"
#import "Subject.h"
#import "Transaction.h"
#import "User.h"
#import "Author.h"
#import "BookManager.h"
#import "UserManager.h"
#import "TransactionManager.h"

@interface BookDetailVC ()
@property (strong, nonatomic) NSCache *imagesCache;
@property (strong, nonatomic) BookManager *bookManager;
@property (strong, nonatomic) UserManager *userManager;
@property (strong, nonatomic) TransactionManager *transactionManager;
@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bookName.text = self.book.title;
    self.bookPages.text = [NSString stringWithFormat:@"%@",self.book.pages];
    self.availability.text = @"Available";
    self.bookSubjects.text = @"";
    for (Subject *subject in self.book.subjects) {
        self.bookSubjects.text = [self.bookSubjects.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",subject.name]];
    }
   
    self.bookSummary.text = @"test";
    self.bookYear.text = [NSString stringWithFormat:@"%@ ",self.book.publishDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.book.publishDate];
    
    self.bookYear.text = [NSString stringWithFormat:@"%ld", (long)[components year]];
    
    self.bookImage.image = [UIImage imageWithData:[self getImageFromURLOrCache:self.book.image]];
    self.bookAuthor.text = self.book.author.name;
    if (![self isBookAvailable]){
        [self changeUI];
    }
}
#pragma mark - Book and User Managers
- (BookManager *)bookManager
{
    if (!_bookManager)
        _bookManager = [BookManager sharedInstance];
    return _bookManager;
}

- (UserManager *)userManager
{
    if (!_userManager)
        _userManager = [UserManager sharedInstance];
    return _userManager;
}

- (TransactionManager *)transactionManager
{
    if (!_transactionManager)
        _transactionManager = [TransactionManager sharedInstance];
    return _transactionManager;
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

#pragma mark - UI functionalities
- (IBAction)getButtonTapped:(id)sender {
    
    if ([self.getButton.titleLabel.text isEqualToString:@"GET"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Request %@",self.book.title]
                          message:[NSString stringWithFormat:@"Are you sure to get %@ ?",self.book.title]
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"YES",@"NO", nil];
        [alert show];
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDate *fireDate = [self.transactionManager getTransaction:self.book].transactionFinishDate;
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = fireDate;
        localNotification.alertBody = [NSString stringWithFormat:@"%@ now avaible",self.book.title];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [defaults setObject:self.book.title forKey:@"bookTitle"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self requestBook];
    } else {
        
    }

}

- (void)changeUI
{
    
    
    if ([self isBookOnMe]) {
        [self.cancelButton setHidden:NO];
    } else {
        [self.cancelButton setHidden:YES];
    }
    if ([self isBookAvailable]){
        [self.getButton setBackgroundColor:[UIColor greenColor]];
        [self.getButton setTitle:@"GET" forState:UIControlStateNormal];
        [self.getButton setEnabled:YES];
        self.availability.text = @"Available";
    } else {
        [self.getButton setBackgroundColor:[UIColor orangeColor]];
        [self.getButton setTitle:@"NOTIFY ME" forState:UIControlStateNormal];
        self.availability.text = @"Not available";
    }
    
}

- (IBAction)cancelButtonTapped:(id)sender {
    Transaction *lastTransaction = [self.transactionManager getTransaction:self.book];
    
    [self.managedObjectContext deleteObject:lastTransaction];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
    }
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successfully canceled." message:@"You successfully canceled getting the book !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    [self changeUI];
}


#pragma mark - transaction process
- (void)requestBook
{
    [self.transactionManager createTransaction:self.book];
    [self changeUI];
    
}

#pragma mark - logical methods
- (BOOL)isBookOnMe
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"user"];
    
    Transaction *lastTransaction = [self.transactionManager getTransaction:self.book];
    if ([lastTransaction.user.username isEqualToString:username]) {
        return YES;
    } else {
        return NO;
    }
}


- (BOOL)isBookAvailable
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
    NSDate *today = [NSDate date];
    
    request.predicate = [NSPredicate predicateWithFormat:@"book.title = %@ AND (transactionFinishDate > %@) ", self.book.title, today];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        return NO;
    } else {
        return YES;
    }

}

- (NSData *)getImageFromURLOrCache:(NSString *)url
{
    NSData *data = [self.imagesCache objectForKey:url];
    if (!data) {
        if (url) {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (data)
                [self.imagesCache setObject:data forKey:url];
        }
    }
    
    return data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
