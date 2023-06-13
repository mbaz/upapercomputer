/* Miguel Bazdresch
 * 31-02-2005
 *
 * interface file for class Register */

@interface Register : NSObject {
    int r;
}

- (int) ShowContents;
- (void) StoreInput: (int)bus;

@end

@interface RegWithInc : Register {
}

- (void) Increment;

@end

@interface RegInst : Register {
    instruction inst;
}

- (char *) ShowOpcode;
- (int) ShowOp1;
- (int) ShowOp2;
- (instruction) ShowInst;
- (int) ShowData;
- (void) StoreInst: (instruction)bus;
- (void) StoreData: (int)bus;

@end
