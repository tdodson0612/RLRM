// lib/lessons/cpp/cpp_45_cpp20_and_beyond.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson45 = Lesson(
  language: 'C++',
  title: 'C++20 and What\'s Next',
  content: '''
🎯 METAPHOR:
C++20 is like upgrading from a flip phone to a smartphone.
The phone still makes calls (full backward compatibility),
but now it has an app store, GPS, a camera, and touch screen.
Concepts are like an app store review process — enforcing
that a template argument actually has the features you need,
not just hoping it does. Ranges are GPS — instead of manually
navigating with iterators, you just say where you want to go.

📖 EXPLANATION:
C++20 is the biggest update since C++11. It adds:

─────────────────────────────────────
C++20 BIG FOUR:
─────────────────────────────────────
1. CONCEPTS     — constrain template type arguments
2. RANGES       — composable, lazy algorithm pipelines
3. COROUTINES   — suspendable functions (co_await, co_yield)
4. MODULES      — replace #include with import
─────────────────────────────────────

PLUS MANY SMALLER FEATURES:
  std::span           — non-owning view over contiguous data
  std::format         — type-safe string formatting (like Python's f-strings)
  Three-way comparison operator <=>  ("spaceship")
  std::jthread        — joining thread (auto-joins on destruction)
  std::numbers::pi    — math constants
  Calendar/timezone   — in <chrono>
  std::bit_cast       — safe reinterpret for same-size types

💻 CODE:
#include <iostream>
#include <vector>
#include <ranges>
#include <concepts>
#include <format>    // C++20
#include <span>
#include <numbers>   // C++20

// ─── CONCEPTS — constrain template arguments ───
template <typename T>
concept Numeric = std::is_arithmetic_v<T>;

template <Numeric T>
T square(T x) { return x * x; }

// Custom concept
template <typename T>
concept Printable = requires(T x) {
    { std::cout << x } -> std::same_as<std::ostream&>;
};

template <Printable T>
void print(const T& val) {
    std::cout << val << std::endl;
}

// ─── SPACESHIP OPERATOR (C++20) ───
class Version {
    int major, minor, patch;
public:
    Version(int maj, int min, int pat) : major(maj), minor(min), patch(pat) {}
    auto operator<=>(const Version&) const = default;  // auto-generates all comparison operators!
};

int main() {
    // ─── CONCEPTS ───
    std::cout << square(5) << std::endl;     // 25 (int)
    std::cout << square(3.14) << std::endl;  // 9.8596 (double)
    // square("hello");  // ERROR: string is not Numeric — clear error message!

    print(42);
    print(std::string("hello"));

    // ─── RANGES ───
    std::vector<int> nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    // Lazy pipeline: filter evens, square them, take first 3
    auto result = nums
        | std::views::filter([](int x) { return x % 2 == 0; })
        | std::views::transform([](int x) { return x * x; })
        | std::views::take(3);

    for (int x : result) std::cout << x << " ";  // 4 16 36
    std::cout << std::endl;

    // ─── std::format (like Python f-strings) ───
    std::string msg = std::format("Hello, {}! You are {} years old.", "Alice", 30);
    std::cout << msg << std::endl;

    std::string pi_str = std::format("Pi is approximately {:.4f}", std::numbers::pi);
    std::cout << pi_str << std::endl;  // Pi is approximately 3.1416

    // ─── std::span — non-owning view ───
    int arr[] = {1, 2, 3, 4, 5};
    std::span<int> view(arr, 5);

    for (int x : view) std::cout << x << " ";  // 1 2 3 4 5
    view[2] = 99;  // modifies original array!

    // ─── THREE-WAY COMPARISON ───
    Version v1{1, 2, 3};
    Version v2{1, 3, 0};
    std::cout << (v1 < v2) << std::endl;  // 1 (true)
    std::cout << (v1 == v2) << std::endl; // 0 (false)

    // ─── MATH CONSTANTS (C++20) ───
    std::cout << std::numbers::pi << std::endl;   // 3.14159...
    std::cout << std::numbers::e << std::endl;    // 2.71828...
    std::cout << std::numbers::sqrt2 << std::endl; // 1.41421...

    return 0;
}

─────────────────────────────────────
WHAT'S COMING IN C++23 AND BEYOND:
─────────────────────────────────────
std::expected      — result type (value OR error)
std::print / println — finally, a clean print function
std::stacktrace    — stack traces in C++
import std;        — import the entire standard library as a module
std::generator     — coroutine-based ranges
─────────────────────────────────────

📝 KEY POINTS:
✅ Concepts give template errors that actually make sense
✅ Ranges let you chain algorithms into clean readable pipelines
✅ std::format finally gives C++ Python-style string formatting
✅ The spaceship operator <=> generates all 6 comparison operators at once
✅ std::span avoids array decay while keeping zero-copy efficiency
❌ C++20 requires a recent compiler: GCC 10+, Clang 10+, MSVC 2019+
❌ Not all C++20 features are available everywhere — check your compiler
''',
  quiz: [
    Quiz(question: 'What do C++20 Concepts do?', options: [
      QuizOption(text: 'Constrain template type arguments with clear requirements and better error messages', correct: true),
      QuizOption(text: 'Replace classes with a simpler object system', correct: false),
      QuizOption(text: 'Add runtime type checking to templates', correct: false),
      QuizOption(text: 'Replace the include system with a new module syntax', correct: false),
    ]),
    Quiz(question: 'What does the spaceship operator <=> do?', options: [
      QuizOption(text: 'Automatically generates all six comparison operators for a class', correct: true),
      QuizOption(text: 'Compares two pointers by address', correct: false),
      QuizOption(text: 'Moves an object to a new memory location', correct: false),
      QuizOption(text: 'Creates a three-way conditional expression', correct: false),
    ]),
    Quiz(question: 'What is std::span in C++20?', options: [
      QuizOption(text: 'A non-owning view over a contiguous sequence of data', correct: true),
      QuizOption(text: 'A smart pointer for arrays', correct: false),
      QuizOption(text: 'A replacement for std::vector', correct: false),
      QuizOption(text: 'A string type for multi-byte characters', correct: false),
    ]),
  ],
);
