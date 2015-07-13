//
//  UserListVCViewController.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 11/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "UserListVCViewController.h"
#import "User.h"

@interface UserListVCViewController ()
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSMutableArray *userFilterArray;
@property (strong, nonatomic) UISearchController *searchController;
//Core Data context variable
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end


@implementation UserListVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUsers];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initUsers];
    [self.tableView reloadData];
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

#pragma mark - User Init
- (void)initUsers
{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.userArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}


- (void)willPresentSearchController:(UISearchController *)searchController
{
    
    self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
}

- (NSArray *)userFilterArray
{
    if (!_userFilterArray) {
        _userFilterArray = [NSMutableArray new];
    }
    return _userFilterArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.searchController.active) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"whiteCell"];
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:1];
        User *user = [self.userFilterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = user.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@",user.username];
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"whiteCell"];
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:1];
        User *user = [self.userArray objectAtIndex:indexPath.row];
        cell.textLabel.text = user.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@",user.username];
    }
    UILongPressGestureRecognizer *longPressTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMenus:)];
    
    longPressTap.minimumPressDuration = 1.0;
    
    [cell addGestureRecognizer:longPressTap];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (self.searchController.active) {
        return self.userFilterArray.count;
    } else {
        return self.userArray.count;
    }
}

- (void)showMenus:(UILongPressGestureRecognizer *)lpt
{
    if (lpt.state == UIGestureRecognizerStateBegan)
        //or check for UIGestureRecognizerStateEnded instead
    {
        
        CGPoint location = [lpt locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        User *user = [self.userArray objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"@%@",user.username]
                              message:@"User Menu"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:@"Edit", @"Delete", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        [self deleteUser:[alertView.title substringFromIndex:1]];
        [self initUsers];
        [self.tableView reloadData];
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        User *user = [self.userArray objectAtIndex:indexPath.row];
        [self deleteUser:user.username];
        
        [tableView beginUpdates];
        
        [self initUsers];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        NSLog(@"test");
    }];
    editAction.backgroundColor = [UIColor orangeColor];
    return @[deleteAction, editAction];
}

- (void)deleteUser:(NSString *)username
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    User *user = [results firstObject];
    
    [self.managedObjectContext deleteObject:user];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //self.filteredCountries.removeAll()
    [self.userFilterArray removeAllObjects];
    NSString *searching = searchController.searchBar.text;
    if (![searching isEqualToString:@""]) {
        for (User *user in self.userArray) {
            if ([user.name.lowercaseString containsString:searching.lowercaseString] || [user.username.lowercaseString containsString:searching.lowercaseString]) {
                [self.userFilterArray addObject:user];
            }
        }
    } else {
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
    }
    [self.tableView reloadData];
}

@end
