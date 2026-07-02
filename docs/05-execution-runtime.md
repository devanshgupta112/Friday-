# FridayLang Execution & Runtime Model

This document specifies the execution model, dynamic memory representation of variables, function call stack behaviors, and lexical closure mechanics of the FridayLang interpreter (see [interpreter.h](file:///Users/Workspace/Development/Firday/interpreter.h) and [interpreter.cpp](file:///Users/Workspace/Development/Firday/interpreter.cpp)).

---

## Execution Model: Tree-Walking Interpreter

FridayLang is executed by a **Tree-Walking Interpreter** using the **Visitor Design Pattern** (see [ast.h:237-277](file:///Users/Workspace/Development/Firday/ast.h#L237-L277)).
*   **Evaluation State**: When the interpreter evaluates an expression (see [interpreter.cpp:439-443](file:///Users/Workspace/Development/Firday/interpreter.cpp#L439-L443)), it calls the expression node's `accept(this)` method. The visitor stores the result of the evaluation in a member field `lastValue` (see [interpreter.h:239](file:///Users/Workspace/Development/Firday/interpreter.h#L239)).
*   **Sequential Statement Flow**: Statements are executed sequentially without yielding values. If a runtime exception or Return exception is thrown, it unwinds the native C++ call stack.

---

## Memory Representation (`RuntimeValue`)

Values are managed at runtime using the `RuntimeValue` structure (see [interpreter.h:15-48](file:///Users/Workspace/Development/Firday/interpreter.h#L15-L48)). It uses a dynamic struct representation:
*   `type`: Type enum tag (`NUMBER`, `STRING`, `VOID`, `CALLABLE`, `INSTANCE`, `CONTAINER`).
*   `num_val`: Stores literal doubles.
*   `str_val`: Stores literal strings.
*   `func_val`: Points to a heap-allocated `FridayCallable` object.
*   `inst_val`: Points to a heap-allocated `FridayInstance` object.
*   `container_ptr`: Points to a polymorphic `FridayContainer` object.

All pointers are wrapped inside C++ smart pointers (`std::shared_ptr`) for automatic reference-counted memory management.

---

## Call Stack & Function Execution

FridayLang maps its execution frames directly to C++ stack frames:
1.  **Function Call**: When a function call node `CallNode` is visited (see [interpreter.cpp:571-591](file:///Users/Workspace/Development/Firday/interpreter.cpp#L571-L591)), the arguments are evaluated, and the callable object's `call()` method is executed.
2.  **Environment Allocation**: Inside `FridayFunction::call()`, a new environment frame is allocated. The parameters are defined in this environment matching the evaluated argument values (see [interpreter.cpp:322-326](file:///Users/Workspace/Development/Firday/interpreter.cpp#L322-L326)).
3.  **Return Statement Unwinding**: If a `ReturnNode` is executed, the visitor throws a C++ `ReturnException` containing the return `RuntimeValue` (see [interpreter.cpp:635-641](file:///Users/Workspace/Development/Firday/interpreter.cpp#L635-L641)). This exception unwinds the recursive visitor C++ execution stack, returning control directly to the caller, where it is caught and handled (see [interpreter.cpp:328-333](file:///Users/Workspace/Development/Firday/interpreter.cpp#L328-L333)).

---

## Lexical Closures

FridayLang supports **lexical closures**. Functions capture their lexical scope environment at the place of definition:
*   **Closure Capturing**: The constructor `FridayFunction::FridayFunction` receives and stores a `std::shared_ptr<Environment> closure` representing the environment scope where the function was declared (see [interpreter.h:98-103](file:///Users/Workspace/Development/Firday/interpreter.h#L98-L103)).
*   **Closure Binding**: When a function is called, the execution environment frame is instantiated as a child of this captured `closure` rather than the caller's environment:
    ```cpp
    auto env = std::make_shared<Environment>(closure); // see interpreter.cpp:323
    ```
    This ensures variables accessed inside the function resolve against the lexical scope where the function was declared.
