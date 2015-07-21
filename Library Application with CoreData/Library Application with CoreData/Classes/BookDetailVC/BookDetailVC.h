//
//  BookDetailVC.h
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
@interface BookDetailVC : UIViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) Book *book;

@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPages;
@property (weak, nonatomic) IBOutlet UILabel *availability;
@property (weak, nonatomic) IBOutlet UILabel *bookSubjects;
@property (weak, nonatomic) IBOutlet UITextView *bookSummary;
@property (weak, nonatomic) IBOutlet UILabel *bookYear;
@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end
