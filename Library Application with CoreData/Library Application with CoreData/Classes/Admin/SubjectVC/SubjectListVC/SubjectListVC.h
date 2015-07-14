//
//  SubjectListVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface SubjectListVC : UITableViewController <
    UISearchResultsUpdating,
    NSFetchedResultsControllerDelegate,
    UISearchControllerDelegate>

@end
