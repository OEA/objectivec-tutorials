//
//  BookEditVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "BookEditVC.h"
#import "Subject.h"
#import "Book.h"
#import "Author.h"
#import "SubjectModalVC.h"
#import "BookManager.h"
#import "AuthorManager.h"

@interface BookEditVC ()<SubjectModelDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *authorText;
@property (weak, nonatomic) IBOutlet UITextField *pagesText;
@property (weak, nonatomic) IBOutlet UITextField *imageText;
@property (weak, nonatomic) IBOutlet UITextView *subjectList;
@property (weak, nonatomic) IBOutlet UIPickerView *dateView;
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) Book* book;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) BookManager *bookManager;
@property (strong, nonatomic) AuthorManager *authorManager;
@end

#define MIN_YEAR 1800
@implementation BookEditVC

- (void)viewDidLoad {
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
    
    //Getting book from book title
    self.book = [self.bookManager getBookFromName:self.book.title];
    //clear UI
    [self initUI];
    
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

- (void)initUI
{

    self.titleText.text = self.book.title;
    NSInteger date = [self getYearFromDate:self.book.publishDate];
    NSInteger row = date - MIN_YEAR;
    [self.dateView selectRow:row inComponent:0 animated:YES];
    self.imageText.text = self.book.image;
    self.authorText.text = self.book.author.name;
    self.subjectList.text = @"";
    for (Subject *subject in self.book.subjects) {
        self.subjectList.text = [self.subjectList.text stringByAppendingString:subject.name];
        self.subjectList.text = [self.subjectList.text stringByAppendingString:@"\n"];
    }
    self.pagesText.text = [NSString stringWithFormat:@"%@",self.book.pages];
}


- (NSInteger)getYearFromDate:(NSDate *)date
{
    NSDate *currentDate = date;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    return [components year];
}

- (IBAction)editButtonTapped:(id)sender {
    Author *author = [self.authorManager getAuthor:self.authorText.text];
    Book *book = [self.bookManager getBookFromName:self.book.title];
    
    @try {
        [book setTitle:self.titleText.text];
        [book setPages:[self numberFromString:self.pagesText.text]];
        [book setPublishDate:[NSDate dateFromString:self.date]];
        [book setImage:self.imageText.text];
        for (Subject *subject in self.subjects) {
            [book addSubjectsObject:subject];
        }
        [self.bookManager updateBook:book];
        
        Book *editedBook = [self.bookManager getBookFromName:book.title];
        [editedBook setAuthor:author];
        [self.bookManager updateBook:editedBook];
        [author addBooksObject:[self.bookManager getBookFromName:book.title]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Adding Book Failed" message:@"you entered book which is already added." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSNumber *)numberFromString:(NSString *)numberStr
{
    return [NSNumber numberWithInteger:[numberStr integerValue]];
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

#pragma mark - UI elements
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initUI];
    if ([self.subjects count]) {
        self.subjectList.text = @"";
        for (Subject *subject in self.subjects) {
            self.subjectList.text = [self.subjectList.text stringByAppendingString:subject.name];
            self.subjectList.text = [self.subjectList.text stringByAppendingString:@"\n"];
        }
    }
    
    
}

- (void)changeTitle:(NSString *)title
{
    self.bookTitle = title;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_years count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table View

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

#pragma mark - segue
- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.identifier isEqualToString:@"subjectModal"]) {
        SubjectModalVC *vc = (SubjectModalVC*)segue.destinationViewController;
        vc.delegate = self;
    }
}

- (void)sendObject:(NSMutableArray *)subjects {
    [self.subjects removeAllObjects];
    for (Subject *subject in subjects) {
        [self.subjects addObject:subject];
    }
}

@end
