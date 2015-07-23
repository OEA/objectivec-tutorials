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
#import "BookManager.h"
#import "AuthorManager.h"
@interface AddBookVC() <UIPickerViewDataSource, SubjectModelDelegate>

@property (strong, nonatomic) IBOutlet UITextField *bookTitle;
@property (weak, nonatomic) IBOutlet UITextView *subjectList;

@property (strong, nonatomic) IBOutlet UITextField *author;
@property (strong, nonatomic) IBOutlet UITextField *pages;
@property (strong, nonatomic) IBOutlet UITextField *imageUrl;
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) IBOutlet UIPickerView *dateView;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) BookManager *bookManager;
@property (strong, nonatomic) AuthorManager *authorManager;




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
    
    self.subjectList.text = @"";
    
    for (Subject *subject in self.subjects) {
        [self.subjectList.text stringByAppendingString:subject.name];
        [self.subjectList.text stringByAppendingString:@"\n"];
    }
    
}

- (BookManager *)bookManager
{
    if (!_bookManager)
        _bookManager = [BookManager sharedInstance];
    return _bookManager;
}

- (AuthorManager *)authorManager
{
    if (!_authorManager)
        _authorManager = [AuthorManager sharedInstance];
    return _authorManager;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.subjectList.text = @"";
    
    for (Subject *subject in self.subjects) {
        NSLog(@"%@",subject.name);
        self.subjectList.text = [self.subjectList.text stringByAppendingString:subject.name];
        self.subjectList.text = [self.subjectList.text stringByAppendingString:@"\n"];
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

#pragma mark - UI functionality

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
    Author *author = [self.authorManager getAuthor:self.author.text];
    
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
        Book *book = [[Book alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    @try {
        [book setTitle:self.bookTitle.text];
        [book setPages:[self numberFromString:self.pages.text]];
        [book setPublishDate:[NSDate dateFromString:self.date]];
        [book setImage:self.imageUrl.text];
        for (Subject *subject in self.subjects) {
            [book addSubjectsObject:subject];
        }
        [self.bookManager createBook:book];
        
        Book *createdBook = [self.bookManager getBookFromName:book.title];
        [createdBook setAuthor:author];
        [self.bookManager updateBook:createdBook];
        [author addBooksObject:[self.bookManager getBookFromName:book.title]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        if ([exception.reason isEqualToString:@"emptyFields"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Adding Book Failed" message:@"Please fill the all necessary fields." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Adding Book Failed" message:@"you entered book which is already added." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    @finally {
        
    }
}

#pragma mark - necessary extensions

- (NSNumber *)numberFromString:(NSString *)numberStr
{
    return [NSNumber numberWithInteger:[numberStr integerValue]];
}

- (NSData *)imageFromUrl:(NSString *)url
{
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
}

#pragma mark - segue

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.identifier isEqualToString:@"subjectModal2"]) {
        NSLog(@"test");
        SubjectModalVC *vc = (SubjectModalVC*)segue.destinationViewController;
        vc.delegate = self;
//        for (Subject *subject in self.subjects) {
//            [vc.selectedSubjects addObject:subject];
//        }
    }
}

- (void)sendObject:(NSMutableArray *)subjects {
    [self.subjects removeAllObjects];
    for (Subject *subject in subjects) {
        [self.subjects addObject:subject];
    }
}

@end
