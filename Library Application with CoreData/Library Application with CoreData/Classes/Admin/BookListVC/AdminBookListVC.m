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
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *filteredBooks;
@end

@implementation AdminBookListVC


#pragma mark - viewDid methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBooks];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;

    [self.tableView reloadData];

    if (!_imagesCache)
        _imagesCache = [NSCache new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (NSMutableArray *)filteredBooks
{
    if (!_filteredBooks)
        _filteredBooks = [NSMutableArray new];
    return _filteredBooks;
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

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"bookDetail2" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        
        
        Book *book = [self.filteredBooks objectAtIndex:indexPath.row];
        
        [self deleteBook:book.title];
        
        
        [self.filteredBooks removeObject:book];
        [self.books removeObject:book];
        
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        [self performSegueWithIdentifier:@"editBook" sender:indexPath];
    }];
    editAction.backgroundColor = [UIColor orangeColor];
    return @[deleteAction, editAction];
}

- (void)deleteBook:(NSString *)title
{
    [self.bookManager deleteBook:[self.bookManager getBookFromName:title]];
}

- (void)checkBooks
{
    for (Book *book in self.books) {
        if (!book || book.title == nil) {
            [self.books removeObject:book];
        }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListCell *cell = [BookListCell new];
    cell = [tableView dequeueReusableCellWithIdentifier:@"Book Cell" forIndexPath:indexPath];
    
    if (self.searchController.active) {
        
        Book *book = [self.filteredBooks objectAtIndex:indexPath.row];
        cell.bookImage.image = [UIImage imageWithData:[self getImageFromURLOrCache:book.image]];
        cell.bookTitle.text = book.title;
        cell.bookAuthor.text = book.author.name;
        cell.bookPages.text = [NSString stringWithFormat:@"%@ pages", book.pages];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:book.publishDate];
        cell.bookPublished.text = [NSString stringWithFormat:@"%ld", (long)[components year]];
        
    } else {
        
        Book *book = [_books objectAtIndex:indexPath.row];
        cell.bookImage.image = [UIImage imageWithData:[self getImageFromURLOrCache:book.image]];
        cell.bookTitle.text = book.title;
        cell.bookAuthor.text = book.author.name;
        cell.bookPages.text = [NSString stringWithFormat:@"%@ pages", book.pages];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:book.publishDate];
        cell.bookPublished.text = [NSString stringWithFormat:@"%ld", (long)[components year]];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.filteredBooks.count;
    } else {
        return self.books.count;
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


- (void)willPresentSearchController:(UISearchController *)searchController
{
    
    self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //self.filteredCountries.removeAll()
    [self.filteredBooks removeAllObjects];
    NSString *searching = searchController.searchBar.text;
    if (![searching isEqualToString:@""]) {
        for (Book *book in self.books) {
            if ([book.title.lowercaseString containsString:searching.lowercaseString] || [book.author.name.lowercaseString containsString:searching.lowercaseString]) {
                [self.filteredBooks addObject:book];
            }
        }
    } else {
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{

    BookListCell *cell;
    NSIndexPath *indexPath;
    
    if ([sender isKindOfClass:[BookListCell class]]) {
        cell = sender;
       indexPath = [self.tableView indexPathForCell:cell];
    } else {
        indexPath = sender;
    }
    
    if ([segue.identifier isEqualToString:@"editBook"]) {
        BookEditVC *vc = segue.destinationViewController;
        Book *book;
        if (self.searchController.active) {
            book = [_filteredBooks objectAtIndex:indexPath.row];
        } else {
            book = [_books objectAtIndex:indexPath.row];
        }
        vc.book = book;
    } else if ([segue.identifier isEqualToString:@"bookDetail2"]) {
        BookDetailVC *vc = segue.destinationViewController;
        Book *book;
        if (self.searchController.active) {
            book = [_filteredBooks objectAtIndex:indexPath.row];
        } else {
            book = [_books objectAtIndex:indexPath.row];
        }
        vc.book = book;
    }
    
    [self.searchController setActive:NO];
}



@end
