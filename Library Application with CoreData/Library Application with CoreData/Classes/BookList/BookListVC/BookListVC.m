//
//  BookListVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "BookListVC.h"
#import "BookListCell.h"
#import "Book.h"
#import "Author.h"
#import "AddBookVC.h"
#import "BookDetailVC.h"
#import "User.h"
#import "BookManager.h"
#import "UserManager.h"

@interface BookListVC()
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSCache *imagesCache;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *adminPanelButton;
@property (strong, nonatomic) BookManager *bookManager;
@property (strong, nonatomic) UserManager *userManager;
@end

@implementation BookListVC

#pragma mark - View Controller default methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBooks];
    [self.mTableView reloadData];
    if (!_imagesCache)
        _imagesCache = [NSCache new];
    
    User *user = [self.userManager getCurrentUser];
    
    if (user.isAdmin.intValue < 1) {
        self.navigationItem.rightBarButtonItem = nil ;
    }
}

- (BookManager *)bookManager
{
    if (!_bookManager) {
        _bookManager = [BookManager sharedInstance];
    }
    return _bookManager;
}

- (UserManager *)userManager
{
    if (!_userManager) {
        _userManager = [UserManager sharedInstance];
    }
    return _userManager;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initBooks];
    [self.mTableView reloadData];
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

#pragma mark - Book Init
- (void)initBooks
{
    
    self.books = [self.bookManager getAllBooks];
    
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListCell *cell = [BookListCell new];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Book Cell" forIndexPath:indexPath];
    
    Book *book = [_books objectAtIndex:indexPath.row];
    cell.bookImage.image = [UIImage imageWithData:[self getImageFromURLOrCache:book.image]];
    cell.bookTitle.text = book.title;
    cell.bookAuthor.text = book.author.name;
    cell.bookPages.text = [NSString stringWithFormat:@"%@ pages", book.pages];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:book.publishDate];
    cell.bookPublished.text = [NSString stringWithFormat:@"%ld", (long)[components year]];
    return cell;
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


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_books count];
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([segue.identifier isEqualToString:@"addBook"]) {
        AddBookVC *vc = segue.destinationViewController;
        vc.books = self.books;
        vc.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"bookDetail"]) {
        BookDetailVC *vc = segue.destinationViewController;
        Book *book = [_books objectAtIndex:indexPath.row];
        vc.book = book;
    }
}
- (IBAction)logoutButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
