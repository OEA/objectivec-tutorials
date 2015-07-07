//
//  RegisterVC.m
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "RegisterVC.h"
#import "BookListVC.h"
@implementation RegisterVC


- (NSMutableArray *)books
{
    if (!_books)
        _books = [NSMutableArray new];
    return _books;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"listBooks"]) {
        BookListVC *vc = segue.destinationViewController;
        vc.books = self.books;
    }
}

@end
