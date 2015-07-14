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
#import "Subject.h"

@protocol SubjectModelDelegate <NSObject>
- (void) sendObject:(Subject *)subject;
@end

@interface SubjectModalVC : UITableViewController<UITableViewDelegate,NSFetchedResultsControllerDelegate, AddBookModelDelegate>

@property (nonatomic, strong) id <SubjectModelDelegate> delegate;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSMutableArray *selectedSubjects;

@end
