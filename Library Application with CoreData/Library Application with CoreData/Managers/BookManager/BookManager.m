//
//  BookManager.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 21/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "BookManager.h"
#import "UserLogManager.h"
#import "NSString+CheckingEmpty.h"

@interface BookManager()
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end

@implementation BookManager


+ (instancetype)sharedInstance
{
    static BookManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [self.class sharedInstance];
}


#pragma mark - Core Data method
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//Book CRUD methods
- (void)createBook:(Book *)book
{
    
    if (![self getBookFromName:book.title]) {
        
        if (![book.title isCompleteEmpty] && ![book.author.name isCompleteEmpty]
            && ![[NSString stringWithFormat:@"%@",book.pages] isCompleteEmpty]) {
            //Create insertable Book model
            Book *creationBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
            //Setting all necessary fields
            [creationBook setTitle:book.title];
            [creationBook setPublishDate:book.publishDate];
            [creationBook setAuthor:book.author];
            [creationBook setSubjects:book.subjects];
            [creationBook setImage:book.image];
            [creationBook setPages:book.pages];
            
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }

        } else {
            @throw [[NSException alloc] initWithName:@"Custom" reason:@"emptyFields" userInfo:nil];
        }

    } else {
        @throw [[NSException alloc] initWithName:@"Custom" reason:@"pickedBook" userInfo:nil];
    }
    //Creation Log
    //[self.userLogManager createLog:@"createUser" :creationUser];
}
- (void)updateBook:(Book *)book
{
    //Create query SELECT * FROM Book where title = 'book.title' to get book
    Book *editingBook = [self getBookFromName:book.title];
    //Setting all necessarry fields
    
    if (![book.title isCompleteEmpty]) {
        [editingBook setTitle:book.title];
    }
    if (![book.author.name isCompleteEmpty]) {
        [editingBook setAuthor:book.author];
    }
    if (![book.image isCompleteEmpty]) {
        [editingBook setImage:book.image];
    }
    if (![[NSString stringWithFormat:@"%@",book.pages] isCompleteEmpty]) {
        [editingBook setPages:book.pages];
    }
    [editingBook setPublishDate:book.publishDate];
    [editingBook setSubjects:book.subjects];
    
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //[self.userLogManager createLog:@"updateUser" :editingUser];
}
- (void)deleteBook:(Book *)book
{
    Book *deletingBook = [self getBookFromName:book.title];
    
    //[self.userLogManager createLog:@"removeUser" :deletingBook];
    
    [self.managedObjectContext deleteObject:deletingBook];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
}
- (Book *)getBookFromName:(NSString *)name
{
    //Create query SELECT * FROM Book where title = 'book.title' to get book
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", name];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    Book *book = [results firstObject];
    return book;
}

- (NSArray *)getAllBooks
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    NSError *searchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&searchError];
    return results;
}

- (void)clearBooksFromSubject:(Subject *)deletingSubject
{
    NSMutableArray *books = [self getAllBooks];
    for (Book *book in books) {
        [book removeSubjectsObject:deletingSubject];
    }
}

@end
