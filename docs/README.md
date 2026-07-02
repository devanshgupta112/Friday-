# FridayLang Documentation Portal

Welcome to the official, complete, in-depth documentation manual for **FridayLang**. FridayLang is a dynamically typed, interpreted scripting language featuring 15 unified container structures, built-in algorithms, first-class functions, and object-oriented class programming.

This manual is divided into the following sections in reading order:

1.  **[Overview](00-overview.md)** — Architectural design, execution stages, and limits of the FridayLang language.
2.  **[Lexical Analysis & Tokenizer](01-lexer-tokenizer.md)** — Token tables, regex matching rules, whitespace, and comment specs.
3.  **[Grammar Syntax](02-grammar-syntax.md)** — Formal EBNF grammar rules, operator precedence, and associativity maps.
4.  **[Parser & AST Nodes](03-parser-ast.md)** — AST class interfaces and recursive-descent syntax tree generation mechanics.
5.  **[Scoping & Type System](04-semantics-typesystem.md)** — Lexical scoping environments, dynamic typing boundaries, and name resolution.
6.  **[Runtime & Execution Model](05-execution-runtime.md)** — Memory representation of `RuntimeValue`, closures, call stack, and visitor execution.
7.  **[Standard Library & Builtins](06-builtins-stdlib.md)** — Unified STL container methods (Array, List, Map, Bitset, etc.) and `algo` module functions.
8.  **[Error Handling](07-error-handling.md)** — Lexical, syntactic, and runtime errors, and execution panic unwinding rules.
9.  **[Examples Walkthrough](08-examples-walkthrough.md)** — Line-by-line tracing of token streams, AST nodes, and runtime environment stacks for sample programs.
10. **[Known Limitations](09-known-limitations.md)** — Known performance bottlenecks, scope boundaries, and verbatim TODO annotations in source files.
11. **[Glossary](10-glossary.md)** — Clear, one-line reference of FridayLang definitions.
