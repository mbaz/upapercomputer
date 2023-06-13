/* Miguel Bazdresch
 * 1-04-2005
 *
 * interface file for class mem */

@interface Mem : NSObject {

    instruction * inst;
    int initflag;
}

- (int) InitMem: (int)size;
- (int) WriteInst: (instruction)data InDir: (int)dir;
- (int) WriteData: (int)data InDir: (int)dir;
- (instruction) ReadInst: (int)dir;
- (int) ReadData: (int)dir;

@end
