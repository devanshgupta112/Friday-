# FridayLang Grammar & Syntax Specification

This document provides the formal grammar of FridayLang in Extended Backus-Naur Form (EBNF), along with operator precedence and associativity tables derived from the parser structure.

---

## Operator Precedence & Associativity

Precedence is evaluated from highest (tighter binding) to lowest. Operators on the same precedence level share the same associativity.

| Precedence | Operator(s) | Description | Associativity | Parsing Method |
| :---: | :--- | :--- | :---: | :--- |
| **1 (Highest)** | `.` <br> `()` <br> `[]` | Dot property accessor <br> Function / method call <br> Container subscript | Left-to-Right | `parsePostfix()` (see [parser.cpp:197-211](file:///Users/Workspace/Development/Firday/parser.cpp#L197-L211)) |
| **2** | `-` | Unary negative negation | Right-to-Left | `parseUnary()` (see [parser.cpp:189-195](file:///Users/Workspace/Development/Firday/parser.cpp#L189-L195)) |
| **3** | `*`, `/` | Arithmetic multiplication, division | Left-to-Right | `parseMultiplicative()` (see [parser.cpp:180-188](file:///Users/Workspace/Development/Firday/parser.cpp#L180-L188)) |
| **4** | `+`, `-` | Arithmetic addition, subtraction | Left-to-Right | `parseAdditive()` (see [parser.cpp:171-179](file:///Users/Workspace/Development/Firday/parser.cpp#L171-L179)) |
| **5** | `>`, `<`, `>=`, `<=`, `==`, `!=` | Relational comparisons | Left-to-Right | `parseRelational()` (see [parser.cpp:161-170](file:///Users/Workspace/Development/Firday/parser.cpp#L161-L170)) |
| **6 (Lowest)** | `=` | Assignment | Right-to-Left | `parseExpression()` (see [parser.cpp:151-160](file:///Users/Workspace/Development/Firday/parser.cpp#L151-L160)) |

---

## Formal EBNF Grammar

```ebnf
(* Programs *)
program             = "hey" "friday" { statement } EOF ;

(* Statements *)
statement           = class_decl
                    | fun_decl
                    | print_stmt
                    | take_stmt
                    | container_decl
                    | input_stmt
                    | foreach_stmt
                    | for_stmt
                    | loop_stmt
                    | if_stmt
                    | return_stmt
                    | expr_stmt
                    | block ;

class_decl          = "class" identifier "{" { function_decl } "}" ;
fun_decl            = "fun" function_decl ;
function_decl       = identifier "(" [ param_list ] ")" block ;
param_list          = identifier { "," identifier } ;

print_stmt          = "print" expression ";" ;
take_stmt           = "take" identifier expression ";" ;
input_stmt          = "input" identifier { "," identifier } ";" ;

container_decl      = container_type identifier [ "(" [ arg_list ] ")" | "=" expression | expression ] ";" ;
container_type      = "array" | "stack" | "queue" | "deque" | "list" | "set" | "multiset" | "map" | "unorderedMap" | "priorityQueue" | "pair" | "tuple" | "bitset" ;
arg_list            = expression { "," expression } ;

foreach_stmt        = "foreach" identifier "in" expression block ;
for_stmt            = "for" ( take_stmt | expr_stmt | ";" ) expression ";" step_stmt block ;
step_stmt           = identifier ( "++" | "--" ) ;
loop_stmt           = "loop" identifier "from" expression "to" expression block ;

if_stmt             = "if" "(" expression ")" statement [ "else" statement ] ;
return_stmt         = "return" [ expression ] ";" ;
expr_stmt           = expression ";" ;
block               = "{" { statement } "}" ;

(* Expressions *)
expression          = assignment ;
assignment          = ( identifier | subscript_expr | get_expr ) "=" expression
                    | relational ;

subscript_expr      = postfix "[" expression "]" ;
get_expr            = postfix "." identifier ;

relational          = additive { ( ">" | "<" | ">=" | "<=" | "==" | "!=" ) additive } ;
additive            = multiplicative { ( "+" | "-" ) multiplicative } ;
multiplicative      = unary { ( "*" | "/" ) unary } ;
unary               = [ "-" ] postfix ;
postfix             = primary { "(" [ arg_list ] ")" | "." identifier | "[" expression "]" } ;

primary             = number
                    | string
                    | "this"
                    | identifier
                    | "(" expression ")" ;
```
