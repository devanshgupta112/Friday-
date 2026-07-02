# FridayLang Known Limitations

This document lists the architectural constraints, limitations, and unimplemented elements in FridayLang.

---

## Codebase TODOs & FIXMEs

No occurrences of `TODO` or `FIXME` comments exist in any of the compiled C++ source files (`main.cpp`, `lexer.cpp`, `parser.cpp`, `interpreter.cpp`, `lexer.h`, `parser.h`, `interpreter.h`, `ast.h`).

---

## Architectural & Semantic Limitations

### 1. No Class Inheritance
FridayLang classes (see [ast.h:163-172](file:///Users/Workspace/Development/Firday/ast.h#L163-L172)) support method bindings and property state storage, but there is no keyword, token, or syntax for class inheritance or subclasses (e.g. `class Dog < Animal`). All classes are completely independent structures.

### 2. Flat Dynamic Type System (Numbers are Doubles)
All numeric values are stored and evaluated as double-precision floating-point values `double` (see [interpreter.h:18](file:///Users/Workspace/Development/Firday/interpreter.h#L18)). FridayLang does not support distinct integer types. Array subscripts implicitly cast the double values to integer array indices `static_cast<int>(index.num_val)` (see [interpreter.cpp:30](file:///Users/Workspace/Development/Firday/interpreter.cpp#L30)), which can lead to rounding issues if floating-point expressions are used as keys.

### 3. Implicit Local Variable Definition
If a variable is assigned without a `take` declaration (e.g., `x = 10;`), the environment crawls up parent pointers to see if `x` was defined. If it was not defined anywhere in the lexical environment chain, the environment silently defines `x` inside the local block environment rather than raising a compile-time or runtime error (see [interpreter.h:184](file:///Users/Workspace/Development/Firday/interpreter.h#L184)). This makes it easy to shadow variables or hide scoping bugs.

### 4. Single-Threaded Execution
The tree-walking execution visitor contains no threading abstractions, mutex locks, or synchronization primitives. Concurrent execution or async blocks are not supported.

### 5. Execution Stack Limits
Because functions use recursive C++ method calls on `Interpreter::visit(CallNode*)` (see [interpreter.cpp:571](file:///Users/Workspace/Development/Firday/interpreter.cpp#L571)), FridayLang's call stack is bounded by the host OS thread stack limit. Extremely deep recursion (e.g., calling `fibonacci(50000)`) will cause a native stack overflow crash.
