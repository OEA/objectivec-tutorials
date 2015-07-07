//
//  BookListVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "BookListVC.h"
#import "BookListCell.h"
#import "Book.h"
#import "AddBookVC.h"

@interface BookListVC()
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@end

@implementation BookListVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([_books count] == 0)
        [self initBooks];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mTableView reloadData];
}
- (void)initBooks
{
    
    Book *gameOfThrones = [Book new]; 
    gameOfThrones.title = @"A Game of Thrones";
    gameOfThrones.author = @"George R. R. Martin";
    gameOfThrones.pages = 710;
    gameOfThrones.publishdate = @"1997";
    gameOfThrones.imageUrl = @"http://ecx.images-amazon.com/images/I/51Yl0b4CjWL._SX329_BO1,204,203,200_.jpg";
    
    Book *clashOfKings = [Book new]; 
    clashOfKings.title = @"A Clash of Kings";
    clashOfKings.author = @"George R. R. Martin";
    clashOfKings.pages = 1040;
    clashOfKings.publishdate = @"2000";
    clashOfKings.imageUrl = @"http://ecx.images-amazon.com/images/I/51o2UG3sp3L._SX305_BO1,204,203,200_.jpg";
    
    [_books addObject:gameOfThrones];
    [_books addObject:clashOfKings];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListCell *cell = [BookListCell new];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Book Cell" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        Book *book = [_books objectAtIndex:indexPath.row];
        
    cell.bookTitle.text = book.title;
    cell.bookAuthor.text = book.author;
    cell.bookPages.text =[NSString stringWithFormat:@"%li pages",book.pages];
    cell.bookPublished.text = book.publishdate;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.bookImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:book.imageUrl]]];
    });
        
    });
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addBook"]) {
        AddBookVC *vc = segue.destinationViewController;
        vc.books = self.books;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_books count];
}
@end
