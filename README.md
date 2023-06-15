### A microcoded paper computer emulator

The ["paper computer"](https://en.wikipedia.org/wiki/WDR_paper_computer) is an excellent
tool to learn how computers work and, more generally, what it means to think
computationally. The paper computer is small and easy to undersand; the challenge is how to
make it do something interesting (such as determining whether a number is odd or even). This
requires thinking about how the interesting task can be broken down into steps so simple, that
the paper computer can carry them out.

This project is a *microcoded* paper computer emulator, that builds on the concept of the paper
computer and adds microcode-defined instructions. It should be useful for computer architecture students who want
to understand how microcode works. It is easy to change the computer's microcode to create new
instructions, and it is relatively easy to extend the CPU's architecture itself to make it
more capable.

#### Installation

You will need an Objective-C compiler, the GNUStep framework, and the ncurses library (I hope
to re-write the emulator in Python or Julia one day; let me know if you beat me to it).
On Ubuntu, just run:

    # sudo apt-get install base-devel ncurses-dev
    # sudo apt-get install gnustep gnustep-devel

Then, run `make` on the project's source directory:

    $ cd src
    $ make

and run the emulator:

    $ ./cpu

On Arch, you will need to install the `gnustep-base` and `gnustep-make` packages.

#### How to use the emulator?

The following diagram shows the computer's architecture:

![architecture](/architecture.png)

This screenshot shows the emulator in action:

![screenshot](/screenshot.png)

Pressing a key executes the current microinstruction (the one pointed at by the micro program counter);
you can see the full state of the CPU and memory, and how the execution of each micro opcode updates it.
Press `q` at any time to exit.

##### Registers and ALU

The registers are named using normal textbook conventions (M. Mano, Hennessy/Patterson, etc):

| Register | Description |
|----------|-------------|
| `MDR`    | Memory data register |
| `MAR`    | Memory address register |
| `IR` | Instruction register |
| `R1` to `R4` | General-purpose registers |
| `PC` | Program counter |
| `uPC` | Micro program counter |
| `W1` and  `W2` | ALU operands |
| `Y` | ALU output |

It is assumed that the `PC` can increment itself (that is, there is no need to use the ALU to increment it).
The ALU loads `Y` with the result of its calculation upon activation of one of its control signals (like `alumul`,
see the microcode section below).

##### RAM and opcodes

The content of the RAM at startup is defined in `src/code.dat`. To simplify things, memory locations
containing code and those containing data are handled separately. Each line of `code.dat` corresponds
to one memory location. Its format is:

    i address opcode op1 op2

to store one instruction, or

    d address content

to store one word of data (an integer). All instructions have two operands, `op1` and `op2`.

The opcodes are defined by the microcode (see below), nothing is hard-coded. Opcodes included
"out of the box" are:

| Opcode | Description |
|-------:|-------------|
| `lod rX addr` | Load register `rX` with memory contents at `addr` |
| `sto addr rX` | Store value at register `rX` at memory address `addr` |
| `mul rX rY` | Multiply `rX` and `rY`, store result in `rX` |
| `hlt` | Halt |

To add more opcodes, write their microcode and update the look up table in `cpu.m`, line 278.

##### Microcode

The microcode memory generates control signals that orchestrate the movement of data across the CPU and memory
(using the data bus). The uPC (micro program counter) register generates the addresses
for the microcode memory.

The microcode is stored in the file `src/microcode.dat`, which is read by the emulator
when it is launched. Each line of this file has the format:

    address microinstruction

where `address` is an integer (starting at 0). Most micro instructions have the format
`destination source`, which means that whatever is stored in `source` will be transfered
to `destination`. The available microinstructions are:

| u opcode | description |
|-------:|-------------|
| `jmpopc` | Jump to the micro memory address of the opcode currently in the instruction register |
| `incpc`  | Increment the program counter |
| `rstupc` | Reset the micro PC to `0` |
| `wrtmem` | Write contents of the memory data register (`MDR`) to RAM |
| `marpc` | Load the `MAR` with the PC |
| `marop1`, `marop2` | Load the `MAR` with one of the current instruction's operands |
| `irmdr` | Load the `IR` with the `MDR` |
| `mdrmei` | Read an instruction from memory and store it in the `MDR` |
| `mdrmed` | Read data from memory and store it in `MDR` |
| `mdrbus` | Load the `MDR` with the contents of the data bus |
| `roXbus` | Load register `X` with bus |
| `w1bus`, `w2bus` | Load ALU register `w1` or `w2` with bus |
| `busmdr` | Put the `MDR` in the bus |
| `busroX` | Put the contents of register `X` on the bus |
| `busy` | Put the contents of the ALU register `Y` on the bus |
| `alumul` | Load `Y` with `W1 * W2` |

The microops are implemented in `cpu.m`, starting on line 84.

### Modify and extend the architecture

The CPU presented here is quite limited; the intent is for students to decide what new features to
add, and then implement them. Here are a couple of ideas to get you started:
* Add microcode and control signals to the ALU to add, subtract and divide.
* Write a program to calculate the first ten prime numbers.
* Implement jump instructions.
* Add ALU flags.
* Add support for floating-point numbers.
* Modify the memory display to cover more memory locations.

Best of luck in your explorations!
