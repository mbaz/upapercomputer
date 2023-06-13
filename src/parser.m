/* the parser reads files code.dat and microcode.dat
 * the contents of code.dat are stored in object mem,
 * and those of microcode.dat in object umem. */

#include "cpu.h"

int parser(WINDOW * w, Mem * mem, Umem * umem) {

    FILE * file;

    int flag, op, dir;
    microinst mi;
    instruction i;

    /* open microfile */
    file = fopen( "microcode.dat", "r" );
    if( file == NULL ) {
        update_winstatus(w, "microcode.dat file not found!", "");
        getch();
        endwin();
        exit(1);
    }

    /* parse microfile 
     * the syntax of the microfile is as follows:
     * (int)dir (char *)inst */

    while( feof(file) == 0 ) {
        fscanf(file, "%d %s", &dir, &mi.microop);
        [umem Write: mi InDir: dir];
    }

    /* open code file */
    file = fopen( "code.dat", "r");
    if( file == NULL ) {
        update_winstatus(w, "code.dat file not found!", "");
        getch();
        endwin();
        exit(1);
    }

    /* parse code file
     * the syntax of the code file follows:
     * (char)flag (int)dir (char *)inst (int)op1 (int)op2 - when flag='i'
     * (char)flag (int)dir (int)data                      - when flag='d' */
    while( feof(file) == 0 ) {
        fscanf(file, "%s", &flag);
        if( flag == 'i') {
            fscanf( file, "%d %s %d %d", &dir, &i.opcode, &i.op1, &i.op2 );
            [mem WriteInst: i InDir: dir];
        }
        else {
            fscanf( file, "%d %d", &dir, &op);
            [mem WriteData: op InDir: dir];
        }
    }
    return 0;
}
