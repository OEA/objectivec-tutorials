//
//  AddBookVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "AddBookVC.h"
#import "Book.h"

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
        Book *book = [Book new];
        book.title = self.bookTitle.text;
        book.author = self.author.text;
        book.pages = [self.pages.text integerValue];
        book.publishdate = self.publishDate.text;
        book.imageUrl = self.imageUrl.text;
        [_books addObject:book];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
