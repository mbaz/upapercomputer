/* Miguel Bazdresch
 * 1-04-2005
 *
 * implementation file for class umem */

#include "cpu.h"

@implementation Umem

- (int) InitMem: (int)size {
    inst = (microinst * )malloc( (size_t)size * sizeof(microinst) );
    if( inst != NULL ) {
        initflag = 1;
        return 0;
    }
    else exit(1);
}

- (int) Write: (microinst)data InDir: (int)dir {
    if( initflag == 1 ) {
        strcpy( inst[dir].microop, data.microop );
        return 0;
    }
    else exit(1);
}

- (microinst) Read: (int)dir {
    return inst[dir];
}

@end
