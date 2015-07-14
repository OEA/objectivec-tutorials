//
//  SubjectModalVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "SubjectModalVC.h"
#import "Subject.h"

@interface SubjectModalVC ()

@property (strong, nonatomic) NSMutableArray *subjects;
@end

@implementation SubjectModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubjects];
    [self.tableView reloadData];
    
    if (!_subjects)
        _subjects = [NSMutableArray new];
    if (!_selectedSubjects)
        _selectedSubjects = [NSMutableArray new];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    
    NSError *searchError;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    
    if ([results count] > 0) {
        
    } else {
        Subject *uncategorized = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
        [uncategorized setValue:@"Uncategorized" forKey:@"name"];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initSubjects
{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.subjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
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
    return self.subjects.count;
}

- (IBAction)doneButtonTapped:(id)sender {
    
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    [controllers removeLastObject];
    AddBookVC *vc = (AddBookVC *)[controllers lastObject];
    
    if ([self.delegate respondsToSelector:@selector(sendObject:)]) {
        
        for (Subject *subject in self.selectedSubjects) {
            [self.delegate sendObject:subject];
        }
        
        vc.delegate = self;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subjectModalCell" forIndexPath:indexPath];
    Subject *subject = [self.subjects objectAtIndex:indexPath.row];
    cell.textLabel.text = subject.name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Configure the cell...
    for (Subject *subject in self.selectedSubjects) {
        if ([subject.name isEqualToString:[self.selectedSubjects objectAtIndex:indexPath.row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    return cell;
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

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        Subject *subject = [self.subjects objectAtIndex:indexPath.row];
        [self.selectedSubjects removeObject:subject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        Subject *subject = [self.subjects objectAtIndex:indexPath.row];
        [self.selectedSubjects addObject:subject];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
}

- (void)sendObject:(NSMutableArray *)subject
{
    if (!_selectedSubjects)
        _selectedSubjects = [NSMutableArray new];
    [self.selectedSubjects addObject:subject];
}


@end
