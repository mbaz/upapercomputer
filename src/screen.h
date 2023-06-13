/* function prototypes for screen.m */

WINDOW * create_window(int, int, int, int);
void update_winpc(WINDOW *, RegWithInc *, Mem *);
void update_winupc(WINDOW *, RegWithInc *, Umem *);
void update_windata(WINDOW *, Mem *);
void update_winmar(WINDOW *, Register *, RegInst *, RegInst *);
void update_winreg(WINDOW *, Register *, Register *, Register *, Register* );
void update_winalu(WINDOW *, Register *, Register *, Register *);
void update_winbus(WINDOW *, Bus *);
void update_winstatus(WINDOW *, char *, char *);
