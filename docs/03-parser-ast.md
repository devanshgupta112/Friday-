# FridayLang Parser & AST Specifications

This document outlines the design, visitor hierarchy, lookahead, and error handling of the FridayLang recursive-descent parser (see [parser.h](file:///Users/Workspace/Development/Firday/parser.h) and [parser.cpp](file:///Users/Workspace/Development/Firday/parser.cpp)) and AST nodes (see [ast.h](file:///Users/Workspace/Development/Firday/ast.h)).

---

## Parser Design

FridayLang uses a **Recursive-Descent Parser** with single token lookahead (LL(1)).
*   **State**: Tracked using a 0-indexed integer `current` into the token stream vector (see [parser.h:15](file:///Users/Workspace/Development/Firday/parser.h#L15)).
*   **Lookahead Helper**: `peek()` looks at the token at the current offset without consuming it (see [parser.cpp:377-380](file:///Users/Workspace/Development/Firday/parser.cpp#L377-L380)).
*   **Token Matcher**: `match(type)` consumes the token if it matches, returning true. Otherwise, it returns false (see [parser.cpp:362-370](file:///Users/Workspace/Development/Firday/parser.cpp#L362-L370)).
*   **Safety Assertions**: `consume(type, message)` asserts that the next token is of the expected type; otherwise, it triggers a parsing error (see [parser.cpp:387-391](file:///Users/Workspace/Development/Firday/parser.cpp#L387-L391)).

---

## AST Node Schema

All AST nodes inherit from `ASTNode` and implement `accept(Visitor*)` to support runtime traversal (see [ast.h:8-12](file:///Users/Workspace/Development/Firday/ast.h#L8-L12)).

### 1. Expressions
*   **`NumberNode`**: Contains a literal double `value` (see [ast.h:18-23](file:///Users/Workspace/Development/Firday/ast.h#L18-L23)).
*   **`StringNode`**: Contains a literal string `value` (see [ast.h:25-30](file:///Users/Workspace/Development/Firday/ast.h#L25-L30)).
*   **`VariableNode`**: References a variable by identifier `name` (see [ast.h:32-37](file:///Users/Workspace/Development/Firday/ast.h#L32-L37)).
*   **`BinaryNode`**: Arithmetic/logical operations containing left/right expressions and string operator `op` (see [ast.h:39-47](file:///Users/Workspace/Development/Firday/ast.h#L39-L47)).
*   **`CallNode`**: Call expression holding the `callee` expression and a list of `arguments` expressions (see [ast.h:49-56](file:///Users/Workspace/Development/Firday/ast.h#L49-L56)).
*   **`GetNode`**: Object property read accessor containing the base `object` expression and property string `name` (see [ast.h:58-64](file:///Users/Workspace/Development/Firday/ast.h#L58-L64)).
*   **`SetNode`**: Object property write accessor containing `object`, property `name`, and assigned `value` expression (see [ast.h:66-73](file:///Users/Workspace/Development/Firday/ast.h#L66-L73)).
*   **`ThisNode`**: Binds the instance context `this` (see [ast.h:75-79](file:///Users/Workspace/Development/Firday/ast.h#L75-L79)).
*   **`SubscriptNode`**: Bracket accessor containing base `object` and `index` expression (see [ast.h:81-87](file:///Users/Workspace/Development/Firday/ast.h#L81-L87)).

### 2. Statements
*   **`PrintNode`**: Outputs evaluated `expr` to standard output (see [ast.h:89-94](file:///Users/Workspace/Development/Firday/ast.h#L89-L94)).
*   **`TakeNode`**: Deprecated assignment logic (see [ast.h:96-101](file:///Users/Workspace/Development/Firday/ast.h#L96-L101)).
*   **`AssignmentNode`**: Re-assigns/defines variable `varName` to evaluated `expr` (see [ast.h:103-108](file:///Users/Workspace/Development/Firday/ast.h#L103-L108)).
*   **`ExpressionStatementNode`**: Wraps standalone expression statement `expr` (see [ast.h:110-115](file:///Users/Workspace/Development/Firday/ast.h#L110-L115)).
*   **`BlockNode`**: Sequential list of statements within a lexical scope block (see [ast.h:117-122](file:///Users/Workspace/Development/Firday/ast.h#L117-L122)).
*   **`LoopNode`**: Represents legacy loops with bounds variables (see [ast.h:124-135](file:///Users/Workspace/Development/Firday/ast.h#L124-L135)).
*   **`IfNode`**: Conditional execution structure containing `condition` check, `thenBranch`, and optional `elseBranch` statements (see [ast.h:137-145](file:///Users/Workspace/Development/Firday/ast.h#L137-L145)).
*   **`FunctionNode`**: Function definition tracking identifier `name`, `params` lists, and `body` block statement (see [ast.h:147-154](file:///Users/Workspace/Development/Firday/ast.h#L147-L154)).
*   **`ReturnNode`**: Holds optional `expr` returned on function call stack unwinding (see [ast.h:156-161](file:///Users/Workspace/Development/Firday/ast.h#L156-L161)).
*   **`ClassNode`**: Class structural declaration tracking class identifier `name` and class methods `FunctionNode` lists (see [ast.h:163-172](file:///Users/Workspace/Development/Firday/ast.h#L163-L172)).
*   **`ContainerDeclarationNode`**: Unified declaration node for all STL-like containers (such as arrays, stacks, bitsets, etc.) tracking type string `containerType`, identifier `name`, instantiation `arguments`, and optional assignment `initExpr` (see [ast.h:174-186](file:///Users/Workspace/Development/Firday/ast.h#L174-L186)).
*   **`InputNode`**: Console input variable reading list (see [ast.h:188-193](file:///Users/Workspace/Development/Firday/ast.h#L188-L193)).
*   **`ForEachNode`**: Traversing loop tracking loop `iterator` variable, source `arrayExpr`, and `body` statements (see [ast.h:195-202](file:///Users/Workspace/Development/Firday/ast.h#L195-L202)).
*   **`ForNode`**: C-Style loop containing initial statement, conditional check expression, loop step statement, and `body` statement (see [ast.h:204-212](file:///Users/Workspace/Development/Firday/ast.h#L204-L212)).
*   **`SubscriptAssignmentNode`**: Bracket updates tracking target `object`, `index` key, and assigned `value` expression (see [ast.h:214-221](file:///Users/Workspace/Development/Firday/ast.h#L214-L221)).
*   **`IncDecNode`**: Direct increment/decrement statement tracking variable string `name` and boolean flag `isIncrement` (see [ast.h:223-228](file:///Users/Workspace/Development/Firday/ast.h#L223-L228)).
*   **`ProgramNode`**: Root statement list of the parsed file AST (see [ast.h:230-235](file:///Users/Workspace/Development/Firday/ast.h#L230-235)).

---

## Parse Errors & Limitations

### 1. Error Surface
When a token mismatch occurs, `Parser::error()` throws a `std::runtime_error` immediately aborting parser operations (see [parser.cpp:410-412](file:///Users/Workspace/Development/Firday/parser.cpp#L410-L412)).
```cpp
void Parser::error(const Token& token, const std::string& message) const {
    throw std::runtime_error("Parser Error at line " + std::to_string(token.line) + " near '" + token.text + "': " + message);
}
```
There is no compiler warning level; all parse errors are fatal.

### 2. Limitations
*   **No Error Recovery**: The parser fails fast on the first syntax error and aborts. It does not attempt to synchronize (e.g. searching for a semicolon) to report multiple errors.
*   **Strict LL(1) Parsing**: Precedence and associativity are rigidly modeled by calling nested precedence levels. The parser cannot dynamically handle arbitrary grammar modifications.
*   **Header Obligation**: Every script must start with `hey friday` (see [parser.cpp:10-11](file:///Users/Workspace/Development/Firday/parser.cpp#L10-L11)). This constraint requires a compiler bypass inside the REPL loop to automatically prepend the header to user entries (see [main.cpp:55-60](file:///Users/Workspace/Development/Firday/main.cpp#L55-L60)).
