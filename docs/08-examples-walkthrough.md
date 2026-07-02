# FridayLang Examples Walkthrough

This document traces two core programs through lexical analysis, parsing, AST generation, and environment execution.

---

## Example 1: Function Recursion ([recursion.fry](file:///Users/Workspace/Development/Firday/example/recursion.fry))

### **Source Code**
```friday
hey friday

fun fibonacci(val) {
    if (val <= 1) {
        return val;
    }
    return fibonacci(val - 1) + fibonacci(val - 2);
}

print fibonacci(8);
```

### **1. Token Stream**
Scanning the text yields this token list (line numbers in parentheses):
```
[HEY, "hey" (1)], [FRIDAY, "friday" (1)],
[FUN, "fun" (3)], [IDENTIFIER, "fibonacci" (3)], [LPAREN, "(" (3)], [IDENTIFIER, "val" (3)], [RPAREN, ")" (3)], [LBRACE, "{" (3)],
[IF, "if" (4)], [LPAREN, "(" (4)], [IDENTIFIER, "val" (4)], [LE, "<=" (4)], [NUMBER, "1" (4)], [RPAREN, ")" (4)], [LBRACE, "{" (4)],
[RETURN, "return" (5)], [IDENTIFIER, "val" (5)], [SEMICOLON, ";" (5)],
[RBRACE, "}" (6)],
[RETURN, "return" (7)], [IDENTIFIER, "fibonacci" (7)], [LPAREN, "(" (7)], [IDENTIFIER, "val" (7)], [MINUS, "-" (7)], [NUMBER, "1" (7)], [RPAREN, ")" (7)], [PLUS, "+" (7)], [IDENTIFIER, "fibonacci" (7)], [LPAREN, "(" (7)], [IDENTIFIER, "val" (7)], [MINUS, "-" (7)], [NUMBER, "2" (7)], [RPAREN, ")" (7)], [SEMICOLON, ";" (7)],
[RBRACE, "}" (8)],
[PRINT, "print" (10)], [IDENTIFIER, "fibonacci" (10)], [LPAREN, "(" (10)], [NUMBER, "8" (10)], [RPAREN, ")" (10)], [SEMICOLON, ";" (10)]
```

### **2. AST Shape**
The parser builds the following hierarchical AST structure:
*   `ProgramNode`
    *   `FunctionNode` (name: `"fibonacci"`, params: `["val"]`)
        *   `BlockNode` (body)
            *   `IfNode`
                *   Condition: `BinaryNode` (op: `"<="`, left: `VariableNode("val")`, right: `NumberNode(1.0)`)
                *   ThenBranch: `BlockNode`
                    *   `ReturnNode` (expr: `VariableNode("val")`)
            *   `ReturnNode`
                *   Expression: `BinaryNode` (op: `"+"`)
                    *   Left: `CallNode` (callee: `VariableNode("fibonacci")`, args: `[BinaryNode("-", VariableNode("val"), NumberNode(1.0))]`)
                    *   Right: `CallNode` (callee: `VariableNode("fibonacci")`, args: `[BinaryNode("-", VariableNode("val"), NumberNode(2.0))]`)
    *   `PrintNode`
        *   Expression: `CallNode` (callee: `VariableNode("fibonacci")`, args: `[NumberNode(8.0)]`)

