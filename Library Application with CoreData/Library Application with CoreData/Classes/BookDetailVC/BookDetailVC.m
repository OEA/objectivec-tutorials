//
//  BookDetailVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "BookDetailVC.h"
#import "Subject.h"

@interface BookDetailVC ()
@property (strong, nonatomic) NSCache *imagesCache;
@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bookName.text = self.book.title;
    self.bookPages.text = [NSString stringWithFormat:@"%@",self.book.pages];
    self.availability.text = @"Available";
    self.bookSubjects.text = @"";
    for (Subject *subject in self.book.subjects) {
        self.bookSubjects.text = [self.bookSubjects.text stringByAppendingString:[NSString stringWithFormat:@"%@ ",subject.name]];
    }
   
    self.bookSummary.text = @"test";
    self.bookYear.text = [NSString stringWithFormat:@"%@ ",self.book.publishDate];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.book.publishDate];
    
    self.bookYear.text = [NSString stringWithFormat:@"%ld", (long)[components year]];
    
    self.bookImage.image = [UIImage imageWithData:[self getImageFromURLOrCache:self.book.image]];
    
    if (![self isBookAvailable]){
        [self.getButton setBackgroundColor:[UIColor orangeColor]];
        [self.getButton setTitle:@"NOTIFY ME" forState:UIControlStateNormal];
        [self.getButton setEnabled:NO];
    }
}


- (BOOL)isBookAvailable
{
    return YES;
}

- (NSData *)getImageFromURLOrCache:(NSString *)url
{
    NSData *data = [self.imagesCache objectForKey:url];
    if (!data) {
        if (url) {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (data)
                [self.imagesCache setObject:data forKey:url];
        }
    }
    
    return data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
