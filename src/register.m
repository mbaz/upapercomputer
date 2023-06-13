/* Miguel Bazdresch
 * 31-03-2005
 *
 * implementation file for class register */

#include "cpu.h"

@implementation Register

- (int) ShowContents {
    return r;
}

- (void) StoreInput: (int)bus {
    r = bus;
}

@end

@implementation RegWithInc

- (void) Increment {
    r++;
}

@end

@implementation RegInst

- (char *) ShowOpcode {
    return inst.opcode;
}

- (int) ShowOp1 {
    return inst.op1;
}

- (int) ShowOp2 {
    return inst.op2;
}

- (instruction) ShowInst {
    return inst;
}

- (int) ShowData {
    return r;
}

- (void) StoreInst: (instruction)bus {
    inst = bus;
}

- (void) StoreData: (int)bus {
    r = bus;
}

@end
