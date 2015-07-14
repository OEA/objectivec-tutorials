//
//  SubjectListVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "SubjectListVC.h"
#import "Subject.h"
@interface SubjectListVC ()

@property (strong, nonatomic) NSMutableArray *subjectArray;
@property (strong, nonatomic) NSMutableArray *subjectFilterArray;
@property (strong, nonatomic) UISearchController *searchController;
//Core Data context variable
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end

@implementation SubjectListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubjects];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initSubjects];
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

- (void)initSubjects
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.subjectArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    
    self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
}

- (NSArray *)subjectFilterArray
{
    if (!_subjectFilterArray) {
        _subjectFilterArray = [NSMutableArray new];
    }
    return _subjectFilterArray;
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
        Subject *subject = [self.subjectFilterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = subject.name;
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"whiteCell"];
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:1];
        Subject *subject = [self.subjectArray objectAtIndex:indexPath.row];
        cell.textLabel.text = subject.name;

    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.subjectFilterArray.count;
    } else {
        return self.subjectArray.count;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //self.filteredCountries.removeAll()
    [self.subjectFilterArray removeAllObjects];
    NSString *searching = searchController.searchBar.text;
    if (![searching isEqualToString:@""]) {
        for (Subject *subject in self.subjectArray) {
            if ([subject.name.lowercaseString containsString:searching.lowercaseString] ) {
                [self.subjectFilterArray addObject:subject];
            }
        }
    } else {
        self.tableView.backgroundColor = [[UIColor alloc]initWithRed:255 green:255 blue:255 alpha:0.90];
    }
    [self.tableView reloadData];
}

@end
