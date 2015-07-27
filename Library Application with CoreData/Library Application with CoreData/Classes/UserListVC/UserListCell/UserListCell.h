//
//  UserListCell.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 27/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameText;

@end
