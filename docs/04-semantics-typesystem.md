# FridayLang Scoping & Type System

This document explains the scoping rules, dynamic typing model, variable mutability, and name resolution mechanics implemented in FridayLang.

---

## Type System

FridayLang is **dynamically typed** with no static type-checking pass.
*   **Dynamic Typing**: Types are checked at runtime during node evaluation. If an invalid type operand is passed to an operation (such as adding a number to an instance), the interpreter immediately raises a runtime error (see [interpreter.cpp:468-470](file:///Users/Workspace/Development/Firday/interpreter.cpp#L468-L470)).
*   **Runtime Types**: The type system maps values to one of 6 runtime types defined in the `RuntimeValue::Type` enum (see [interpreter.h:16](file:///Users/Workspace/Development/Firday/interpreter.h#L16)):
    *   `NUMBER`: Double-precision floating-point numbers.
    *   `STRING`: Native C++ strings (`std::string`).
    *   `VOID`: Null/empty values.
    *   `CALLABLE`: Native callable functions, classes, and STL-like method binders.
    *   `INSTANCE`: Class object instances.
    *   `CONTAINER`: Dynamic collections inheriting from `FridayContainer`.

---

## Scoping Rules

FridayLang implements **lexical scoping** using an environment hierarchy linked by parent pointers (see [interpreter.h:169-201](file:///Users/Workspace/Development/Firday/interpreter.h#L169-L201)).

### 1. Lexical Scoping and Environments
Each block statement `BlockNode` (`{ ... }`), `LoopNode` (`loop`), `ForEachNode` (`foreach`), and function execution context creates a new child `Environment` holding a `std::shared_ptr<Environment> parent` pointer referencing its lexical enclosing environment (see [interpreter.cpp:513-515](file:///Users/Workspace/Development/Firday/interpreter.cpp#L513-L515)).

### 2. Variables Lookup and Resolution
When evaluating variable accesses (see [interpreter.cpp:446](file:///Users/Workspace/Development/Firday/interpreter.cpp#L446)), `Environment::get(name)` executes a recursive lookup (see [interpreter.h:187-196](file:///Users/Workspace/Development/Firday/interpreter.h#L187-L196)):
1.  Searches the local environment's `variables` map.
2.  If the variable is not found locally, it calls `parent->get(name)` to traverse the lexical parent chain.
3.  If the root environment is reached and the variable is still not resolved, the interpreter throws an `"Undefined variable"` runtime error.

### 3. Variable Assignment and Definition
*   **Explicit Definition (`take`)**: Variables are explicitly defined in the local scope using `take name value;`.
*   **Implicit Definition**: If a variable is assigned without a declaration (e.g. `x = 10;`), the environment crawls up the parent pointers to find where `x` is defined. If no environment in the chain has `x` defined, it implicitly defines `x` in the local scope of the current block context (see [interpreter.h:177-185](file:///Users/Workspace/Development/Firday/interpreter.h#L177-L185)).

---

## Variable Mutability

All variables in FridayLang are fully **mutable**; there is no keyword or symbol for constant values. Once defined in a scope, a variable can be re-assigned to a different type at any time.

```friday
take x 10;
x = "Hello";  # Completely valid; type changes dynamically from Number to String
```
