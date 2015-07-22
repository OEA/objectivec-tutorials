//
//  BookListVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "AdminBookListVC.h"
#import "Book.h"
#import "Author.h"
#import "BookEditVC.h"
#import "BookListCell.h"
#import "BookDetailVC.h"
#import "BookManager.h"

@interface AdminBookListVC ()
@property (strong, nonatomic)NSMutableArray *books;
@property (strong, nonatomic) NSCache *imagesCache;
@property (strong, nonatomic) BookManager *bookManager;
@end

@implementation AdminBookListVC


#pragma mark - viewDid methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBooks];
    [self.tableView reloadData];

    if (!_imagesCache)
        _imagesCache = [NSCache new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initBooks];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Book Manager

-(BookManager *)bookManager
{
    if (!_bookManager)
        _bookManager = [BookManager sharedInstance];
    return _bookManager;
}


#pragma mark - Book Initializer
- (void)initBooks
{
    self.books = [self.bookManager getAllBooks];
    

}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookListCell *cell = [BookListCell new];
    cell = [tableView dequeueReusableCellWithIdentifier:@"Book Cell" forIndexPath:indexPath];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        Book *book = [self.books objectAtIndex:indexPath.row];
        [self deleteBook:book.title];
        
        [tableView beginUpdates];
        
        [self initBooks];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        [self performSegueWithIdentifier:@"bookEdit" sender:cell];
    }];
    editAction.backgroundColor = [UIColor orangeColor];
    return @[deleteAction, editAction];
}

- (void)deleteBook:(NSString *)title
{
    [self.bookManager deleteBook:[self.bookManager getBookFromName:title]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookListCell *cell = [BookListCell new];
    cell = [tableView dequeueReusableCellWithIdentifier:@"Book Cell" forIndexPath:indexPath];
    
    // Configure the cell...
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

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([segue.identifier isEqualToString:@"bookEdit"]) {
        BookEditVC *vc = segue.destinationViewController;
        Book *book = [self.books objectAtIndex:indexPath.row];
        vc.bookTitle = book.title;
    } else if ([segue.identifier isEqualToString:@"bookDetail"]) {
        BookDetailVC *vc = segue.destinationViewController;
       
        Book *book = [_books objectAtIndex:indexPath.row];
        vc.book = book;
    }
}

@end
