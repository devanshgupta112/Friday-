# FridayLang

FridayLang is a dynamically typed, interpreted scripting language written in C++17. It features 15 C++ STL-like dynamic containers (Arrays, Stacks, Queues, Maps, Bitsets, etc.) accessible via a unified API, built-in numeric/collection algorithms, first-class functions, and object-oriented class programming.

---

## **Features**
*   **15 STL-like Containers**: Standardized dynamic API (`.size()`, `.empty()`, `.clear()`, `.out()`, `.swap()`).
*   **Unified Algorithm Namespace (`algo`)**: Quick functions for math (gcd, lcm, sqrt, pow) and arrays (sort, reverse, binarySearch).
*   **Parentheses-free Loops**: Simplified structures for C-style `for` loops and iteration `foreach` loops.
*   **Dynamic OOP**: Classes with methods, constructors (`init`), and instance `this` referencing.

---

## **Quick Build**

Make sure you have a C++17 compiler and **CMake (v3.15+)** installed.

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

This compiles the `friday` compiler executable inside the `build` directory.

---

## **Installation**

Run the appropriate install script from the root directory:

*   **macOS / Linux**:
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
*   **Windows (PowerShell)**:
    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process
    ./install.ps1
    ```

---

## **Documentation**

The complete technical manuals are located in the `/docs` directory:
*   **[Read the Documentation Guide](docs/README.md)**

---

## **Examples**

Ready-to-run FridayLang scripts are located in the `/example` directory:
*   [stl_containers.fry](example/stl_containers.fry) — Test suite of all 15 containers.
*   [oop_warrior.fry](example/oop_warrior.fry) — OOP classes and mutations.
*   [recursion.fry](example/recursion.fry) — Recursive Fibonacci calculations.
