# FridayLang Builtins & Standard Library Specification

This document provides a complete specification of all dynamic STL-like containers, string operations, and the built-in algorithms (`algo`) module in FridayLang.

---

## Container Unified API

Every container implements a subset of these core APIs (see [interpreter.h:50-64](file:///Users/Workspace/Development/Firday/interpreter.h#L50-L64)).

| Method | Return Type | Description |
| :--- | :---: | :--- |
| `.in(...)` | `VOID` | Reads space-separated elements from standard input, or sets values. |
| `.out()` | `VOID` | Prints space-separated container elements to console. |
| `.size()` | `NUMBER` | Returns the number of elements in the container. |
| `.empty()` | `STRING` | Returns `"true"` or `"false"`. |
| `.clear()` | `VOID` | Removes all elements from the container. |
| `.swap(other)`| `VOID` | Swaps contents with another container of the same type. |

---

## 1. Array

*   **Syntax**: `array name [size | (start, end) | = init_expr];` (see [parser.cpp:270-288](file:///Users/Workspace/Development/Firday/parser.cpp#L270-L288)).
*   **Implementation**: Wraps a C++ `std::vector<RuntimeValue>` (see [interpreter.cpp:17](file:///Users/Workspace/Development/Firday/interpreter.cpp#L17)).
*   **API Specification**: (see [interpreter.cpp:683-820](file:///Users/Workspace/Development/Firday/interpreter.cpp#L683-L820))
    *   `.push(val)`: Appends `val` to the end.
    *   `.pop()`: Erases the last element.
    *   `.front()`: Returns the first element.
    *   `.back()`: Returns the last element.
    *   `.resize(sz)`: Resizes container to size `sz`.
    *   `.sort()` / `.sort("desc")`: Sorts array elements.
    *   `.reverse()`: Reverses array elements in-place.
    *   `.find(val)`: Returns 0-based index of `val`, or `-1` if not found.
    *   `.contains(val)`: Returns `"true"` or `"false"`.
    *   `.max()` / `.min()`: Returns numeric limits.
    *   `.sum()` / `.avg()`: Returns numeric aggregate sum/average.
    *   `.count(val)`: Returns occurrence count of `val`.
    *   `.unique()`: Removes all duplicates in-place.
    *   `.slice(start, end)`: Returns a new subarray container from index `start` to `end-1`.
    *   `.insert(idx, val)`: Inserts `val` at index `idx`.
    *   `.erase(idx)`: Erases element at index `idx`.
    *   `.fill(val)`: Fills array with `val`.
    *   `.at(idx)`: Bounds-checked element retrieval.

---

## 2. Stack

*   **Syntax**: `stack name;` (see [parser.cpp:50-55](file:///Users/Workspace/Development/Firday/parser.cpp#L50-L55)).
*   **API Specification**: (see [interpreter.cpp:822-841](file:///Users/Workspace/Development/Firday/interpreter.cpp#L822-L841))
    *   `.push(val)`: Pushes `val` onto the stack top.
    *   `.pop()`: Pops the top element.
    *   `.top()`: Returns the top element.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.

---

## 3. Queue

*   **Syntax**: `queue name;`
*   **API Specification**: (see [interpreter.cpp:843-863](file:///Users/Workspace/Development/Firday/interpreter.cpp#L843-L863))
    *   `.push(val)`: Enqueues `val` at the back.
    *   `.pop()`: Dequeues the front element.
    *   `.front()`: Returns the front element.
    *   `.back()`: Returns the back element.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.

---

## 4. Deque

*   **Syntax**: `deque name;`
*   **API Specification**: (see [interpreter.cpp:865-894](file:///Users/Workspace/Development/Firday/interpreter.cpp#L865-L894))
    *   `.pushFront(val)` / `.pushBack(val)`: Inserts element at front/back.
    *   `.popFront()` / `.popBack()`: Removes element from front/back.
    *   `.front()` / `.back()`: Accesses front/back element.
    *   `.insert(idx, val)`: Inserts `val` at index `idx`.
    *   `.erase(idx)`: Erases element at index `idx`.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.
    *   *Subscripting*: Supports indexing via `dq[idx]`.

---

## 5. List

*   **Syntax**: `list name;`
*   **API Specification**: (see [interpreter.cpp:896-946](file:///Users/Workspace/Development/Firday/interpreter.cpp#L896-L946))
    *   `.pushFront(val)` / `.pushBack(val)` / `.popFront()` / `.popBack()` / `.front()` / `.back()`.
    *   `.insert(idx, val)` / `.erase(idx)`.
    *   `.reverse()`: Reverses list in-place.
    *   `.sort()`: Sorts list ascending.
    *   `.unique()`: Erases consecutive duplicate elements.
    *   `.merge(other)`: Appends elements of `other` and sorts.
    *   `.remove(val)`: Removes all elements matching `val`.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.

---

## 6. Set & Multiset

*   **Syntax**: `set name;` or `multiset name;`
*   **API Specification**: (see [interpreter.cpp:948-999](file:///Users/Workspace/Development/Firday/interpreter.cpp#L948-L999))
    *   `.insert(val)`: Inserts `val` and sorts. (Set ignores duplicates).
    *   `.erase(val)`: Removes all elements matching `val`.
    *   `.find(val)`: Returns index of `val`, or `-1`.
    *   `.contains(val)`: Returns `"true"` or `"false"`.
    *   `.count(val)`: Returns occurrences of `val`.
    *   `.lowerBound(val)`: Returns index of first element $\ge$ val.
    *   `.upperBound(val)`: Returns index of first element $>$ val.
    *   `.first()` / `.last()`: Accesses first/last element.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.

---

## 7. Map & UnorderedMap

*   **Syntax**: `map name;` or `unorderedMap name;`
*   **API Specification**: (see [interpreter.cpp:1001-1044](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1001-L1044))
    *   `.put(key, val)`: Binds key string to `val`.
    *   `.get(key)`: Retrieves value for `key`, throws error if not found.
    *   `.erase(key)`: Erases key.
    *   `.contains(key)`: Returns `"true"` or `"false"`.
    *   `.keys()` / `.values()`: Returns array of keys/values.
    *   `.items()`: Returns array of `"key: value"` strings.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.
    *   *Subscripting*: Supports indexing via `mp[key]`.

---

## 8. Priority Queue

*   **Syntax**: `priorityQueue name;`
*   **API Specification**: (see [interpreter.cpp:1046-1069](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1046-L1069))
    *   `.push(val)`: Inserts `val` and maintains descending heap order.
    *   `.pop()`: Removes the largest element (top).
    *   `.top()`: Accesses the largest element.
    *   `.size()`, `.empty()`, `.clear()`, `.swap(other)`, `.out()`.

---

## 9. Pair & Tuple

*   **Pair Syntax**: `pair name(first_val, second_val);`
*   **Pair APIs**: (see [interpreter.cpp:1071-1077](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1071-L1077))
    *   `.first()` / `.second()`: Accesses values.
    *   `.swap()`: Swaps first and second values.
    *   `.out()`.
*   **Tuple Syntax**: `tuple name(val1, val2, ...);`
*   **Tuple APIs**: (see [interpreter.cpp:1079-1092](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1079-L1092))
    *   `.get(idx)`: Accesses value at 0-based index `idx`.
    *   `.size()`, `.out()`.

---

## 10. Bitset

*   **Syntax**: `bitset name size;` (e.g. `bitset bits 16;`)
*   **API Specification**: (see [interpreter.cpp:1094-1110](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1094-L1110))
    *   `.set(idx)`: Sets bit `idx` to 1.
    *   `.reset(idx)`: Sets bit `idx` to 0.
    *   `.flip(idx)`: Toggles bit `idx`.
    *   `.flipAll()`: Toggles all bits.
    *   `.test(idx)`: Returns `"true"` if bit `idx` is 1, else `"false"`.
    *   `.count()`: Returns number of set (1) bits.
    *   `.any()` / `.none()` / `.all()`: Dynamic boolean bit checks.
    *   `.size()`, `.out()`.

---

## 11. String Methods

Strings are native dynamic primitives that support method extensions: (see [interpreter.cpp:1244-1355](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1244-L1355))
*   `.length()` / `.size()`: Returns character count.
*   `.empty()`: Returns `"true"` or `"false"`.
*   `.clear()`: Empties string.
*   `.upper()` / `.lower()`: Converts text casing in-place.
*   `.reverse()`: Reverses string in-place.
*   `.sort()`: Sorts characters alphabetically.
*   `.find(sub)`: Returns index of substring `sub` or `-1`.
*   `.contains(sub)`: Returns `"true"` or `"false"`.
*   `.substr(start, len)`: Extracts substring.
*   `.replace(target, rep)`: Replaces all occurrences of `target` with `rep`.
*   `.insert(idx, val)`: Inserts string `val` at index `idx`.
*   `.erase(idx, len)`: Erases characters.
*   `.split(delimiter)`: Splits string by delimiter and returns an Array.
*   `.trim()`: Trims surrounding whitespace.
*   `.startsWith(prefix)` / `.endsWith(suffix)`: String boundary checks.
*   `.count(char)`: Returns occurrences of `char`.
*   `.charAt(idx)`: Returns character at index `idx`.
*   `.out()`: Prints string to console.

---

## 12. Algorithms Module (`algo`)

Accessible via the global `algo` binding (see [interpreter.cpp:1112-1240](file:///Users/Workspace/Development/Firday/interpreter.cpp#L1112-L1240)):
*   **Math Utilities**:
    *   `algo.gcd(a, b)`: Greatest Common Divisor.
    *   `algo.lcm(a, b)`: Least Common Multiple.
    *   `algo.pow(a, b)`: Power ($a^b$).
    *   `algo.sqrt(a)`: Square root.
    *   `algo.abs(a)`: Absolute value.
    *   `algo.factorial(a)`: Factorial computation.
*   **Array Algorithms**:
    *   `algo.sort(arr)` / `algo.sort(arr, "desc")`: Sorts array elements.
    *   `algo.reverse(arr)`: Reverses array elements in-place.
    *   `algo.binarySearch(arr, val)`: Binary search validation.
    *   `algo.lowerBound(arr, val)` / `algo.upperBound(arr, val)`: Binary partition bounds.
    *   `algo.max(arr)` / `algo.min(arr)`: Numeric limits.
    *   `algo.maxElement(arr)` / `algo.minElement(arr)`: Returns index of maximum/minimum element.
    *   `algo.sum(arr)` / `algo.avg(arr)`: Numeric aggregation.
    *   `algo.rotate(arr, k)`: Rotates array elements by `k` steps.
    *   `algo.shuffle(arr)`: Randomly shuffles array elements.
    *   `algo.unique(arr)`: Removes consecutive duplicates in-place.
    *   `algo.fill(arr, val)`: Fills array with `val`.
    *   `algo.count(arr, val)`: Returns occurrence count.
    *   `algo.find(arr, val)`: Locates element index or returns `-1`.
