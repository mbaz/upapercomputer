/* Miguel Bazdresch
 * header file for cpu */

/* instruction types */
typedef struct {
    char opcode[4];
    int op1, op2;
    int data;
} instruction;

typedef struct {
    char microop[7];
} microinst;

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ncurses.h>
#include "alu.h"
#include "bus.h"
#include "mem.h"
#include "umem.h"
#include "parser.h"
#include "register.h"
#include "screen.h"
