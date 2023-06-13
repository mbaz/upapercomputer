/* Miguel Bazdresch
 * 31-03-2005
 *
 * interface file for class bus */

@interface Bus : NSObject {
    int wires;
}

- (void) DistributeSignal: (int)bus;
- (int) ShowContents;

@end
