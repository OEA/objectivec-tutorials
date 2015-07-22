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

@interface BookListVC()
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSCache *imagesCache;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *adminPanelButton;
@end

@implementation BookListVC
@synthesize managedObjectContext;

#pragma mark - View Controller default methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBooks];
    [self.mTableView reloadData];
    if (!_imagesCache)
        _imagesCache = [NSCache new];
    
    User *user = [self getUserFromSession];
    
    
    if (user.isAdmin.intValue < 1) {
        self.navigationItem.rightBarButtonItem = nil ;
    }
}

- (User *)getUserFromSession
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:@"user"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@)", username];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    User *user = [results firstObject];
    NSLog(@"%@", user.username);
    return user;
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.books = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListCell *cell = [BookListCell new];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Book Cell" forIndexPath:indexPath];
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        
//        Book *book = [_books objectAtIndex:indexPath.row];
//        
//    cell.bookTitle.text = book.title;
//    cell.bookAuthor.text = book.author;
//    cell.bookPages.text =[NSString stringWithFormat:@"%li pages",book.pages];
//    cell.bookPublished.text = book.publishdate;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        cell.bookImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:book.imageUrl]]];
//    });
//        
//    });
    
    Book *book = [_books objectAtIndex:indexPath.row];
    cell.bookImage.image = [UIImage imageWithData:[self getImageFromURLOrCache:book.image]];
    cell.bookTitle.text = book.title;
    cell.bookAuthor.text = book.author.name;
    cell.bookPages.text = [NSString stringWithFormat:@"%@ pages", book.pages];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:book.publishDate];

    cell.bookPublished.text = [NSString stringWithFormat:@"%ld", (long)[components year]];
    
    Author *author = book.author;
    NSSet *books = author.books;
    NSLog(@"%lu", (unsigned long)books.count);
    
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

@end
