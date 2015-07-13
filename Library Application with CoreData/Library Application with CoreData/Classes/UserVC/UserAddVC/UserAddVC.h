//
//  UserAddVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UserAddVC : UIViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
