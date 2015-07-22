//
//  SubjectListVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "SubjectListVC.h"
#import "Subject.h"
#import "SubjectManager.h"
@interface SubjectListVC ()

@property (strong, nonatomic) NSMutableArray *subjectArray;
@property (strong, nonatomic) NSMutableArray *subjectFilterArray;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) SubjectManager *subjectManager;
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

- (SubjectManager *)subjectManager
{
    if(!_subjectManager)
        _subjectManager = [SubjectManager sharedInstance];
    return _subjectManager;
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
    self.subjectArray = [self.subjectManager getAllSubjects];
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


- (IBAction)addSubject:(id)sender {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Subject" message:@"Enter subject what you want to add" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Add"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //Add
        UITextField *subjectName = [alertView textFieldAtIndex:0];
        NSString *name = subjectName.text;
        
        @try {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            Subject *subject = [[Subject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
            [subject setName:name];
            [self.subjectManager createSubject:subject];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successfully created." message:[NSString stringWithFormat:@"You successfully created %@ subject !",name] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];

        }
        @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Subject creation failed." message:[NSString stringWithFormat:@"You failed to create %@ subject !",name] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
        @finally {
            
        }
        
        [self initSubjects];
        [self.tableView reloadData];
    }
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

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction * __nonnull action, NSIndexPath * __nonnull indexPath) {
        Subject *subject = [self.subjectArray objectAtIndex:indexPath.row];
        [self deleteSubject:subject.name];
        
        [tableView beginUpdates];
        
        [self initSubjects];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}

- (void)deleteSubject:(NSString *)subjectName
{
    [self.subjectManager deleteSubject:[self.subjectManager getSubjectFromName:subjectName]];
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
