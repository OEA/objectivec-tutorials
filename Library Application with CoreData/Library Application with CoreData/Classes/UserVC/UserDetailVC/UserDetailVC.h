//
//  UserDetailVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UserDetailVC : UITableViewController<UISearchResultsUpdating, UISearchControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSString *username;
@end
