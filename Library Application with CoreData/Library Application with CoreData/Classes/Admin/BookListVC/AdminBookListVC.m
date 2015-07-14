//
//  BookListVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "AdminBookListVC.h"
#import "Book.h"
#import "BookEditVC.h"
@interface AdminBookListVC ()
@property (strong, nonatomic)NSMutableArray *books;
@end

@implementation AdminBookListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBooks];
    [self.tableView reloadData];

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

- (void)initBooks
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.books = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    

}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        Book *book = [self.books objectAtIndex:indexPath.row];
        [self deleteBook:book.title];
        
        [tableView beginUpdates];
        
        [self initBooks];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}

- (void)deleteBook:(NSString *)title
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    Book *book = [results firstObject];
    
    [self.managedObjectContext deleteObject:book];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adminBookListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Book *book = [_books objectAtIndex:indexPath.row];
    cell.textLabel.text = book.title;

    return cell;
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    UITableViewCell *cell = sender;
    if ([segue.identifier isEqualToString:@"bookEdit"]) {
        BookEditVC *vc = segue.destinationViewController;
        vc.bookTitle = cell.textLabel.text;
    }
}

@end
