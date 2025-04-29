# x86 Assembly Algorithms

![Build Status](https://img.shields.io/badge/build-passing-brightgreen) ![License](https://img.shields.io/badge/license-MIT-blue) ![Architecture](https://img.shields.io/badge/arch-x86_32--bit-orange)

This repository provides a 32-bit x86 assembly program implementing 10 algorithms in NASM syntax for Linux, using the int 0x80 syscall interface. The algorithms, implemented as subroutines, demonstrate core low-level programming techniques, including array manipulation, recursive mathematics, and string processing. The codebase is designed for educational and systems programming purposes, with results stored in memory for debugging or extension.

## Algorithms

1. **Bubble Sort**: In-place sorting of a 32-bit integer array in ascending order (O(n²)).
2. **Binary Search**: Iterative search for a target in a sorted array, returning index or -1 (O(log n)).
3. **Factorial**: Computes n! for a non-negative integer n using iterative multiplication.
4. **Fibonacci**: Calculates the nth Fibonacci number iteratively (n ≥ 0).
5. **GCD**: Computes the greatest common divisor of two integers using the Euclidean algorithm.
6. **String Length**: Counts characters in a null-terminated string.
7. **String Reverse**: Reverses a null-terminated string in-place.
8. **Power**: Computes base^exp for non-negative integers via iterative multiplication.
9. **Sum Array**: Sums elements of a 32-bit integer array.
10. **Prime Check**: Tests if a number is prime, returning 1 (prime) or 0 (not prime).

## System Requirements

* **OS**: Linux (32-bit or 64-bit with 32-bit compatibility)
* **Assembler**: NASM ≥ 2.15
* **Linker**: GNU ld (from binutils)
* **Dependencies**: 32-bit libraries (libc6-dev-i386, gcc-multilib on 64-bit systems)
* **Optional**: gdb for debugging

Install dependencies on Ubuntu:

```bash
sudo apt-get update sudo apt-get install nasm binutils gcc-multilib gdb
```

## Build Instructions

1. Clone the repository:


```bash
git clone https://github.com/your-username/assembly-algorithms.git
cd assembly-algorithms
```

2. Assemble the source:

```bash
nasm -f elf32 main.asm -o main.o
```

3. Link the object file:

```bash
ld -m elf_i386 main.o -o main
```

5. Run the executable:

```bash
./main
```

**Note**: Ensure main.asm uses Unix line endings (LF). On 64-bit systems, 32-bit compatibility libraries are required.

* **Sections**:

  * .data: Defines input data (arrays, scalars, strings) and result variables.
  * .text: Contains subroutine implementations and the main routine.

* **Execution Flow**:

  * start calls each subroutine sequentially.
  * Subroutines process hardcoded inputs and store results in .data (e.g., fact\_result).
  * Program exits via int 0x80 (syscall 1, exit).

## Technical Specifications

* **Architecture**: 32-bit x86

* **Calling Convention**: Custom; subroutines use stack frame (push ebp; mov ebp, esp) but take no parameters.

* **Registers**:

  * eax: Primary accumulator (results, arithmetic).
  * ebx, ecx, edx, esi, edi: General-purpose, loop counters, pointers.
  * Preserved across subroutines via stack.

* **System Calls**: Only exit (syscall 1, eax=1, ebx=0).

* **Instruction Set**: Standard x86 (arithmetic, logical, control flow, memory access).

* **Error Handling**: None; assumes valid inputs (e.g., sorted bin\_array, non-negative fact\_n).

### Example Data


```nasm
bubble_array dd 64, 34, 25, 12, 22, 11, 90 fact_n dd 5 str db "Hello", 0
```

## Debugging and Verification

* **Build Verification**:



```bash
nasm -f elf32 -g -F dwarf main.asm -o main.o && ld -m elf_i386 main.o -o main
```

* **Result Inspection**:

  * Check .data variables (e.g., print /d $fact\_result for factorial result).
  * Verify array modifications (e.g., bubble\_array after sorting).

* **Input Testing**:

  * Edit .data (e.g., fact\_n dd 3) and rebuild.
  * Ensure bin\_array remains sorted for binary search.

**Common Issues**:

* **Syntax Errors**: Check for invisible characters or incorrect line endings (use file main.asm to verify LF).
* **32-bit Compatibility**: Install gcc-multilib on 64-bit systems.
* **Debug Symbols**: Use -g -F dwarf with NASM for better gdb support.

## Limitations and Assumptions

* **Output**: No console output; results stored in memory.
* **Input**: Hardcoded in .data; requires recompilation for changes.
* **Platform**: 32-bit Linux only; 64-bit requires compatibility libraries.
* **Error Handling**: Absent; undefined behavior for invalid inputs (e.g., negative power\_exp, unsorted bin\_array).
* **String Reverse**: Modifies str in-place, affecting subsequent calls.
* **Performance**: Unoptimized (e.g., Bubble Sort is O(n²), no loop unrolling).

## Extending the Code

To enhance the program:

1. **Add Output**: Implement write syscall (syscall 4) to print results.

   `mov eax, 4 mov ebx, 1 mov ecx, fact_result mov edx, 4 int 0x80`

2. **Parameterized Subroutines**: Pass inputs via registers or stack.

3. **64-bit Port**: Rewrite for x86-64, using syscall instead of int 0x80.

4. **Error Handling**: Add input validation (e.g., check for negative fact\_n).

5. **Optimization**: Use advanced instructions (e.g., cmpxchg for sorting) or loop unrolling.
