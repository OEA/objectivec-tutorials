//
//  BookListVC.h
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BookListVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSMutableArray *books; //of library

//Core Data context variable
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
