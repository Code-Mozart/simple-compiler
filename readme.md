# Simplec
_A simple compiler for a simple language_

## What is Simplec?

Simplec is a simple programming language environment to experiment with compilers and some programming language ideas. It is written in Ruby. It should include
1. A compiler to generate an abstract syntax tree (AST).
2. One or multiple compiler backends to generate code for different platforms. These might include a C-Transpiler, an x86 or x64 Assembler-Compiler or an intermediate code generator.
3. A virtual machine to execute the intermediate code.

## The Simplec Language (SCL)

Files in the Simplec language have the extension `.sc`. Its planned features are:

```
// Line comment
/{ Block
comment }/

// Function definition
symbol main : {
    ...
}

// Variable definition
my_variable : 42

// note that
// 1. type inference is used
// 2. there is no difference between variables and functions
// 3. assignments use the operator ':'

// Function call
my_function(42)

// Function with return values
int_divide : (float dividend, float divisor) -> int quotient, int remainder {
    return dividend.int / divisor.int, dividend.int % divisor.int
}
quotient, remainder = int_divide(10.0, 3.0)

// alternatively return local variables
int_divide : (float dividend, float divisor) -> int quotient, int remainder {
    quotient : dividend.int / divisor.int
    remainder : dividend.int % divisor.int
}

// Single-expression functions
single_expression_function : { 42 }
with_argument : (int a) -> int { a + 42 }

// Return value inference
some_function : (int a) -> { a + 42 }

// If statement
if (quotient - remainder > 0 and quotient.positive?) {
    ...
} else {
    ...
}

// Explicit type definition
int32 my_int : 42

// Print statement
say("Hello world")

// Built-in types
bool my_boolean

int8 my_byte
int16 my_short
int32 my_int
int64 my_long_int

uint8 my_unsigned_byte
uint16 my_unsigned_short
uint32 my_unsigned_int
uint64 my_unsigned_long_int

float32 my_single_precision_float
float64 my_double_precision_float

char my_char // utf-8
string my_string

array my_array
list my_list
map my_map

vector2 my_2d_vector
vector3 my_3d_vector
vector4 my_4d_vector
matrix2 my_2x2_matrix
matrix3 my_3x3_matrix
matrix4 my_4x4_matrix
```

To be a bit more precise about the language:
It is currently planned to be an **imperative/procedural/functional** programming language that is **statically typed** and **compiled**. It currently mostly targets low level programming.

## Ideas

- The programming language could be some kind of a modern language for embedded programming without having to deal with our good old C.
- On the other hand it could be an interpreted high level language similar to Ruby.
- Out-of-the-box support multithreading and concurrency.
- Lots of build-in functions and data structures as well as a comprehensive standard library, especially for math and graphics.
- With this it might be a nice language for game development as well? Idk.

## About the project and its current state

This project is currently in a very early stage. It is not usable yet. It will be developed mostly for fun and to learn more about compilers and programming languages and may be canceled at any time.

## License

This project is not licensed meaning that no one may use this code. It is only published for anyone interested. If you have any questions or suggestions about the project or its licensing, feel free to contact me.

## Contributing

If you want to contribute to this project, feel free to open an issue or a pull request.
