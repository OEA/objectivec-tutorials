//
//  MainVC.m
//  Simple Calculator
//
//  Created by Ömer Emre Aslan on 01/07/15.
//  Copyright (c) 2015 omer. All rights reserved.
//

#import "MainVC.h"
#import "CalculatorManager.h"
@interface MainVC()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *calculatorButtons;
@property (strong, nonatomic) IBOutlet UITextView *resultText;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) CalculatorManager *calculateManager;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *logicalButtons;
@property (nonatomic, copy) Stack *stack;
@end

@implementation MainVC


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    if (!_calculateManager)
        _calculateManager = [CalculatorManager sharedInstance];
    if (!_stack)
        _stack = [Stack new];
    
}
- (IBAction)numbersButtonTapped:(id)sender 
{
    

    UIButton *button = (UIButton *)sender;

    [self clearBorderOfLogicalButtons];
    if ([self hasResultZero] || self.calculateManager.isOnProgress) {
        self.calculateManager.isOnProgress = NO;
        if (![[button currentTitle] isEqualToString:@"00"]) {
            self.resultText.text = [button currentTitle];
            [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
        }
    } else {
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
        self.resultText.text = [self.resultText.text stringByAppendingString:[button currentTitle]];
    }
}
- (IBAction)plusMinusButtonTapped:(id)sender {

    if (self.calculateManager.isOnProgress) {
        self.resultText.text = @"-0";
    } else {
        NSNumber *number = [self convertStringToNumber:self.resultText.text];
        if ([number floatValue] > 0 ) {
            self.resultText.text = [NSString stringWithFormat:@"-%@", number];
        } else if ([number floatValue] < 0){
            float number1 = [number floatValue];
            float product = number1 * -1;
            NSNumber *result = [NSNumber numberWithFloat:product];
            self.resultText.text = [NSString stringWithFormat:@"%@", result];
        } else {
            //do Nothing when it is zero
        }
    }
}
- (IBAction)commaButtonTapped:(id)sender {
    
    if ([self.resultText.text containsString:@"."]) {
        //do nothing
    } else {
        if (self.calculateManager.isOnProgress) {
            self.resultText.text = [@"0" stringByAppendingString:@"."];
            self.calculateManager.isOnProgress = NO;
        } else {
            self.resultText.text = [self.resultText.text stringByAppendingString:@"."];
        }
    }
}

- (BOOL)hasResultZero
{
    return ([self.resultText.text isEqualToString:@"0"]) ? YES : NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{ 
    return UIStatusBarStyleLightContent; 
}
- (IBAction)equalsButtonTapped:(id)sender {
    
    @try {
        [self clearBorderOfLogicalButtons];
        
        [self.stack push:[self convertStringToNumber:self.resultText.text]];
        NSNumber *number = [self.calculateManager calculateFromInfixExpression:self.stack];
        
        NSString *newTitle = [NSString stringWithFormat:@"%@",number];
        
        self.resultText.text = newTitle;
        self.calculateManager.isOnProgress = YES;

    }
    @catch (NSException *exception) {
        NSLog(@"exc: %@",exception);
        self.resultText.text = @"Error";
        self.calculateManager.isOnProgress = YES;
    }
    @finally {
        
    }
    
    
}

- (IBAction)percentageButtonTapped:(id)sender {
    [self.stack push:[self convertStringToNumber:self.resultText.text]];
    [self.stack push:@"/"];
    [self.stack push:@(100)];
    NSNumber *number = [self.calculateManager calculateFromInfixExpression:self.stack];
    
    NSString *newTitle = [NSString stringWithFormat:@"%@",number];
    
    self.resultText.text = newTitle;
    
    self.calculateManager.isOnProgress = YES;
    
    [self clearBorderOfLogicalButtons];
    
}
- (void)clearBorderOfLogicalButtons {
    
    for (UIButton *button in self.logicalButtons) {
        [[button layer] setBorderColorWithWidth:0.25f :[UIColor colorWithRed:0.0f/255.0f
                                                                       green:0.0f/255.0f
                                                                        blue:0.0f/255.0f
                                                                       alpha:0.75f]];
    }
}

- (IBAction)logicalButtonsTapped:(id)sender {
    
    //In construction
    /*
    
    */
    
    NSString *title = [sender currentTitle];
    if ([title isEqualToString:@"x"] || [title isEqualToString:@"X"])
        title = @"*";
    if ([title isEqualToString:@"÷"])
        title = @"/";
    if ([title isEqualToString:@"—"])
        title = @"-";
    
    [self.stack push:[self convertStringToNumber:self.resultText.text]];
    [self.stack push:title];
   
    NSNumber *number = [self.calculateManager calculateFromInfixExpression:self.stack];
    
    NSString *newTitle = [NSString stringWithFormat:@"%@",number];
    
    self.resultText.text = newTitle;
    
    self.calculateManager.isOnProgress = YES;
    
    [self clearBorderOfLogicalButtons];
    
    [[sender layer] setBorderColorWithWidth:2.0f :[UIColor colorWithRed:0.0f/255.0f
                                                                  green:0.0f/255.0f
                                                                   blue:0.0f/255.0f
                                                                  alpha:0.4f]];
}

- (void)updateUI
{
    [self setNeedsStatusBarAppearanceUpdate];
    for (UIButton *button in self.calculatorButtons) {
        [[button layer] setBorderColorWithWidth:0.25f :[UIColor colorWithRed:0.0f/255.0f
                                                                      green:0.0f/255.0f
                                                                       blue:0.0f/255.0f
                                                                      alpha:0.75f]];
    }
}

- (NSNumber *)convertStringToNumber:(NSString *)number
{
    NSNumberFormatter *f = [NSNumberFormatter new];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:number];
    return myNumber;
}

- (IBAction)clearResultText:(id)sender 
{
    [[self.stack stack] removeAllObjects];
    self.resultText.text = @"0";
    [self clearBorderOfLogicalButtons];
    [self.clearButton setTitle:@"AC" forState:UIControlStateNormal];
}
@end
