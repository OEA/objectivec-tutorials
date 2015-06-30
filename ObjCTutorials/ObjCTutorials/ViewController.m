//
//  ViewController.m
//  ObjCTutorials
//
//  Created by Ömer Emre Aslan on 02/06/15.
//
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblText;

@end

@implementation ViewController

- (double) alan {
    return 2; 
}

- (double) cevre {
    return 3;  
}

- (void) setYaricap:(double)a {
    yas = self.alan + a;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setYaricap:5];
    self.lblText.text = [NSString stringWithFormat:@"Hello %f Objective C",yas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
