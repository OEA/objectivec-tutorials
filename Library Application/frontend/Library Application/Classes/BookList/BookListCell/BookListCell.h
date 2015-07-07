//
//  BookListCell.h
//  Library Application
//
//  Created by Ömer Emre Aslan on 07/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bookTitle;
@property (strong, nonatomic) IBOutlet UILabel *bookAuthor;
@property (strong, nonatomic) IBOutlet UIImageView *bookImage;
@property (strong, nonatomic) IBOutlet UILabel *bookPages;
@property (strong, nonatomic) IBOutlet UILabel *bookPublished;
@end
