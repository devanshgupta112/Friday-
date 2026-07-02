# FridayLang Error Handling

This document specifies the error reporting pipeline, classes of errors (lexical, syntactic, semantic, runtime), exact message structures, and stack panic unwinding rules in FridayLang.

---

## Error Pipeline Architecture

```
[ Error Detected ] ──> [ throw exception / return invalid token ] 
                             │
                             ▼
                [ Unwinds C++ Stack Frames ] 
                             │
                             ▼
                [ Caught in main.cpp:24-26 ] ──> [ Prints to std::cerr ]
```

All errors in FridayLang immediately abort execution. There are no try-catch statement structures in the FridayLang syntax; all errors are fatal.

---

## Classes of Errors

### 1. Lexical Errors
Detected during character scanning by the Lexer.
*   **Unterminated String**: Triggered if a double quote string is opened but never closed before EOF (see [lexer.cpp:168-170](file:///Users/Workspace/Development/Firday/lexer.cpp#L168-L170)).
    *   *Message Format*: `Lexical Error at line <line>: invalid token 'Unterminated string literal'` (see [main.cpp:15-18](file:///Users/Workspace/Development/Firday/main.cpp#L15-L18)).
*   **Invalid Characters**: Triggered by unrecognized operator characters (such as `#` or `@`).
    *   *Message Format*: `Lexical Error at line <line>: invalid token '<character>'` (see [main.cpp:15-18](file:///Users/Workspace/Development/Firday/main.cpp#L15-L18)).

### 2. Parser (Syntax) Errors
Detected during token matching by the Parser.
*   **Missing Header**: Script does not begin with `hey friday` (see [parser.cpp:10-11](file:///Users/Workspace/Development/Firday/parser.cpp#L10-L11)).
*   **Syntax Mismatch**: Missing semicolons, brackets, or mismatched parenthesis (e.g. `expect ';' after expression`).
*   *Message Format*: (see [parser.cpp:410-412](file:///Users/Workspace/Development/Firday/parser.cpp#L410-L412))
    ```
    Parser Error at line <line> near '<token_text>': <error_message>
    ```

### 3. Runtime Errors
Detected during visitor evaluation in the Interpreter.
*   **Undefined Variable**: Triggered when accessing a variable not present in the current lexical environment or any parent enclosing scopes (see [interpreter.h:195](file:///Users/Workspace/Development/Firday/interpreter.h#L195)).
    *   *Message Format*: `Undefined variable '<name>'.`
*   **Undefined Class Property**: Triggered when calling/reading an undefined property or method on a class instance (see [interpreter.h:134](file:///Users/Workspace/Development/Firday/interpreter.h#L134)).
    *   *Message Format*: `Undefined property '<name>'.`
*   **Division by Zero**: Triggered by binary division `/` when the right-hand divisor is `0` (see [interpreter.cpp:494](file:///Users/Workspace/Development/Firday/interpreter.cpp#L494)).
    *   *Message Format*: `Division by zero.`
*   **Out of Bounds subscripting**: Triggered on array, string, deque, or tuple index accesses outside valid ranges (see [interpreter.cpp:32](file:///Users/Workspace/Development/Firday/interpreter.cpp#L32)).
    *   *Message Format*: `Array index out of bounds: <idx>` or similar.
*   **Map Key Not Found**: Triggered by Map `.get(key)` if the key string is missing (see [interpreter.cpp:1005](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1005)).
    *   *Message Format*: `Map key not found.`
*   **Call Arity Mismatch**: Triggered when invoking functions, classes, or native methods with a mismatched number of arguments (see [interpreter.cpp:588](file:///Users/Workspace/Development/Firday/interpreter.cpp#L588)).
    *   *Message Format*: `Expected <n> arguments but got <m>.`
*   **Type Mismatch**: Triggered by arithmetic operators on strings, or binary addition on incompatible containers (see [interpreter.cpp:478](file:///Users/Workspace/Development/Firday/interpreter.cpp#L478)).
    *   *Message Format*: `Operands for '-' must be numbers.`
*   *Global Runtime Print Format*: (caught in [main.cpp:24-26](file:///Users/Workspace/Development/Firday/main.cpp#L24-L26))
    ```
    Runtime Error: <message>
    ```
