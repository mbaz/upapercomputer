/* Miguel Bazdresch
 * 31-03-2005
 *
 * main file for cpu simulator */

#include "cpu.h"

int main(void) {

    /* flag that tells if current instruction is a halt */
    int halt = 0;

    /* initialize objects */
    Register * reg1, * reg2, * reg3, * reg4;
    Register * mar, * w1, * w2, * y;
    RegWithInc * pc, *upc;
    RegInst * mdr, * ir;

    /* data registers */
    reg1 = [[Register alloc] init];
    reg2 = [[Register alloc] init];
    reg3 = [[Register alloc] init];
    reg4 = [[Register alloc] init];

    /* specialized registers */
    mar = [[Register alloc] init];
    w1  = [[Register alloc] init];
    w2  = [[Register alloc] init];
    y   = [[Register alloc] init];
    pc  = [[RegWithInc alloc] init];
    upc = [[RegWithInc alloc] init];
    mdr = [[RegInst alloc] init];
    ir  = [[RegInst alloc] init];

    /* bus */
    Bus * bus;
    bus = [[Bus alloc] init];

    /* alu */
    Alu * alu;
    alu = [[Alu alloc] init];

    /* mem */
    Mem * mem;
    mem = [[Mem alloc] init];

    /* micromem */
    Umem * umem;
    umem = [[Umem alloc] init];

    /* ncurses */
    WINDOW * winpc, * winupc, * winstatus;
    WINDOW * winmar, * winreg;
    WINDOW * winalu, * winbus;
    WINDOW * windata;

    initscr(); /* initialize screen */
    cbreak(); /* don't wait for newline */
    noecho(); /* don't echo input */
    refresh(); /* first one clears the screen */

    /* create windows */
    winpc = create_window( 20, 24, 0, 0 );
    winupc = create_window( 11, 24, 20, 0 );
    windata = create_window( 8, 24, 31, 0 );
    winstatus = create_window( 3, 50, 39, 0 );
    winmar = create_window( 14, 24, 0, 25 );
    winreg = create_window( 8, 24, 19, 25 );
    winalu = create_window( 7, 24, 27, 25 );
    winbus = create_window( 5, 24, 14, 25 );

    /* store program and uprogram */
    [umem InitMem: 50];
    [mem InitMem: 50];
    parser( winstatus, mem, umem );

    [pc StoreInput: 0];
    [upc StoreInput: 0];

    update_winstatus(winstatus,"Press any key to start.","");
    getch();

    /* main loop */
    while( !halt ) {
        microinst ui;
        char key;

        ui = [umem Read: [upc ShowContents]];
        update_winpc( winpc, pc, mem );
        update_winupc( winupc, upc, umem );
        update_windata( windata, mem );
        update_winmar( winmar, mar, mdr, ir );
        update_winreg( winreg, reg1, reg2, reg3, reg4 );
        update_winalu( winalu, w1, w2, y );
        update_winbus( winbus, bus );
        update_winstatus( winstatus, "Running...","");
        key = getch();
        if( key == 'q' ) {
            endwin();
            exit(1);
        }

        /* load mar */
        if( !strcmp(ui.microop,"marpc") ) {
            [mar StoreInput: [pc ShowContents]];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"marop1") ) {
            [mar StoreInput: [ir ShowOp1]];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"marop2") ) {
            [mar StoreInput: [ir ShowOp2]];
            [upc Increment];
        }
        /* load ir */
        else if( !strcmp(ui.microop,"irmdr") ) {
            [ir StoreInst: [mdr ShowInst]];
            [upc Increment];
        }
        /* load mdr from mem */
        else if( !strcmp(ui.microop,"mdrmei") ) {
            [mdr StoreInst: [mem ReadInst: [mar ShowContents]]];
            [mdr StoreData: 0];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"mdrmed") ) {
            instruction i;

            strcpy(i.opcode,"");
            i.op1 = 0;
            i.op2 = 0;
            [mdr StoreData: [mem ReadData: [mar ShowContents]]];
            [mdr StoreInst: i];
            [upc Increment];
        }
        /* load mdr from bus */
        else if( !strcmp(ui.microop,"mdrbus") ) {
            instruction i;

            strcpy(i.opcode,"");
            i.op1 = 0;
            i.op2 = 0;

            [mdr StoreData: [bus ShowContents]];
            [mdr StoreInst: i];
            [upc Increment];
        }
        /* load bus */
        else if( !strcmp(ui.microop,"busmdr") ) {
            [bus DistributeSignal: [mdr ShowData]];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"busy") ) {
            [bus DistributeSignal: [y ShowContents]];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"busro1") ) {
            int regnum = [ir ShowOp1];

            switch( regnum ) {
                case 1:
                    [bus DistributeSignal: [reg1 ShowContents]];
                    break;
                case 2:
                    [bus DistributeSignal: [reg2 ShowContents]];
                    break;
                case 3:
                    [bus DistributeSignal: [reg3 ShowContents]];
                    break;
                case 4:
                    [bus DistributeSignal: [reg4 ShowContents]];
                    break;
                default:
                    return -1;
            }

            [upc Increment];
        }
        else if( !strcmp(ui.microop,"busro2") ) {
            int regnum = [ir ShowOp2];

            switch( regnum ) {
                case 1:
                    [bus DistributeSignal: [reg1 ShowContents]];
                    break;
               case 2:
                    [bus DistributeSignal: [reg2 ShowContents]];
                    break;
               case 3:
                    [bus DistributeSignal: [reg3 ShowContents]];
                    break;
               case 4:
                    [bus DistributeSignal: [reg4 ShowContents]];
                    break;
               default:
                    return -1;
            }
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"busy") ) {
            [bus DistributeSignal: [y ShowContents]];
            [upc Increment];
        }
        /* load registers */
        else if( !strcmp(ui.microop,"ro1bus") ) {
            int regnum = [ir ShowOp1];

            switch( regnum ) {
                case 1:
                    [reg1 StoreInput: [bus ShowContents]];
                    break;
                case 2:
                    [reg2 StoreInput: [bus ShowContents]];
                    break;
                case 3:
                    [reg3 StoreInput: [bus ShowContents]];
                    break;
                case 4:
                    [reg4 StoreInput: [bus ShowContents]];
                    break;
                default:
                    return -1;
            }
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"ro2bus") ) {
            int regnum = [ir ShowOp2];

            switch( regnum ) {
                case 1:
                    [reg1 StoreInput: [bus ShowContents]];
                    break;
                case 2:
                    [reg2 StoreInput: [bus ShowContents]];
                    break;
                case 3:
                    [reg3 StoreInput: [bus ShowContents]];
                    break;
                case 4:
                    [reg4 StoreInput: [bus ShowContents]];
                    break;
                default:
                    return -1;
            }
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"w1bus") ) {
            [w1 StoreInput: [bus ShowContents]];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"w2bus") ) {
            [w2 StoreInput: [bus ShowContents]];
            [upc Increment];
        }
        /* alu */
        else if( !strcmp(ui.microop,"alumul") ) {
            int t1, t2;

            t1 = [w1 ShowContents];
            t2 = [w2 ShowContents];
            [y StoreInput: [alu Mul: t1 And: t2]];
            [upc Increment];
        }
        /* memory */
        else if( !strcmp(ui.microop,"wrtmem") ) {
            [mem WriteData: [mdr ShowData] InDir: [mar ShowContents]];
            [upc Increment];
        }
        /* other */
        else if( !strcmp(ui.microop,"incpc") ) {
            [pc Increment];
            [upc Increment];
        }
        else if( !strcmp(ui.microop,"rstupc") ) {
            [upc StoreInput: 0];
        }
        else if( !strcmp(ui.microop,"jmpopc") ) {
            /* jump to the location where the microcode for the
             * current opcode is located. The current opcode can be
             * obtained from [ir ShowOpcode] */
            char opcode[4];

            strcpy( opcode, [ir ShowOpcode] );
            if( !strcmp( opcode, "lod") ) {
                [upc StoreInput: 10];
            }
            else if( !strcmp( opcode, "sto") ) {
                [upc StoreInput: 20];
            }
            else if( !strcmp( opcode, "mul") ) {
                [upc StoreInput: 30];
            }
            else if( !strcmp( opcode, "hlt") ) {
                halt = 1;
            }
            /* unrecognized opcode: abort */
            else {
                update_winstatus(winstatus, \
                        "FATAL: unrecognized opcode:", opcode);
                getch();
                endwin();
                exit(1);
            }
        }
        /* unrecognized microop: abort */
        else {
            update_winstatus(winstatus, \
                    "FATAL: unrecognized microop:", ui.microop);
            getch();
            endwin();
            exit(1);
        }
    }

    update_winstatus(winstatus,"Finished.","Press any key to exit.");
    getch();
    endwin();
    return 0;
}
