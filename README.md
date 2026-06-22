
```markdown
# ARM64 Assembly Calculator 

A fully functional, command-line calculator written entirely in raw ARM64 Assembly for Apple Silicon (M1/M2/M3) Macs. It handles multi-digit ASCII-to-integer conversion, basic arithmetic operations (`+`, `-`, `*`, `/`), and integer-to-ASCII output using native macOS system calls.

## Prerequisites
To compile and run this project, you must be on an Apple Silicon Mac with Apple's Command Line Tools installed.

## How to Run It

**1. Compile the code:**
Open your terminal, navigate to the folder containing the project, and run this command to compile the assembly file into an executable named `calc`:

clang -arch arm64 -o calc AssemblyCalc.s

```

**2. Run the calculator:**
Execute the compiled file:

```bash
./calc
```

## Example Usage

```text
Enter First Number: 125
Enter operator (+, -, *, /): +
Enter Second Number: 15
140

```

> **Note:** Because this is an integer-based assembly calculator, division operations will round down to the nearest whole number (e.g., `5 / 2 = 2`).

