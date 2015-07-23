//
//  BookEditVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 14/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Book.h"
@interface BookEditVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong,nonatomic)NSString *bookTitle;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSMutableArray *subjects;
@property (strong, nonatomic) Book* book;

@end
