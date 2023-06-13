/* Miguel Bazdresch
 * 1-04-2005
 *
 * interface file for class alu */

@interface Alu : NSObject {
    int result;
}

- (int) Add: (int)op1 And: (int)op2;
- (int) Mul: (int)op1 And: (int)op2;
- (int) Sub: (int)op1 And: (int)op2;
- (int) Div: (int)op1 And: (int)op2;

@end
