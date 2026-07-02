# FridayLang Glossary

*   **`hey friday`**: The required entry statement header at the top of every valid script file.
*   **`take`**: Statement keyword used to declare a variable in the local scope.
*   **`print`**: Statement keyword used to evaluate an expression and output its string representation.
*   **`loop`**: Legacy loop statement that executes a block of code within specified bounds.
*   **`foreach`**: Statement used to iterate over items in an iterable dynamic container.
*   **`for`**: Parents-free statement structure for standard three-step loop iterations.
*   **`fun`**: Declaration keyword used to define a callable function.
*   **`class`**: Declaration keyword used to define a template containing methods and constructor logic.
*   **`init`**: Special keyword method name indicating class constructors.
*   **`this`**: Self-referencing keyword resolving to the current class instance execution frame.
*   **`algo`**: Global namespace container providing standard numeric and vector algorithms.
*   **`RuntimeValue`**: Internal C++ struct wrapping dynamic FridayLang variables.
*   **`FridayContainer`**: Polymorphic C++ base class wrapping all STL-like collection structures.
*   **`Environment`**: Lexically bound key-value scope table containing parent pointer bindings.
*   **`ReturnException`**: Native C++ exception class thrown to unwind call stacks during function returns.
*   **`TokenType`**: Enumeration list identifying categories of tokens scanned by the Lexer.
*   **`ASTNode`**: Virtual C++ base class mapping abstract syntax structures.
