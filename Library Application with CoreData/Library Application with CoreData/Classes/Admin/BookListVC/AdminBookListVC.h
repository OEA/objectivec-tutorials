//
//  BookListVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>



@interface AdminBookListVC : UITableViewController<NSFetchedResultsControllerDelegate>
//Core Data context variable
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;


@end
