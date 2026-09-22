// lib/lessons/cpp/cpp_59_sfinae_type_traits.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson59 = Lesson(
  language: 'C++',
  title: 'Type Traits and SFINAE',
  content: '''
🎯 METAPHOR:
Type traits are like personality tests for types.
"Is this type an integer? Is it copyable? Does it have a
default constructor?" You get yes/no answers at compile time.
You can then write code that behaves differently based on
the type's characteristics — like a shape-sorter toy that
only lets certain shapes through certain holes.

SFINAE is like a job application filter.
If a candidate doesn't meet the requirements, they're
quietly removed from consideration — no error, no drama.
The next candidate (template overload) is tried instead.
"Substitution Failure Is Not An Error."

📖 EXPLANATION:
TYPE TRAITS (<type_traits>):
  Compile-time queries about types.
  Returns true_type or false_type (or a value).
  Essential for writing generic, constrained code.

SFINAE:
  When template argument substitution fails, that
  overload is silently removed from consideration.
  Other overloads may still match.
  Enabled with: std::enable_if, if constexpr, Concepts (C++20).

In modern C++, prefer if constexpr and Concepts over
raw SFINAE — they are much more readable.

💻 CODE:
#include <iostream>
#include <type_traits>
#include <string>
#include <vector>

// ─── TYPE TRAITS ───
void showTraits() {
    std::cout << std::boolalpha;

    // Querying type properties
    std::cout << std::is_integral<int>::value       << std::endl;  // true
    std::cout << std::is_integral<double>::value    << std::endl;  // false
    std::cout << std::is_floating_point<float>::value << std::endl; // true
    std::cout << std::is_pointer<int*>::value       << std::endl;  // true
    std::cout << std::is_reference<int&>::value     << std::endl;  // true
    std::cout << std::is_const<const int>::value    << std::endl;  // true
    std::cout << std::is_same<int, int32_t>::value  << std::endl;  // true (on most platforms)
    std::cout << std::is_base_of<std::exception, std::runtime_error>::value << std::endl; // true
    std::cout << std::is_default_constructible<std::string>::value << std::endl; // true
    std::cout << std::is_copy_constructible<std::vector<int>>::value << std::endl; // true

    // C++14 shorthand: _v suffix
    std::cout << std::is_integral_v<int> << std::endl;  // true (same as ::value)
    std::cout << std::is_same_v<int, long> << std::endl; // false

    // Type transformations
    using T = std::remove_const<const int>::type;    // int
    using U = std::add_pointer<int>::type;           // int*
    using V = std::remove_reference<int&>::type;     // int
    using W = std::decay<const int&>::type;          // int (removes const + ref)

    std::cout << std::is_same_v<T, int>  << std::endl;  // true
    std::cout << std::is_same_v<U, int*> << std::endl;  // true
}

// ─── SFINAE with enable_if ───
// Only enabled for integral types
template<typename T>
typename std::enable_if<std::is_integral_v<T>, T>::type
doubled(T x) {
    return x * 2;
}

// Only enabled for floating point types
template<typename T>
typename std::enable_if<std::is_floating_point_v<T>, T>::type
doubled(T x) {
    return x * 2.0;
}

// ─── MODERN: if constexpr (cleaner than SFINAE) ───
template<typename T>
void describe(T x) {
    if constexpr (std::is_integral_v<T>) {
        std::cout << x << " is an integer" << std::endl;
    } else if constexpr (std::is_floating_point_v<T>) {
        std::cout << x << " is a float" << std::endl;
    } else {
        std::cout << x << " is something else" << std::endl;
    }
}

// ─── std::conditional — choose type at compile time ───
template<bool Condition, typename TrueType, typename FalseType>
using SelectType = std::conditional_t<Condition, TrueType, FalseType>;

int main() {
    showTraits();

    // SFINAE — picks the right overload
    std::cout << doubled(5) << std::endl;    // 10  (integer version)
    std::cout << doubled(3.14) << std::endl; // 6.28 (float version)
    // doubled("hi");  // ERROR: no matching overload — neither integral nor float

    // if constexpr — clean, readable
    describe(42);        // 42 is an integer
    describe(3.14);      // 3.14 is a float
    describe("hello");   // hello is something else

    // std::conditional — pick a type
    using SmallOrBig = SelectType<(sizeof(int) < 8), int, long long>;
    std::cout << sizeof(SmallOrBig) << std::endl;  // 4 (int, since sizeof(int)=4 < 8)

    // static_assert with type traits
    static_assert(std::is_integral_v<int>, "int must be integral");
    static_assert(std::is_same_v<int, int>, "int is int");

    return 0;
}

📝 KEY POINTS:
✅ Type traits let you query type properties at compile time
✅ Use the _v suffix shorthand (C++14): is_integral_v<T> not is_integral<T>::value
✅ Prefer if constexpr over SFINAE — far more readable
✅ Prefer Concepts (C++20) for constraining templates with clear error messages
✅ std::decay removes const, reference, and array decay — useful in templates
❌ Raw SFINAE with enable_if is hard to read — use it only in pre-C++17 code
❌ Don't use type traits for runtime type checking — use dynamic_cast instead
''',
  quiz: [
    Quiz(question: 'What does SFINAE stand for?', options: [
      QuizOption(text: 'Substitution Failure Is Not An Error', correct: true),
      QuizOption(text: 'Static Function Inline And Evaluate', correct: false),
      QuizOption(text: 'Standard Function Interface Naming Extension', correct: false),
      QuizOption(text: 'Structured Function Invocation and Narrowing Elimination', correct: false),
    ]),
    Quiz(question: 'What is the C++14 shorthand for std::is_integral<T>::value?', options: [
      QuizOption(text: 'std::is_integral_v<T>', correct: true),
      QuizOption(text: 'std::is_integral<T>.value', correct: false),
      QuizOption(text: 'is_integral(T)', correct: false),
      QuizOption(text: 'type_of<T>::integral', correct: false),
    ]),
    Quiz(question: 'What is the modern C++ alternative to SFINAE for conditional compilation?', options: [
      QuizOption(text: 'if constexpr and C++20 Concepts', correct: true),
      QuizOption(text: 'std::enable_if with auto return types', correct: false),
      QuizOption(text: 'Preprocessor #ifdef blocks', correct: false),
      QuizOption(text: 'Runtime type checking with typeid', correct: false),
    ]),
  ],
);
