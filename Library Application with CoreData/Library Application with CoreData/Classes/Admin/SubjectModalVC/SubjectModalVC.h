//
//  SubjectModalVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddBookVC.h"
@interface SubjectModalVC : UITableViewController<UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSMutableArray *selectedSubjects;

@property (strong, nonatomic) AddBookVC *addbookvc;
@end
