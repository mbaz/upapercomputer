void store_program(Mem * mem) {

    instruction inst;

    [mem InitMem: 20];

    /* load r1, 10 */
    strcpy( inst.opcode, "lod" );
    inst.op1 = 1;
    inst.op2 = 10;
    [mem WriteInst: inst InDir: 0];
    /* load r2, 11 */
    strcpy( inst.opcode, "lod" );
    inst.op1 = 2;
    inst.op2 = 11;
    [mem WriteInst: inst InDir: 1];
    /* mul r1, r2 */
    strcpy( inst.opcode, "mul" );
    inst.op1 = 1;
    inst.op2 = 2;
    [mem WriteInst: inst InDir: 2];
    /* sto 12, r1 */
    strcpy( inst.opcode, "sto" );
    inst.op1 = 12;
    inst.op2 = 1;
    [mem WriteInst: inst InDir: 3];
    /* halt */
    strcpy( inst.opcode, "hlt" );
    inst.op1 = 0;
    inst.op2 = 0;
    [mem WriteInst: inst InDir: 4];
    /* store a 5 in add 10 */
    [mem WriteData: 5 InDir: 10];
    /* store a 10 in add 11 */
    [mem WriteData: 10 InDir: 11];
}

void store_uprogram(Umem * umem) {

    microinst inst;

    [umem InitMem: 100];

    /* fetch */
    strcpy(inst.microop, "marpc");
    [umem Write: inst InDir: 0];
    strcpy(inst.microop, "mdrmei");
    [umem Write: inst InDir: 1];
    strcpy(inst.microop, "irmdr");
    [umem Write: inst InDir: 2];
    strcpy(inst.microop, "jmpopc");
    [umem Write: inst InDir: 3];

    /* ucode for lod */
    strcpy(inst.microop, "marop2");
    [umem Write: inst InDir: 10];
    strcpy(inst.microop, "mdrmed");
    [umem Write: inst InDir: 11];
    strcpy(inst.microop, "busmdr");
    [umem Write: inst InDir: 12];
    strcpy(inst.microop, "ro1bus");
    [umem Write: inst InDir: 13];
    strcpy(inst.microop, "incpc");
    [umem Write: inst InDir: 14];
    strcpy(inst.microop, "rstupc");
    [umem Write: inst InDir: 15];

    /* ucode for sto */
    strcpy(inst.microop, "marop1");
    [umem Write: inst InDir: 20];
    strcpy(inst.microop, "busro2");
    [umem Write: inst InDir: 21];
    strcpy(inst.microop, "mdrbus");
    [umem Write: inst InDir: 22];
    strcpy(inst.microop, "wrtmem");
    [umem Write: inst InDir: 23];
    strcpy(inst.microop, "incpc");
    [umem Write: inst InDir: 24];
    strcpy(inst.microop, "rstupc");
    [umem Write: inst InDir: 25];

    /* ucode for mul */
    strcpy(inst.microop, "busro1");
    [umem Write: inst InDir: 30];
    strcpy(inst.microop, "w1bus");
    [umem Write: inst InDir: 31];
    strcpy(inst.microop, "busro2");
    [umem Write: inst InDir: 32];
    strcpy(inst.microop, "w2bus");
    [umem Write: inst InDir: 33];
    strcpy(inst.microop, "alumul");
    [umem Write: inst InDir: 34];
    strcpy(inst.microop, "busy");
    [umem Write: inst InDir: 35];
    strcpy(inst.microop, "ro1bus");
    [umem Write: inst InDir: 36];
    strcpy(inst.microop, "incpc");
    [umem Write: inst InDir: 37];
    strcpy(inst.microop, "rstupc");
    [umem Write: inst InDir: 38];
}
