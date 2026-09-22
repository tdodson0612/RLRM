// lib/lessons/cpp/cpp_50_function_pointers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson50 = Lesson(
  language: 'C++',
  title: 'Function Pointers and std::function',
  content: '''
🎯 METAPHOR:
A function pointer is like a remote control button that
you can reprogram. Normally, the Play button always plays.
But imagine reassigning it: now Play calls shuffle, or calls
your custom playlist function. The button is the pointer —
it holds the address of WHICH function to call. You can
swap it out at runtime. Whoever holds the remote decides
what happens when the button is pressed.

📖 EXPLANATION:
In C++, functions live at memory addresses, just like data.
A function pointer stores the address of a function and
lets you call it indirectly.

─────────────────────────────────────
SYNTAX (notoriously tricky):
─────────────────────────────────────
int add(int a, int b);          // regular function
int (*fp)(int, int);            // pointer to function taking 2 ints, returning int
fp = add;                       // assign
int result = fp(3, 4);          // call through pointer

// Tip: use "using" alias to make it readable
using MathFunc = int(*)(int, int);
MathFunc fp = add;
─────────────────────────────────────

std::function (C++11) — safer, more flexible alternative:
  - Works with regular functions, lambdas, member functions, functors
  - Slightly more overhead than raw function pointer
  - Preferred in modern code

💻 CODE:
#include <iostream>
#include <functional>
#include <vector>
#include <algorithm>

// Some functions to point at
int add(int a, int b)      { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }

void printResult(int x) { std::cout << "Result: " << x << std::endl; }

// Function that takes a function pointer as parameter
int applyOp(int a, int b, int(*op)(int, int)) {
    return op(a, b);
}

// Using std::function — cleaner
int applyOpModern(int a, int b, std::function<int(int, int)> op) {
    return op(a, b);
}

// Callback registration pattern
class Button {
    std::function<void()> onClick;
public:
    void setOnClick(std::function<void()> cb) { onClick = cb; }
    void click() {
        if (onClick) onClick();
        else std::cout << "No handler set" << std::endl;
    }
};

int main() {
    // ─── RAW FUNCTION POINTERS ───
    int (*fp)(int, int) = add;      // pointer to add
    std::cout << fp(3, 4) << std::endl;  // 7

    fp = subtract;
    std::cout << fp(10, 3) << std::endl;  // 7

    // Using alias for readability
    using BinaryOp = int(*)(int, int);
    BinaryOp ops[] = {add, subtract, multiply};
    for (auto op : ops) {
        std::cout << op(6, 3) << std::endl;  // 9, 3, 18
    }

    // Pass function as parameter
    std::cout << applyOp(5, 3, add) << std::endl;       // 8
    std::cout << applyOp(5, 3, multiply) << std::endl;  // 15

    // ─── std::function — flexible, handles lambdas too ───
    std::function<int(int, int)> f = add;
    std::cout << f(2, 3) << std::endl;  // 5

    f = [](int a, int b) { return a * a + b * b; };  // reassign to lambda!
    std::cout << f(3, 4) << std::endl;  // 25

    // std::function stored in a container
    std::vector<std::function<int(int, int)>> funcs = {add, subtract, multiply};
    for (auto& fn : funcs) std::cout << fn(10, 5) << " ";
    // 15 5 50

    // ─── CALLBACK PATTERN ───
    Button btn;
    btn.click();  // No handler set

    int clickCount = 0;
    btn.setOnClick([&clickCount]() {
        clickCount++;
        std::cout << "Button clicked! Count: " << clickCount << std::endl;
    });
    btn.click();
    btn.click();

    // ─── MEMBER FUNCTION POINTER ───
    struct Dog {
        void bark() { std::cout << "Woof!" << std::endl; }
        void sit()  { std::cout << "Sitting..." << std::endl; }
    };

    void (Dog::*action)() = &Dog::bark;  // pointer to member function
    Dog d;
    (d.*action)();  // call through member function pointer — Woof!

    action = &Dog::sit;
    (d.*action)();  // Sitting...

    return 0;
}

📝 KEY POINTS:
✅ Use std::function in modern C++ — it handles lambdas, functors, and functions
✅ Use raw function pointers only in performance-critical C-interface code
✅ Use type aliases to make function pointer declarations readable
✅ std::function can be null-checked with if(fn) before calling
✅ Member function pointers use the ->* or .* operators
❌ Raw function pointers cannot store lambdas with captures
❌ std::function has slightly more overhead than raw pointers — profile if critical
''',
  quiz: [
    Quiz(question: 'What is the main limitation of raw function pointers vs std::function?', options: [
      QuizOption(text: 'Raw function pointers cannot store lambdas that capture variables', correct: true),
      QuizOption(text: 'Raw function pointers cannot be stored in arrays', correct: false),
      QuizOption(text: 'Raw function pointers only work with void return types', correct: false),
      QuizOption(text: 'Raw function pointers require virtual functions', correct: false),
    ]),
    Quiz(question: 'Which syntax correctly declares a pointer to a function taking two ints and returning int?', options: [
      QuizOption(text: 'int (*fp)(int, int)', correct: true),
      QuizOption(text: 'int* fp(int, int)', correct: false),
      QuizOption(text: 'int fp*(int, int)', correct: false),
      QuizOption(text: 'pointer<int(int,int)> fp', correct: false),
    ]),
    Quiz(question: 'What is std::function useful for that raw function pointers cannot do?', options: [
      QuizOption(text: 'Storing lambdas with captures, member functions, and functors uniformly', correct: true),
      QuizOption(text: 'Calling functions faster at runtime', correct: false),
      QuizOption(text: 'Pointing to functions in external libraries', correct: false),
      QuizOption(text: 'Storing multiple functions in a single variable', correct: false),
    ]),
  ],
);
