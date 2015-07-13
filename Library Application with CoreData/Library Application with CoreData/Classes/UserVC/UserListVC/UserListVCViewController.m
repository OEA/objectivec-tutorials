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
        cell = [tableView dequeueReusableCellWithIdentifier:@"greyCell"];
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
       
        User *user = [self.userFilterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = user.name;
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"whiteCell"];
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:1];
        User *user = [self.userArray objectAtIndex:indexPath.row];
        cell.textLabel.text = user.name;
    }
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
            if ([user.name.lowercaseString containsString:searching.lowercaseString]) {
                [self.userFilterArray addObject:user];
            }
        }
    }
    [self.tableView reloadData];
}

@end
