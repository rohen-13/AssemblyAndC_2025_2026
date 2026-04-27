# Project 2: 68000 to x86_64 Assembly Conversion

This project ports the provided 68000 assembly program to x86_64 NASM assembly.

The original program asks the user to enter two numbers, adds them using a register-based subroutine, repeats the process three times, and keeps a running sum. The x86_64 version keeps the same behaviour while using Linux/WSL tooling, NASM, GCC, and C library calls such as `printf` and `scanf`.

## Files

- `project2_main.asm`: main x86_64 program flow
- `project2_lib.asm`: helper routine for register-based addition
- `test_project2.c`: C test file for the assembly helper
- `test_macros.asm`: NASM macro-based assembly tests
- `Makefile`: build, run, and test commands
- `TEST_PLAN.md`: planned and completed test cases

## 68000 to x86_64 Mapping

The 68000 code uses data registers such as `D1`, `D2`, `D3`, and `D4`.

In this x86_64 version:

- `D1` and `D2` map to x86_64 argument registers `edi` and `esi` when calling `register_adder`.
- The result is returned in `eax`, which is the normal x86_64 return register.
- The running sum is kept in `ebx`.
- The loop counter is kept in `r12d` because it survives calls to `printf` and `scanf`.

The 68000 subroutine:

```asm
REGISTER_ADDER:
    ADD.L D2, D1
    RTS
```

is represented by:

```asm
register_adder:
    mov eax, edi
    add eax, esi
    ret
```

## Build And Run

Use WSL or a Linux terminal from this folder:

```bash
make
make run
```

The program asks for six numbers total, two numbers per loop iteration. It prints the sum for each pair and then prints the final running sum.

Example input:

```text
10
20
3
4
-5
9
```

Expected output includes:

```text
The sum is: 30
The sum is: 7
The sum is: 4
Final sum is: 41
```

## Tests

Run the C tests:

```bash
make test
```

Run the assembly macro tests:

```bash
make asm-test
```

Clean generated files:

```bash
make clean
```

## Input Validation And Security Notes

The original example comments mention missing input validation as a vulnerability. This version checks the return value from `scanf`. If the user enters invalid input, the program prints an error message and exits with a non-zero return value.

The assembly files also include:

```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```

This tells Linux that the program does not require an executable stack.

## Demo Video

The project brief asks for a short 10 to 20 second video of the software being executed in the command line after it has been ported.

This means you should record your terminal while running the completed x86_64 version. The video should show that the program builds/runs and produces the expected output.

A simple video flow:

```bash
cd /mnt/d/asm/AssemblyAndC_2025_2026/PRACTICAL_10
make clean
make run
```

Then enter:

```text
10
20
3
4
-5
9
```

The video should show:

- the program asking for numbers
- the three pair sums
- the final running sum

You can also record:

```bash
make test
make asm-test
```

if you want to show the test programs passing.
