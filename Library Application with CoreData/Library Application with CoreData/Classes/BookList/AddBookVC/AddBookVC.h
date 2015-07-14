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
#import "Subject.h"


@protocol AddBookModelDelegate <NSObject>
- (void) sendObject:(Subject *)subject;
@end

@interface AddBookVC : UIViewController <UIPickerViewDelegate, NSFetchedResultsControllerDelegate>


@property (nonatomic, strong) id <AddBookModelDelegate> delegate;


@property (strong, nonatomic)NSMutableArray *books;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) NSMutableArray *subjects;

@end
