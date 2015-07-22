//
//  AdminHomeVC.m
//  Library Application with CoreData
//
//  Created by Ömer Emre Aslan on 13/07/15.
//  Copyright © 2015 omer. All rights reserved.
//

#import "AdminHomeVC.h"

@interface AdminHomeVC ()

@end

@implementation AdminHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
