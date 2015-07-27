//
//  UserListVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 27/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "UserListVC.h"
#import "UserManager.h"
#import "UserListCell.h"
#import "User.h"

@interface UserListVC()
@property (strong, nonatomic) UserManager *userManager;
@property (strong, nonatomic) NSArray *userList;
@end



@implementation UserListVC


- (UserManager *)userManager
{
    if (!_userManager) {
        _userManager = [UserManager sharedInstance];
    }
    return _userManager;
}

- (void)viewDidLoad
{
    if (!_userList) {
        _userList = [self.userManager getAllUser];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.userList count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"userCell" forIndexPath:indexPath];
    User *user = [self.userList objectAtIndex:indexPath.row];
    if (user.photo) {
        cell.imageView.image = [UIImage imageWithData:user.photo];
    }
    cell.usernameText.text = user.username;
    return cell;
}


@end
