# FridayLang Overview

FridayLang is a dynamically typed, interpreted programming language written in C++. It is designed to be highly readable, featuring unified Standard Template Library (STL)-like container APIs, built-in algorithms, recursive functions, and object-oriented class constructs.

---

## Design Goals & Philosophy

FridayLang's architecture focuses on two main design goals:
1.  **Unified API Consistency**: Dynamic containers (Arrays, Stacks, Queues, Sets, Maps, etc.) share uniform interface names (`.size()`, `.empty()`, `.clear()`, `.out()`, `.swap()`). This minimizes cognitive load and keeps syntax simple and learnable.
2.  **No Parentheses Overhead**: Clean, minimalist structure for standard constructs (for instance, `for` loops do not require wrapping parenthesis `for take i 0; i < n; i++ { ... }`).

---

## What FridayLang is NOT Designed For

*   **Static Type Performance**: FridayLang resolves variables, class methods, and container types dynamically at runtime. It is not suitable for performance-critical systems software.
*   **Compilation to Native Machine Code**: The engine runs as a tree-walking interpreter visiting AST nodes; it does not compile down to LLVM or machine code.
*   **Compile-time Type Safety**: Type checking and name resolutions are done purely at execution time; there is no static analyzer check.

---

## Overall Architecture

FridayLang operates in a sequential, single-threaded execution pipeline (see [main.cpp:10-23](file:///Users/Workspace/Development/Firday/main.cpp#L10-L23)):

```
[ Source File / REPL Line ] 
            │
            ▼
┌───────────────────────┐
│     Lexer (Scan)      │  ──> Scans source text into Token objects (see lexer.cpp:88-93)
└───────────────────────┘
            │
            ▼
┌───────────────────────┐
│     Parser (Parse)    │  ──> Matches tokens into Abstract Syntax Tree (AST) nodes
└───────────────────────┘
            │
            ▼
┌───────────────────────┐
│   AST Construction    │  ──> Generates structural nodes inheriting from StatementNode or ExpressionNode
└───────────────────────┘
            │
            ▼
┌───────────────────────┐
│ Interpreter (Execute) │  ──> Visits AST nodes sequentially, modifying the Env scope variables table
└───────────────────────┘
```

### Execution Steps
1.  **Lexical Analysis**: Reads raw text characters and returns a token list (see [main.cpp:10-11](file:///Users/Workspace/Development/Firday/main.cpp#L10-L11)). Invalid characters immediately raise a lexical error (see [main.cpp:15-18](file:///Users/Workspace/Development/Firday/main.cpp#L15-L18)).
2.  **Parsing Step**: Employs a recursive-descent parser to match grammar syntax (see [main.cpp:21-22](file:///Users/Workspace/Development/Firday/main.cpp#L21-L22)). If parsing fails, it throws a compile-time `std::runtime_error` immediately aborting execution.
3.  **AST Generation**: Structural representations of the program statements and expressions are mapped into pointer hierarchies in memory (see [parser.cpp:21-23](file:///Users/Workspace/Development/Firday/parser.cpp#L21-L23)).
4.  **Tree-Walking Evaluation**: The `Interpreter` visits each AST node directly (see [main.cpp:23](file:///Users/Workspace/Development/Firday/main.cpp#L23)). It maintains environment tables linking variables to dynamic wrapper values (see [interpreter.h:15-48](file:///Users/Workspace/Development/Firday/interpreter.h#L15-L48)).
