/* Miguel Bazdresch
 * 31-02-2005
 *
 * implementation file for class bus */

#include "cpu.h"

@implementation Bus

- (void) DistributeSignal: (int)bus {
    wires = bus;
}

- (int) ShowContents {
    return wires;
}

@end
