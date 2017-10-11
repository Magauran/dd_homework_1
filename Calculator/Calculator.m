//
//  Calculator.m
//  Calculator
//
//  Created by Алексей on 09.10.17.
//  Copyright © 2017 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calculator.h"

@interface Calculator()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableArray *operationStack;
@property (nonatomic, strong) NSDictionary *operationDictionary;
@end

@implementation Calculator

@synthesize programStack = _programStack;
@synthesize operationStack = _operationStack;
                            
- (NSDictionary *) operationDictionary {
    id priorities[] = {@2, @2, @3, @3, @0, @1};
    id operations[] = { @"+", @"−", @"×", @"÷", @"(", @")"};
    NSUInteger count = sizeof(priorities) / sizeof(id);

    if (!_operationDictionary) {
        _operationDictionary = [NSDictionary dictionaryWithObjects:priorities forKeys:operations count:count];
    }
    return _operationDictionary;
}

- (NSMutableArray *) operationStack {
    if (!_operationStack) {
        _operationStack = [NSMutableArray new];
    }
    return _operationStack;
}

+ (double) popProgramStack:(NSMutableArray *) stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
        while (result == 0) {
            result = [self popProgramStack:stack];
        }
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popProgramStack:stack] + [self popProgramStack:stack];
        } else if ([operation isEqualToString:@"×"]) {
            result = [self popProgramStack:stack] * [self popProgramStack:stack];
        } else if ([operation isEqualToString:@"−"]) {
            double subtrahend = [self popProgramStack:stack];
            result = [self popProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"÷"]) {
            double divisor = [self popProgramStack:stack];
            if (divisor) {
                result = [self popProgramStack:stack] / divisor;
            }
        }
    }
    return result;
}

+ (double) runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popProgramStack:stack];
}

- (NSMutableArray *) programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id) program {
    return self.programStack.copy;
}

- (void) pushOperand:(double) operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}


- (void) pushOperation:(NSString*) operation {
    // http://5fan.ru/wievjob.php?id=6225
    if ([[self.operationDictionary objectForKey:operation] intValue] == 0) {
        [self.operationStack addObject:operation];
    } else if ([[self.operationDictionary objectForKey:operation] intValue] == 1) {
        while (![[self.operationStack lastObject]  isEqual: @"("] && ([self.operationStack count] != 0)) {
            id topOfStack = [self.operationStack lastObject];
            if (topOfStack) {
                [self.programStack addObject:topOfStack];
            }
            [self.operationStack removeLastObject];
        }
        [self.operationStack removeLastObject];
    } else if ([[self.operationDictionary objectForKey:operation] intValue] <= [[self.operationDictionary objectForKey:[self.operationStack lastObject]] intValue]) {
        while ([self.operationStack count] != 0) {
            id topOfStack = [self.operationStack lastObject];
            if (topOfStack) {
                [self.programStack addObject:topOfStack];
            }
            [self.operationStack removeLastObject];
        }
        [self.operationStack addObject:operation];
    } else {
        [self.operationStack addObject:operation];
    }
}

- (double) performOperation {
    while ([self.operationStack count] != 0) {
        id topOfStack = [self.operationStack lastObject];
        [self.programStack addObject:topOfStack];
        [self.operationStack removeLastObject];
    }
    return [Calculator runProgram:self.program];
}

- (void) clearProgramStack {
    [self.programStack removeAllObjects];
}

@end
