/* Miguel Bazdresch
 * 1-04-2005
 *
 * interface file for class umem */

@interface Umem : NSObject {
    microinst * inst;
    int initflag;
}

- (int) InitMem: (int)size;
- (int) Write: (microinst)data InDir: (int)dir;
- (microinst) Read: (int)dir;

@end
