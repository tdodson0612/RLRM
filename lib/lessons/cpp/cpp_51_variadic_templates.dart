// lib/lessons/cpp/cpp_51_variadic_templates.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson51 = Lesson(
  language: 'C++',
  title: 'Variadic Templates and Perfect Forwarding',
  content: '''
🎯 METAPHOR:
A variadic template is like a recipe that works for any
number of ingredients. "Make a sandwich with whatever you
hand me" — one slice, three slices, a whole loaf. The recipe
adapts. printf() in C works this way with ..., but with no
type safety. C++ variadic templates do the same thing but
with full type checking at compile time.

Perfect forwarding is like a courier who delivers a package
in exactly the condition it was received — if it arrived
on a truck (rvalue), it leaves on a truck. If it was
hand-carried (lvalue), it is hand-carried onward. No
accidental reboxing, no unnecessary copies.

📖 EXPLANATION:
VARIADIC TEMPLATES (C++11):
  template<typename... Args>  — Args is a parameter pack
  Can accept zero or more type arguments.
  Used in: make_tuple, make_unique, printf replacements, logging.

PERFECT FORWARDING (C++11):
  std::forward<T>(arg) — preserves the value category (lvalue/rvalue)
  Used to pass arguments through without changing their category.
  The combination of T&& (universal reference) + std::forward
  is the standard pattern for wrapper functions.

💻 CODE:
#include <iostream>
#include <string>
#include <tuple>
#include <memory>

// ─── VARIADIC TEMPLATE FUNCTION ───
// Base case — empty pack
void print() {
    std::cout << std::endl;
}

// Recursive variadic template
template<typename First, typename... Rest>
void print(First first, Rest... rest) {
    std::cout << first;
    if (sizeof...(rest) > 0) std::cout << ", ";
    print(rest...);  // recurse with one fewer argument
}

// Sum any number of values
template<typename T>
T sum(T val) { return val; }

template<typename T, typename... Args>
T sum(T first, Args... args) {
    return first + sum(args...);
}

// Count arguments at compile time
template<typename... Args>
constexpr size_t countArgs(Args...) {
    return sizeof...(Args);
}

// ─── PERFECT FORWARDING ───
class Widget {
public:
    Widget() { std::cout << "Widget constructed" << std::endl; }
    Widget(const Widget&) { std::cout << "Widget COPIED" << std::endl; }
    Widget(Widget&&) noexcept { std::cout << "Widget MOVED" << std::endl; }
};

// WITHOUT perfect forwarding — always copies
template<typename T>
void wrapBad(T arg) {
    // ... do some wrapping ...
    // arg is always an lvalue here — moves are lost!
}

// WITH perfect forwarding — preserves move/copy semantics
template<typename T>
void wrapGood(T&& arg) {
    // T&& is a "universal reference" (not just rvalue ref!)
    // std::forward<T> preserves whether arg was lvalue or rvalue
    Widget w(std::forward<T>(arg));
}

// Factory function — the canonical use of perfect forwarding
template<typename T, typename... Args>
T* createRaw(Args&&... args) {
    return new T(std::forward<Args>(args)...);
}

// This is how make_unique is implemented internally:
template<typename T, typename... Args>
std::unique_ptr<T> myMakeUnique(Args&&... args) {
    return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
}

struct Point {
    int x, y;
    Point(int x, int y) : x(x), y(y) {}
};

int main() {
    // ─── VARIADIC ───
    print(1, "hello", 3.14, true);  // 1, hello, 3.14, 1
    print("just one");              // just one
    print();                        // (empty line)

    std::cout << sum(1, 2, 3, 4, 5) << std::endl;       // 15
    std::cout << sum(1.1, 2.2, 3.3) << std::endl;       // 6.6
    std::cout << sum(std::string("a"), std::string("b"), std::string("c")) << std::endl;  // abc

    std::cout << countArgs(1, "hi", 3.0) << std::endl;  // 3

    // ─── PERFECT FORWARDING ───
    Widget w1;
    wrapGood(w1);              // lvalue — COPIED
    wrapGood(Widget());        // rvalue — MOVED
    wrapGood(std::move(w1));   // forced rvalue — MOVED

    // Factory with perfect forwarding
    auto p = myMakeUnique<Point>(3, 4);
    std::cout << p->x << ", " << p->y << std::endl;  // 3, 4

    return 0;
}

─────────────────────────────────────
FOLD EXPRESSIONS (C++17 — cleaner variadic):
─────────────────────────────────────
template<typename... Args>
auto sumFold(Args... args) {
    return (... + args);  // fold expression — no recursion needed!
}
// sumFold(1, 2, 3, 4, 5) → 15
─────────────────────────────────────

📝 KEY POINTS:
✅ sizeof...(Args) gives the count of variadic arguments at compile time
✅ Variadic templates are zero-overhead — all expansion happens at compile time
✅ T&& in a template is a "universal reference" — binds to both lvalues and rvalues
✅ std::forward<T> is ONLY meaningful inside a template function
✅ C++17 fold expressions replace manual recursion for variadic ops
❌ Don't use C-style variadic (...) in new code — no type safety
❌ std::forward outside a template context doesn't do anything useful
''',
  quiz: [
    Quiz(question: 'What does sizeof...(Args) evaluate to?', options: [
      QuizOption(text: 'The number of arguments in the variadic parameter pack', correct: true),
      QuizOption(text: 'The total size in bytes of all arguments', correct: false),
      QuizOption(text: 'The size of the largest argument type', correct: false),
      QuizOption(text: 'The number of template parameters used so far', correct: false),
    ]),
    Quiz(question: 'What does std::forward<T>(arg) do in a template function?', options: [
      QuizOption(text: 'Preserves the value category (lvalue or rvalue) of the argument', correct: true),
      QuizOption(text: 'Always converts the argument to an rvalue', correct: false),
      QuizOption(text: 'Always copies the argument', correct: false),
      QuizOption(text: 'Forwards the argument to the next function in the call stack', correct: false),
    ]),
    Quiz(question: 'What is a "universal reference" in C++ template code?', options: [
      QuizOption(text: 'T&& in a template context — can bind to both lvalues and rvalues', correct: true),
      QuizOption(text: 'A reference that can point to any type', correct: false),
      QuizOption(text: 'A const reference to a base class', correct: false),
      QuizOption(text: 'A reference that is automatically null-safe', correct: false),
    ]),
  ],
);
