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
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", self.bookTitle];
    
    NSError *searchError;
    NSArray *list = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    self.book = [list firstObject];
    
    [self initUI];
    
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
    
    Author *author;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.authorText.text];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        author = [results objectAtIndex:0];
    } else {
        author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self.managedObjectContext];
        [author setValue:self.authorText.text forKey:@"name"];
    }
    
    Book *book;
    NSFetchRequest *bookReq = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    bookReq.predicate = [NSPredicate predicateWithFormat:@"title = %@", self.book.title];
    
    NSArray *bookResults = [self.managedObjectContext executeFetchRequest:bookReq error:&searchError];
    
    book = [bookResults objectAtIndex:0];
    [book setValue:self.titleText.text forKey:@"title"];
    [book setValue:[self numberFromString:self.pagesText.text] forKey:@"pages"];
    [book setValue:[self dateFromString:self.date] forKey:@"publishDate"];
    [book setValue:self.imageText.text forKey:@"image"];
    [book setValue:author forKey:@"author"];
    [book setValue:nil forKey:@"subjects"];
    
    for (Subject *subject in self.book.subjects) {
        [book removeSubjects:subject];
    }
    for (Subject *subject in self.subjects) {
        
        [book addSubjectsObject:subject];
    }
    if (![book.author.name isEqualToString:self.authorText.text]) {
        [author addBooksObject:book];
    }
    
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
    if (!dateStr) {
        
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        return [dateFormatter dateFromString:dateString];
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"yyyy"];
        return [dateFormat dateFromString:dateStr];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTitle:(NSString *)title
{
    self.bookTitle = title;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
