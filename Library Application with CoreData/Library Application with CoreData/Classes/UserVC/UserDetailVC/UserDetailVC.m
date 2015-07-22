//
//  UserDetailVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "UserDetailVC.h"
#import "UserLogManager.h"

@interface UserDetailVC ()
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *logs;
@property (strong, nonatomic) UserLogManager *logManager;
@end

@implementation UserDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLogs];
    [self.tableView reloadData];
}

- (UserLogManager *)logManager
{
    if (!_logManager) {
        _logManager = [UserLogManager sharedInstance];
    }
    return _logManager;
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

- (void)initLogs
{
    self.logs = [self.logManager getLogsFromUserName:self.username];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    
    UserLog *log = [self.logs objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",log.transactionDate];
    cell.detailTextLabel.text = log.transaction;
    
    return cell;
}


@end
