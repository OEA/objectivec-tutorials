//
//  UserListVCViewController.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 11/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "UserListVCViewController.h"

@interface UserListVCViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *userArray;
@property (strong, nonatomic) NSArray *userFilterArray;
@end

@implementation UserListVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
     

- (NSArray *)userArray
{
    if (!_userArray) {
        _userArray = @[@"Apple", @"Samsung", @"Lenovo", @"MSI", @"Monster"];
    }
    return _userArray;
}

- (NSArray *)userFilterArray
{
    _userFilterArray = self.userArray;
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
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = [self.userArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self..searchResultsTableView)
    return self.userArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
