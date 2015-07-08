//
//  AddBookVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "AddBookVC.h"
#import "Book.h"
#import "Author.h"

@interface AddBookVC()

@property (strong, nonatomic) IBOutlet UITextField *bookTitle;

@property (strong, nonatomic) IBOutlet UITextField *author;
@property (strong, nonatomic) IBOutlet UITextField *pages;
@property (strong, nonatomic) IBOutlet UITextField *publishDate;
@property (strong, nonatomic) IBOutlet UITextField *imageUrl;

@end

@implementation AddBookVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)addButtonTapped:(id)sender {
    
    if (!_books) {
        //do nothing
    } else {
//        Book *book = [Book new];
//        book.title = self.bookTitle.text;
//        book.author = self.author.text;
//        book.pages = [self.pages.text integerValue];
//        book.publishdate = self.publishDate.text;
//        book.imageUrl = self.imageUrl.text;
//        [_books addObject:book];
        
        Author *author;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.author.text];
        
        NSError *searchError;
        
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
        
        if ([results count] > 0) {
            author = [results objectAtIndex:0];
        } else {
            author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self.managedObjectContext];
            [author setValue:self.author.text forKey:@"name"];
        }
        
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
        
        [book setValue:self.bookTitle.text forKey:@"title"];
        [book setValue:[self numberFromString:self.pages.text] forKey:@"pages"];
        [book setValue:[self dateFromString:self.publishDate.text] forKey:@"publishDate"];
        [book setValue:[self imageFromUrl:self.imageUrl.text] forKey:@"image"];
        [book setValue:author forKey:@"author"];
        
        [author addBooksObject:book];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSNumber *)numberFromString:(NSString *)numberStr
{
    return [NSNumber numberWithInteger:[numberStr integerValue]];
}

- (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy"];
    return [dateFormat dateFromString:dateStr];  
}

- (NSData *)imageFromUrl:(NSString *)url
{
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
}

@end
