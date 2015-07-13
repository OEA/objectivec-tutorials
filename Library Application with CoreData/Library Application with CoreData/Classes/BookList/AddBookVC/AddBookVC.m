//
//  AddBookVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "AddBookVC.h"
#import "Book.h"
#import "Subject.h"
#import "Author.h"
#import "SubjectModalVC.h"
@interface AddBookVC() <UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *bookTitle;

@property (strong, nonatomic) IBOutlet UITextField *author;
@property (strong, nonatomic) IBOutlet UITextField *pages;
@property (strong, nonatomic) IBOutlet UITextField *imageUrl;
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) IBOutlet UIPickerView *dateView;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *subject;


#define MIN_YEAR 1800
@end

@implementation AddBookVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateView.delegate = self;
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
    if (!_years)
        _years = [NSMutableArray new];
    if (!_subjects)
        _subjects = [NSMutableArray new];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    int maxYear = [dateString intValue];
    for (int i = MIN_YEAR; i<=maxYear; i++) {
        [_years addObject:[[NSNumber alloc] initWithInt:i]];
    }
    
    
    [self.dateView reloadAllComponents];
    [self.dateView selectRow:[self.years count]-1 inComponent:0 animated:YES];
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        [self initSubjects];
    } else {
        Subject *uncategorized = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
        [uncategorized setValue:@"Uncategorized" forKey:@"name"];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [self initSubjects];
    }
    
    
    
    
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

- (void)initSubjects
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByName];
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    for (int i=0; i<[results count]; i++) {
        [self.subjects addObject:[results objectAtIndex:i]];
    }

}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.bookTitle) {
        [textField resignFirstResponder];
        [self.author becomeFirstResponder];
    } else if (textField == self.author) {
        [textField resignFirstResponder];
        [self.pages becomeFirstResponder];
    } else if (textField == self.pages) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_years count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        id title = [_years objectAtIndex:row];
        return [NSString stringWithFormat:@"%@", title];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    id title = [_years objectAtIndex:row];
    self.date = [NSString stringWithFormat:@"%@", title];
}

- (IBAction)addButtonTapped:(id)sender {
    
        Author *author;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.author.text];
        
        NSError *searchError;
        
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
        
        if ([results count] > 0) {
            author = [results objectAtIndex:0];
        } else {
            author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self.managedObjectContext];
            [author setValue:self.author.text forKey:@"name"];
        }
        
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
        
        [book setValue:self.bookTitle.text forKey:@"title"];
        [book setValue:[self numberFromString:self.pages.text] forKey:@"pages"];
        [book setValue:[self dateFromString:self.date] forKey:@"publishDate"];
        [book setValue:[self imageFromUrl:self.imageUrl.text] forKey:@"image"];
        [book setValue:author forKey:@"author"];
        [author addBooksObject:book];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSNumber *)numberFromString:(NSString *)numberStr
{
    return [NSNumber numberWithInteger:[numberStr integerValue]];
}

- (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy"];
    return [dateFormat dateFromString:dateStr];  
}

- (NSData *)imageFromUrl:(NSString *)url
{
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.identifier isEqualToString:@"subjectModal"]) {
        SubjectModalVC *vc = segue.destinationViewController;
        vc.selectedSubjects = self.subjects;
        vc.addbookvc = self;
        
        
    }
}

@end
