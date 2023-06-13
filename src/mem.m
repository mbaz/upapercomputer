/* Miguel Bazdresch
 * 1-04-2005
 *
 * implementation file for class mem */

#include "cpu.h"

@implementation Mem

- (int) InitMem: (int)size {
    inst = (instruction * )malloc( (size_t)size * sizeof(instruction) );
    if( inst != NULL ) {
        initflag = 1;
        return 0;
    }
    else exit(1);
}

- (int) WriteInst: (instruction)data InDir: (int)dir {
    if( initflag == 1 ) {
        strcpy( inst[dir].opcode, data.opcode );
        inst[dir].op1 = data.op1;
        inst[dir].op2 = data.op2;
        inst[dir].data = 0;
        return 0;
    }
    else exit(1);
}

- (int) WriteData: (int)data InDir: (int)dir {
    if( initflag == 1 ) {
        inst[dir].data = data;
        return 0;
    }
    else exit(1);
}

- (instruction) ReadInst: (int)dir {
    instruction contents;

    strcpy( contents.opcode, inst[dir].opcode );
    contents.op1 = inst[dir].op1;
    contents.op2 = inst[dir].op2;
    return contents;
}

- (int) ReadData: (int)dir {
    return inst[dir].data;
}

@end
