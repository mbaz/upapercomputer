/* this file handles reporting and printing to the screen.
 * It uses the ncurses library. create_window is used
 * to safely create new windows, and the various 
 * update_win* functions are used to update each window */

#include "cpu.h"

WINDOW * create_window(int h, int w, int sy, int sx) {

    WINDOW * tmp;

    tmp = newwin(h,w,sy,sx);
    if( tmp == NULL ) {
        endwin();
        printf("FATAL: error allocating window\n");
        exit(1);
    } else {
        return tmp;
    }
}

void update_winpc(WINDOW * w, RegWithInc * pc, Mem * m) {

    int p = [pc ShowContents];
    instruction i;

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,6,"Code Memory");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,2,"PC = %d",p);

    /* create a window into code memory by showing one previous,
     * current and the next memory locations */
    if( (p-1) >= 0 ) {
        i = [m ReadInst: p-1];
        mvwprintw(w,5,1,"%d\topcode : %s",p-1,i.opcode);
        mvwprintw(w,6,1,"\top1    : %d",i.op1);
        mvwprintw(w,7,1,"\top2    : %d",i.op2);
        mvwprintw(w,8,1,"\tdata   : %d",[m ReadData: p-1]);
    }
    i = [m ReadInst: p];
    wattron( w, A_BOLD ); /* current instruction in bold */
    mvwprintw(w,10,1,"%d -->\topcode : %s",p,i.opcode);
    mvwprintw(w,11,1,"\top1    : %d",i.op1);
    mvwprintw(w,12,1,"\top2    : %d",i.op2);
    mvwprintw(w,13,1,"\tdata   : %d",[m ReadData: p]);
    wattroff( w, A_BOLD);
    i = [m ReadInst: p+1];
    mvwprintw(w,15,1,"%d\topcode : %s",p+1,i.opcode);
    mvwprintw(w,16,1,"\top1    : %d",i.op1);
    mvwprintw(w,17,1,"\top2    : %d",i.op2);
    mvwprintw(w,18,1,"\tdata   : %d",[m ReadData: p*1]);

    box(w,0,0);
    wrefresh(w);
}

void update_winupc(WINDOW * w, RegWithInc * upc, Umem * umem) {

    int u = [upc ShowContents];
    microinst inst;

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,6,"Micro Memory");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,2,"upc = %d",u);

    /* create a window into the umem by showing previous,
     * current and next microinsts. */
    if( (u-2) >= 0 ) {
        inst = [umem Read: u-2];
        mvwprintw(w,5,1,"%d\t%s",u-2,inst.microop);
    }
    if( (u-1) >= 0 ) {
        inst = [umem Read: u-1];
        mvwprintw(w,6,1,"%d\t%s",u-1,inst.microop);
    }
    inst = [umem Read: u];
    wattron( w, A_BOLD ); /* current microinst in bold */
    mvwprintw(w,7,1,"%d -->\t%s",u,inst.microop);
    wattroff( w, A_BOLD);
    inst = [umem Read: u+1];
    mvwprintw(w,8,1,"%d\t%s",u+1,inst.microop);
    inst = [umem Read: u+2];
    mvwprintw(w,9,1,"%d\t%s",u+2,inst.microop);

    box(w,0,0);
    wrefresh(w);
}

void update_windata(WINDOW * w, Mem * mem) {

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,6,"Data Memory");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,1,"10 : %d",[mem ReadData: 10]);
    mvwprintw(w,4,1,"11 : %d",[mem ReadData: 11]);
    mvwprintw(w,5,1,"12 : %d",[mem ReadData: 12]);

    box(w,0,0);
    wrefresh(w);
}

void update_winmar(WINDOW * w, Register * mar, RegInst * mdr, RegInst * ir) {

    instruction i = [mdr ShowInst];
    int d = [mdr ShowData];

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,6,"Special Regs");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,1,"mar = %d", [mar ShowContents]);
    mvwprintw(w,5,1,"mdr\topcode = %s",i.opcode);
    mvwprintw(w,6,1,"\top1    = %d",i.op1);
    mvwprintw(w,7,1,"\top2    = %d",i.op2);
    mvwprintw(w,8,1,"\tdata   = %d",d);
    i = [ir ShowInst];
    mvwprintw(w,10,1,"ir\topcode = %s",i.opcode);
    mvwprintw(w,11,1,"\top1    = %d",i.op1);
    mvwprintw(w,12,1,"\top2    = %d",i.op2);

    box(w,0,0);
    wrefresh(w);
}


void update_winreg(WINDOW * w, Register * r1, Register * r2, Register * r3, Register * r4) {

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,8,"Registers");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,1,"r1 = %d",[r1 ShowContents]);
    mvwprintw(w,4,1,"r2 = %d",[r2 ShowContents]);
    mvwprintw(w,5,1,"r3 = %d",[r3 ShowContents]);
    mvwprintw(w,6,1,"r4 = %d",[r4 ShowContents]);

    box(w,0,0);
    wrefresh(w);
}

void update_winalu(WINDOW * w, Register * w1, Register * w2, Register * y) {

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,5,"ALU registers");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,1,"w1 = %d",[w1 ShowContents]);
    mvwprintw(w,4,1,"w2 = %d",[w2 ShowContents]);
    mvwprintw(w,5,1,"y  = %d",[y ShowContents]);

    box(w,0,0);
    wrefresh(w);
}

void update_winbus( WINDOW * w, Bus * bus) {

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,10,"Bus");
    wattroff( w, A_BOLD);

    mvwprintw(w,3,1,"bus = %d",[bus ShowContents]);

    box(w,0,0);
    wrefresh(w);
}

void update_winstatus( WINDOW * w, char * s1, char * s2) {

    werase(w);

    wattron( w, A_BOLD );
    mvwprintw(w,1,1,"Status: ");
    wattroff( w, A_BOLD);

    wprintw(w,"%s ",s1);
    wprintw(w,"%s",s2);

    box(w,0,0);
    wrefresh(w);
}
