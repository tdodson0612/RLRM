// lib/lessons/cpp/cpp_28_lambda_functions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson28 = Lesson(
  language: 'C++',
  title: 'Lambda Functions',
  content: '''
🎯 METAPHOR:
A lambda is like a sticky note with instructions.
A regular function is like a printed manual — it has a
name, lives on the shelf, and you reference it by title.
A lambda is a sticky note you write on the spot for one
specific task, use immediately, and throw away. Perfect for
"sort these by this specific rule right here, right now"
without writing a whole named function for a one-time job.

📖 EXPLANATION:
Lambdas are anonymous functions defined inline.
Introduced in C++11, they are essential for STL algorithms,
callbacks, and short-lived operations.

SYNTAX:
  [capture](parameters) -> return_type { body }

  [capture]    — what variables from the surrounding scope to bring in
  (parameters) — just like function parameters
  -> type      — return type (usually omitted, compiler deduces it)
  { body }     — the code

─────────────────────────────────────
CAPTURE MODES:
─────────────────────────────────────
[]        capture nothing
[x]       capture x by value (copy)
[&x]      capture x by reference
[=]       capture ALL local vars by value
[&]       capture ALL local vars by reference
[=, &x]   everything by value except x by reference
[this]    capture the current object
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>

int main() {
    // Basic lambda
    auto greet = []() {
        std::cout << "Hello from lambda!" << std::endl;
    };
    greet();  // call it like a function

    // Lambda with parameters
    auto add = [](int a, int b) {
        return a + b;
    };
    std::cout << add(3, 4) << std::endl;  // 7

    // Lambda with capture by value
    int multiplier = 3;
    auto times = [multiplier](int x) {
        return x * multiplier;  // multiplier is captured (copy)
    };
    multiplier = 100;            // changing local var
    std::cout << times(5) << std::endl;  // 15 — captured the OLD value

    // Lambda with capture by reference
    int total = 0;
    auto addToTotal = [&total](int x) {
        total += x;  // modifies the actual total
    };
    addToTotal(10);
    addToTotal(20);
    std::cout << total << std::endl;  // 30

    // Lambda as STL comparator
    std::vector<std::string> words = {"banana", "kiwi", "apple", "fig"};
    std::sort(words.begin(), words.end(),
              [](const std::string& a, const std::string& b) {
                  return a.length() < b.length();
              });
    for (auto& w : words) std::cout << w << " ";
    // fig kiwi apple banana

    // Lambda with explicit return type
    auto divide = [](double a, double b) -> double {
        if (b == 0) return 0.0;
        return a / b;
    };

    // std::function — store a lambda in a variable with a known type
    std::function<int(int, int)> operation;
    operation = [](int a, int b) { return a + b; };
    std::cout << operation(5, 3) << std::endl;  // 8
    operation = [](int a, int b) { return a * b; };
    std::cout << operation(5, 3) << std::endl;  // 15

    // Immediately invoked lambda
    int result = [](int x) { return x * x; }(7);
    std::cout << result << std::endl;  // 49

    // Mutable lambda — allows modifying captured-by-value vars
    int count = 0;
    auto increment = [count]() mutable {
        count++;
        return count;
    };
    std::cout << increment() << std::endl;  // 1
    std::cout << count << std::endl;        // 0 — original unchanged

    return 0;
}

📝 KEY POINTS:
✅ Use lambdas for short, inline operations — especially with STL
✅ Capture by reference [&] when you need to modify outer variables
✅ Capture by value [=] when you just need to read
✅ Use std::function when you need to store/pass lambdas with a known type
✅ mutable allows modifying captured-by-value variables inside the lambda
❌ Don't capture by reference [&] if the lambda outlives the captured variables
❌ [=] captures everything — consider capturing only what you need
''',
  quiz: [
    Quiz(question: 'What does [&] in a lambda capture clause mean?', options: [
      QuizOption(text: 'Capture all local variables by reference', correct: true),
      QuizOption(text: 'Capture all local variables by value', correct: false),
      QuizOption(text: 'Capture nothing', correct: false),
      QuizOption(text: 'Capture only pointers', correct: false),
    ]),
    Quiz(question: 'What is the difference between capturing by value vs by reference?', options: [
      QuizOption(text: 'By value copies the variable; by reference uses the original', correct: true),
      QuizOption(text: 'By reference copies the variable; by value uses the original', correct: false),
      QuizOption(text: 'They are identical unless the variable is const', correct: false),
      QuizOption(text: 'By value only works with primitives', correct: false),
    ]),
    Quiz(question: 'What does the mutable keyword do in a lambda?', options: [
      QuizOption(text: 'Allows the lambda to modify its captured-by-value copies', correct: true),
      QuizOption(text: 'Makes the lambda re-callable after use', correct: false),
      QuizOption(text: 'Enables capturing variables by reference', correct: false),
      QuizOption(text: 'Allows the lambda to modify global variables', correct: false),
    ]),
  ],
);
