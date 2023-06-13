/* Miguel Bazdresch
 * 1-04-2005
 *
 * implementation file for class alu */

#include "cpu.h"

@implementation Alu

- (int) Add: (int)op1 And: (int)op2 {
    result = op1 + op2;
    return result;
}

- (int) Mul: (int)op1 And: (int)op2 {
    result = op1 * op2;
    return result;
}

- (int) Sub: (int)op1 And: (int)op2 {
    result = op1 - op2;
    return result;
}

- (int) Div: (int)op1 And: (int)op2 {
    result = op1 / op2;
    return result;
}

@end
