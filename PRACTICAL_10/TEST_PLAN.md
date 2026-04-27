# Test Plan

## Objective

Verify that the x86_64 NASM version matches the behaviour of the provided 68000 assembly program.

The required behaviour is:

- ask the user for two numbers
- add the two numbers
- print the pair sum
- repeat the process three times
- keep a running sum
- print the final running sum

## Manual Demo Test

Command:

```bash
make run
```

Input:

```text
10
20
3
4
-5
9
```

Expected output:

```text
The sum is: 30
The sum is: 7
The sum is: 4
Final sum is: 41
```

Purpose:

This confirms that the program loops three times, adds each pair correctly, and keeps the running sum.

## Invalid Input Test

Command:

```bash
make run
```

Input:

```text
abc
```

Expected output:

```text
Invalid input. Please enter integers only.
```

Purpose:

This confirms that the program does not blindly trust user input.

## C Test Harness

Command:

```bash
make test
```

Expected output:

```text
All C tests passed.
```

Purpose:

This confirms that C code can call the assembly `register_adder` function and receive the correct result.

Tested cases:

- `7 + 5 = 12`
- `-3 + 10 = 7`
- `-5 + 9 = 4`
- `0 + 0 = 0`

## Assembly Macro Tests

Command:

```bash
make asm-test
```

Expected output:

```text
All assembly macro tests passed.
```

Purpose:

This confirms that NASM macro-based tests can check the assembly function directly, following the idea from the unit-testing assembly article supplied in the project resources.

## Final Verification

Before submitting:

```bash
make clean
make
make test
make asm-test
make clean
```

The project should build without errors, both test targets should pass, and generated files should be removed before committing.
