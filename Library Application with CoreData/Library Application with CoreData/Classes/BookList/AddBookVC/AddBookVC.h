//
//  AddBookVC.h
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AddBookVC : UIViewController <UIPickerViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic)NSMutableArray *books;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) NSMutableArray *subjects;

@end
