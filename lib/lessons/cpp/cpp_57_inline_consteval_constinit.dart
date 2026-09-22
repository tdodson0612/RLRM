// lib/lessons/cpp/cpp_57_inline_consteval_constinit.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson57 = Lesson(
  language: 'C++',
  title: 'inline, consteval, and constinit',
  content: '''
🎯 METAPHOR:
inline is like writing a recipe directly on the plate
instead of referencing a cookbook. Instead of saying
"go look up page 42," the instructions are right there.
The meal gets made faster (no page flip), but if the
recipe is long, the plate gets crowded.

consteval is a strict chef who only works during menu
planning (compile time). They refuse to cook at all
if you try to call them during the dinner service (runtime).

constinit is a health inspector who checks at opening time:
"Are ALL your ingredients pre-stocked before you open?"
It does not prevent changes later — it just guarantees
the initial setup was done at compile time, not lazily.

📖 EXPLANATION:
INLINE:
  Suggests the compiler replace the function call with
  the function body directly. In modern C++, the compiler
  largely ignores this hint for optimization — it inlines
  what it wants. BUT inline has a critical second purpose:
  it allows a function/variable to be defined in a header
  without causing "multiple definition" linker errors.

CONSTEVAL (C++20):
  Like constexpr but STRICTER — must be evaluated at
  compile time. Cannot be called at runtime at all.
  Use for: compile-time only computations, metaprogramming.

CONSTINIT (C++20):
  Guarantees a variable is initialized at compile time
  (not lazily at runtime). Does NOT make it const.
  Solves the "static initialization order fiasco."

💻 CODE:
#include <iostream>

// ─── INLINE FUNCTION ───
// In header files — inline prevents multiple definition errors
inline int square(int x) {
    return x * x;
}

// ─── INLINE VARIABLE (C++17) ───
// Define a constant in a header without multiple-definition errors
inline constexpr double PI = 3.14159265358979;
inline int instanceCount = 0;  // can be defined in header, shared across TUs

// ─── CONSTEXPR vs CONSTEVAL ───
constexpr int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
// fibonacci(10) — works at compile time
// fibonacci(x)  — also works at runtime (flexible)

// C++20 consteval — ONLY compile time
consteval int fibCompileOnly(int n) {
    if (n <= 1) return n;
    return fibCompileOnly(n - 1) + fibCompileOnly(n - 2);
}
// fibCompileOnly(10) — OK (compile time)
// int x = 5; fibCompileOnly(x); — ERROR: x not constexpr!

// ─── CONSTINIT (C++20) ───
// Guarantees this is initialized at compile time (not lazily)
constinit int maxConnections = 100;
// maxConnections can still be changed at runtime — it is not const!

// Solves static initialization order fiasco:
constinit int serverPort = 8080;   // guaranteed initialized before use

// ─── PRACTICAL INLINE: class methods in header ───
class Vec2 {
public:
    float x, y;
    Vec2(float x, float y) : x(x), y(y) {}

    // Short methods defined inline in the class — implicitly inline
    float length() const { return x * x + y * y; }  // implicitly inline

    // Explicit inline in header for longer methods
    inline Vec2 normalized() const {
        float len = length();
        return {x / len, y / len};
    }
};

// ─── if consteval (C++23 preview / C++23 feature) ───
// Detects at compile time if we're in a consteval context
constexpr int smartCompute(int n) {
    // In C++23: if consteval { ... } else { ... }
    return n * n;  // simple version for now
}

int main() {
    // inline function
    std::cout << square(7) << std::endl;  // 49

    // constexpr — works both ways
    constexpr int fib10 = fibonacci(10);  // compile time
    std::cout << fib10 << std::endl;       // 55

    int runtime_n = 8;
    std::cout << fibonacci(runtime_n) << std::endl;  // runtime: 21

    // consteval — compile time only
    constexpr int ce = fibCompileOnly(10);
    std::cout << ce << std::endl;  // 55
    // int x = 5; fibCompileOnly(x);  // ERROR — x is not constexpr

    // constinit
    std::cout << maxConnections << std::endl;  // 100
    maxConnections = 200;  // allowed — constinit doesn't mean const
    std::cout << maxConnections << std::endl;  // 200

    // PI from inline constexpr
    std::cout << PI << std::endl;  // 3.14159...

    return 0;
}

📝 KEY POINTS:
✅ inline in headers prevents multiple definition linker errors
✅ Methods defined inside a class body are implicitly inline
✅ consteval guarantees compile-time evaluation — stricter than constexpr
✅ constinit ensures compile-time initialization without making the var const
✅ Modern compilers inline aggressively regardless of the inline keyword
❌ Don't use inline as a performance hint — compilers ignore it for that purpose
❌ consteval functions cannot be called with runtime values — compile error
''',
  quiz: [
    Quiz(question: 'What is the main practical use of "inline" in modern C++?', options: [
      QuizOption(text: 'Allowing function/variable definitions in headers without multiple definition errors', correct: true),
      QuizOption(text: 'Telling the compiler to inline the function body for performance', correct: false),
      QuizOption(text: 'Making a function run at compile time', correct: false),
      QuizOption(text: 'Preventing a function from being overridden', correct: false),
    ]),
    Quiz(question: 'What makes consteval stricter than constexpr?', options: [
      QuizOption(text: 'consteval must ALWAYS be evaluated at compile time — runtime calls are errors', correct: true),
      QuizOption(text: 'consteval functions run faster than constexpr', correct: false),
      QuizOption(text: 'consteval can only be used on integer types', correct: false),
      QuizOption(text: 'consteval prevents all runtime computation', correct: false),
    ]),
    Quiz(question: 'What does constinit guarantee?', options: [
      QuizOption(text: 'The variable is initialized at compile time, not lazily at runtime', correct: true),
      QuizOption(text: 'The variable cannot be modified after initialization', correct: false),
      QuizOption(text: 'The variable is stored in read-only memory', correct: false),
      QuizOption(text: 'The variable is thread-safe', correct: false),
    ]),
  ],
);
