# FridayLang Lexical Analysis & Tokenizer

This document specifies the lexical grammar rules, character token scans, keywords, and error reporting mechanics implemented in the FridayLang Lexer (see [lexer.h](file:///Users/Workspace/Development/Firday/lexer.h) and [lexer.cpp](file:///Users/Workspace/Development/Firday/lexer.cpp)).

---

## Token Types and Literal Patterns

The Lexer scans characters sequentially and maps them to distinct `TokenType` enumerations (see [lexer.h:15-51](file:///Users/Workspace/Development/Firday/lexer.h#L15-L51)).

| Token Type | Source Form / Pattern | Purpose |
| :--- | :--- | :--- |
| `HEY` | `"hey"` | Program Start Header |
| `FRIDAY` | `"friday"` | Program Start Header |
| `TAKE` | `"take"` | Variable Declaration |
| `PRINT` | `"print"` | Standard Output |
| `LOOP` | `"loop"` | Legacy Bounds Loops |
| `FROM` | `"from"` | Loop bound helper |
| `TO` | `"to"` | Loop bound helper |
| `IF` | `"if"` | Conditional checks |
| `ELSE` | `"else"` | Conditional alternative |
| `FUN` | `"fun"` | Functions definitions |
| `RETURN` | `"return"` | Function exit returns |
| `CLASS` | `"class"` | OOP Class declarations |
| `THIS` | `"this"` | OOP instance self-reference |
| `ARRAY` | `"array"` | Array container |
| `INPUT` | `"input"` | Standard Input |
| `FOREACH` | `"foreach"` | Container traversals |
| `IN` | `"in"` | Loop iterator helper |
| `FOR` | `"for"` | C-Style loops |
| `STACK` | `"stack"` | Stack container |
| `QUEUE` | `"queue"` | Queue container |
| `DEQUE` | `"deque"` | Deque container |
| `LIST` | `"list"` | List container |
| `SET` | `"set"` | Set container |
| `MULTISET` | `"multiset"` | Multiset container |
| `MAP` | `"map"` | Map container |
| `UNORDERED_MAP`| `"unorderedMap"` | Hash map container |
| `PRIORITY_QUEUE`| `"priorityQueue"` | Priority Queue container |
| `PAIR` | `"pair"` | Pair container |
| `TUPLE` | `"tuple"` | Tuple container |
| `BITSET` | `"bitset"` | Bitset container |
| `IDENTIFIER` | `[a-zA-Z_][a-zA-Z0-9_]*` | Variable, Function, Class, or Property name |
| `NUMBER` | `[0-9]+(\.[0-9]+)?` | Dynamic float/int representation |
| `STRING` | `\"[^\"]*\"` | String character sequences |
| `SEMICOLON` | `";"` | Statement terminator |
| `COMMA` | `","` | Argument/List separator |
| `DOT` | `"."` | Method/Field accessor |
| `LBRACE` | `"{"` | Block scopes start |
| `RBRACE` | `"}"` | Block scopes end |
| `LPAREN` | `"("` | Parameter list start |
| `RPAREN` | `")"` | Parameter list end |
| `LBRACKET` | `"["` | Subscript start |
| `RBRACKET` | `"]"` | Subscript end |
| `PLUS` | `"+"` | Arithmetic Addition / Array Merger |
| `MINUS` | `"-"` | Arithmetic Subtraction / Unary negative |
| `STAR` | `"*"` | Arithmetic Multiplication |
| `SLASH` | `"/"` | Arithmetic Division |
| `EQUALS` | `"="` | Direct Assignment |
| `EQ_EQ` | `"=="` | Equality comparison |
| `GT` | `">"` | Greater than |
| `LT` | `"<"` | Less than |
| `GE` | `">="` | Greater or equal |
| `LE` | `"<="` | Less or equal |
| `INC` | `"++"` | In-place increment |
| `DEC` | `"--"` | In-place decrement |

---

## Lexical Rules & Parsing Mechanics

### 1. Whitespace Handling
The lexer ignores standard spaces (`' '`), tabs (`'\t'`), and carriage returns (`'\r'`) (see [lexer.cpp:72-73](file:///Users/Workspace/Development/Firday/lexer.cpp#L72-L73)). Newlines (`'\n'`) increment the internal tracker variable `line` (see [lexer.cpp:74-76](file:///Users/Workspace/Development/Firday/lexer.cpp#L74-L76)).

### 2. Comments Syntax
Single-line comments start with `//` and continue to the end of the line (see [lexer.cpp:77-81](file:///Users/Workspace/Development/Firday/lexer.cpp#L77-L81)). They are completely skipped. Block comments are not supported.

### 3. Strings & Numeric Literals
*   **Strings**: Read inside double-quotes. Support embedding spaces and symbols. Strings containing newlines increment the line counter (see [lexer.cpp:163-165](file:///Users/Workspace/Development/Firday/lexer.cpp#L163-L165)).
*   **Numbers**: Matched sequentially. A double period (e.g. `12.34.56`) will be scanned up to the second dot, leaving the rest to be parsed as a separate identifier or float, which will cause a subsequent parsing error.

---

## Lexical Errors

The Lexer does not throw C++ exceptions during scanning. Instead, it marks malformed text streams with `TokenType::INVALID` and attaches the error message inside the token's `text` field (see [lexer.cpp:168-170](file:///Users/Workspace/Development/Firday/lexer.cpp#L168-L170)).

These invalid tokens are trapped at runtime when the program runner iterates through the token list (see [main.cpp:14-19](file:///Users/Workspace/Development/Firday/main.cpp#L14-L19)):
```cpp
if (token.type == TokenType::INVALID) {
    std::cerr << "Lexical Error at line " << token.line << ": invalid token '" << token.text << "'" << std::endl;
    return;
}
```
If an invalid token is detected, execution terminates immediately.