### **3. Execution Trace**
1.  **Declaration**: The interpreter registers the `"fibonacci"` function in the global environment mapping to a `FridayFunction` wrapper storing the declaration node and the parent scope (global environment) (see [interpreter.cpp:629-633](file:///Users/Workspace/Development/Firday/interpreter.cpp#L629-L633)).
2.  **Invocation**: Visits `PrintNode`, evaluates the `CallNode` for `fibonacci(8)` (see [interpreter.cpp:571-591](file:///Users/Workspace/Development/Firday/interpreter.cpp#L571-L591)):
    *   Pushes dynamic argument `8.0` onto the parameters.
    *   Instantiates a child environment linked to the global environment closure (see [interpreter.cpp:322-326](file:///Users/Workspace/Development/Firday/interpreter.cpp#L322-L326)).
    *   Binds `"val"` to `8.0` in the child scope.
3.  **Condition Evaluation**: Visits `IfNode` (see [interpreter.cpp:557-563](file:///Users/Workspace/Development/Firday/interpreter.cpp#L557-L563)), evaluates `val <= 1` ($8.0 \le 1.0$), which returns `0.0` (false). The block falls through to the recursive step.
4.  **Recursive Calls**: Evaluates `fibonacci(7) + fibonacci(6)`. The call stack descends recursively down to base cases `fibonacci(1)` and `fibonacci(0)`.
5.  **Unwinding**: The base cases trigger the `ReturnNode` inside the condition, throwing `ReturnException` containing `1.0` and `0.0` (see [interpreter.cpp:635-641](file:///Users/Workspace/Development/Firday/interpreter.cpp#L635-L641)).
6.  **Results**: The values are accumulated on the call stack, computing the final value `21.0` which is printed to the console.

---

## Example 2: Class Initialization & Damage State Mutation ([oop_warrior.fry](file:///Users/Workspace/Development/Firday/example/oop_warrior.fry))

### **Source Code**
```friday
hey friday

class Warrior {
    init(name, hp, ap) {
        this.name = name;
        this.hp = hp;
        this.ap = ap;
    }

    damage(amount) {
        this.hp = this.hp - amount;
    }
}

take conan Warrior("Conan", 100, 15);
conan.damage(25);
print conan.hp;
```

### **1. Token Stream**
```
[CLASS, "class" (3)], [IDENTIFIER, "Warrior" (3)], [LBRACE, "{" (3)],
[IDENTIFIER, "init" (4)], [LPAREN, "(" (4)], [IDENTIFIER, "name" (4)], [COMMA, "," (4)], [IDENTIFIER, "hp" (4)], [COMMA, "," (4)], [IDENTIFIER, "ap" (4)], [RPAREN, ")" (4)], [LBRACE, "{" (4)],
[THIS, "this" (5)], [DOT, "." (5)], [IDENTIFIER, "name" (5)], [EQUALS, "=" (5)], [IDENTIFIER, "name" (5)], [SEMICOLON, ";" (5)],
...
[RBRACE, "}" (13)],
[TAKE, "take" (15)], [IDENTIFIER, "conan" (15)], [IDENTIFIER, "Warrior" (15)], [LPAREN, "(" (15)], [STRING, "Conan" (15)], [COMMA, "," (15)], [NUMBER, "100" (15)], [COMMA, "," (15)], [NUMBER, "15" (15)], [RPAREN, ")" (15)], [SEMICOLON, ";" (15)],
[IDENTIFIER, "conan" (16)], [DOT, "." (16)], [IDENTIFIER, "damage" (16)], [LPAREN, "(" (16)], [NUMBER, "25" (16)], [RPAREN, ")" (16)], [SEMICOLON, ";" (16)],
[PRINT, "print" (17)], [IDENTIFIER, "conan" (17)], [DOT, "." (17)], [IDENTIFIER, "hp" (17)], [SEMICOLON, ";" (17)]
```

### **2. AST Shape**
*   `ProgramNode`
    *   `ClassNode` (name: `"Warrior"`)
        *   Method 1: `FunctionNode` (name: `"init"`, params: `["name", "hp", "ap"]`)
        *   Method 2: `FunctionNode` (name: `"damage"`, params: `["amount"]`)
    *   `AssignmentNode` (varName: `"conan"`, expr: `CallNode(Warrior, ["Conan", 100, 15])`)
    *   `ExpressionStatementNode`
        *   Expr: `CallNode` (callee: `GetNode(VariableNode("conan"), "damage")`, args: `[NumberNode(25.0)]`)
    *   `PrintNode`
        *   Expr: `GetNode` (VariableNode("conan"), "hp")

### **3. Execution Trace**
1.  **Instantiation**: The `CallNode` for `Warrior(...)` evaluates the `Warrior` class (see [interpreter.cpp:337-344](file:///Users/Workspace/Development/Firday/interpreter.cpp#L337-L344)).
    *   Creates a `FridayInstance` linked to the class.
    *   Extracts the `"init"` method, binds `"this"` to the instance (see [interpreter.cpp:315-319](file:///Users/Workspace/Development/Firday/interpreter.cpp#L315-L319)), and calls it with arguments `["Conan", 100.0, 15.0]`.
    *   The initializer binds fields (`this.name`, `this.hp`, `this.ap`) to the instance's state map (see [interpreter.cpp:157](file:///Users/Workspace/Development/Firday/interpreter.cpp#L157)).
    *   `conan` is defined globally as this instance.
2.  **Method Dispatch**: `conan.damage(25)` evaluates `conan.damage`. Since `"damage"` is a class method, the interpreter creates a new `FridayFunction` closure binding `"this"` to the instance (see [interpreter.cpp:144-152](file:///Users/Workspace/Development/Firday/interpreter.cpp#L144-L152)).
3.  **State Mutation**: The method runs. `this.hp = this.hp - amount` evaluates to $100.0 - 25.0 = 75.0$. It updates the `hp` field in the instance field map (see [interpreter.cpp:610](file:///Users/Workspace/Development/Firday/interpreter.cpp#L610)).
4.  **Property Access**: `conan.hp` evaluates to `75.0` (see [interpreter.cpp:602](file:///Users/Workspace/Development/Firday/interpreter.cpp#L602)) and prints to standard output.
