//
//  SubjectModalVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "SubjectModalVC.h"
#import "Subject.h"
#import "SubjectManager.h"

@interface SubjectModalVC ()

@property (strong, nonatomic) NSMutableArray *subjects;
@property (strong, nonatomic) SubjectManager *subjectManager;
@end

@implementation SubjectModalVC


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_subjects)
        _subjects = [NSMutableArray new];
    if (!_selectedSubjects)
        _selectedSubjects = [NSMutableArray new];
    
    
    [self initSubjects];
    
    NSArray *results = [self.subjectManager getAllSubjects];
    
    if ([results count] > 0) {
        
    } else {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
        Subject *uncategorized = [[Subject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        [uncategorized setName:@"Uncategorized"];
        [self.subjectManager createSubject:uncategorized];
        
    }
    [self.tableView reloadData];
}

- (SubjectManager *)subjectManager
{
    if (!_subjectManager)
        _subjectManager = [SubjectManager sharedInstance];
    return _subjectManager;
}

- (void)initSubjects
{
    self.subjects = [self.subjectManager getAllSubjects];
    
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
    if ([self.delegate respondsToSelector:@selector(sendObject:)]) {
        [self.delegate sendObject:self.selectedSubjects];
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



@end
