//
//  ViewController.m
//  Calculator
//
//  Created by Алексей on 04.10.17.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"

@interface ViewController ()
@property(strong, nonatomic) Calculator *calculator;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@end

@implementation ViewController

@synthesize calculator = _calculator;

NSString* currentNumber = @"";

- (Calculator *)calculator {
    if (!_calculator) {
        _calculator = [[Calculator alloc] init];
    }
    return _calculator;
}

- (IBAction)appendDigit:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    [self updateDisplay:digit];
    currentNumber = [currentNumber stringByAppendingString:digit];
}

- (IBAction)operate:(UIButton *)sender {
    if (![currentNumber  isEqual: @""]) {
        double myDouble = [currentNumber doubleValue];
        [self.calculator pushOperand:myDouble];
    }
    currentNumber = @"";
    NSString* operation = [sender currentTitle];
    [self.calculator pushOperation:operation];
    [self updateDisplay:operation];
}

- (IBAction)calculate {
    if (![currentNumber  isEqual: @""]) {
        double myDouble = [currentNumber doubleValue];
        [self.calculator pushOperand:myDouble];
    }
    self.outDisplay.text = self.inDisplay.text;
    double res = [self.calculator performOperation];
    
    NSNumber *myDoubleNumber = [NSNumber numberWithDouble:res];
    self.inDisplay.text = [myDoubleNumber stringValue];
    
    [self.calculator clearProgramStack];
    currentNumber = [[NSNumber numberWithDouble:res] stringValue];
}

- (void)updateDisplay:(NSString *)valueToDisplay {
        self.inDisplay.text = [self.inDisplay.text stringByAppendingString: valueToDisplay];
}

- (IBAction)clean {
    currentNumber = @"";
    [self.calculator clearProgramStack];
    self.inDisplay.text = @"";
}

- (void)setColor:(UIColor *)color button:(UIButton*)button  forState:(UIControlState)state {
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    colorView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [button setBackgroundImage:colorImage forState:state];
}

- (void)setButtonsColor {
    for (UIButton *button in _allButtons) {
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        [button.backgroundColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        brightness *= 0.8;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
        [self setColor:color button:button forState:UIControlStateHighlighted];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self setButtonsColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
