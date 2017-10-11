//
//  Calculator.h
//  Calculator
//
//  Created by Алексей on 09.10.17.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation;
- (void)pushOperation:(NSString*)variable;
- (void)clearProgramStack;

@end
