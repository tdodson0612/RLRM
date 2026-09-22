// lib/lessons/cpp/cpp_55_noexcept_exception_safety.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson55 = Lesson(
  language: 'C++',
  title: 'noexcept and Exception Safety Guarantees',
  content: '''
🎯 METAPHOR:
noexcept is like a signed contract on a job.
"I GUARANTEE this work will not cause any problems —
you have my word in writing." If something does go wrong
anyway, the consequences are severe (std::terminate).
But the guarantee lets your employer (compiler and STL)
make important optimizations — they know no disaster
recovery plan is needed for this step.

Exception safety levels are like insurance tiers.
No guarantee: if something breaks, everything is on fire.
Basic guarantee: the building survives, but furniture may shift.
Strong guarantee: if it breaks, everything is exactly as before.
No-throw guarantee: it simply cannot break.

📖 EXPLANATION:
noexcept — declares a function will not throw exceptions.
  - Enables compiler optimizations
  - Required for move operations to be used by STL
  - If it DOES throw despite noexcept, std::terminate is called

─────────────────────────────────────
EXCEPTION SAFETY LEVELS:
─────────────────────────────────────
No guarantee       — anything can happen after a throw
Basic guarantee    — object stays in a valid (unspecified) state
Strong guarantee   — operation either fully succeeds or has no effect
                     (commit or rollback)
No-throw guarantee — function never throws (noexcept)
─────────────────────────────────────

WHY noexcept MATTERS FOR STL:
  std::vector needs to move elements during reallocation.
  If the move constructor is noexcept → vector uses move (fast).
  If NOT noexcept → vector falls back to copy (slow, safe).
  Always mark move constructors and move assignment noexcept.

💻 CODE:
#include <iostream>
#include <stdexcept>
#include <vector>

// ─── noexcept SPECIFIER ───
void safeFunction() noexcept {
    // Guarantees: this will never throw
    // If it does somehow → std::terminate() is called
    int x = 5 + 3;  // clearly safe
}

void riskyFunction() {
    throw std::runtime_error("oops");  // may throw
}

// noexcept(condition) — conditional noexcept
template<typename T>
void swap(T& a, T& b) noexcept(noexcept(T(std::move(a)))) {
    T temp = std::move(a);
    a = std::move(b);
    b = std::move(temp);
}

// ─── MOVE CONSTRUCTOR: always mark noexcept ───
class Buffer {
    int* data;
    size_t size;
public:
    Buffer(size_t s) : size(s), data(new int[s]) {}

    // noexcept move constructor — STL can use move during reallocation
    Buffer(Buffer&& other) noexcept
        : size(other.size), data(other.data) {
        other.data = nullptr;
        other.size = 0;
    }

    Buffer& operator=(Buffer&& other) noexcept {
        if (this != &other) {
            delete[] data;
            data = other.data;
            size = other.size;
            other.data = nullptr;
            other.size = 0;
        }
        return *this;
    }

    ~Buffer() { delete[] data; }
};

// ─── STRONG EXCEPTION SAFETY — copy-and-swap idiom ───
class SafeArray {
    std::vector<int> data;
public:
    SafeArray(std::vector<int> d) : data(d) {}

    // Strong guarantee via copy-and-swap:
    // 1. Copy the new data (might throw — but we haven't changed anything yet)
    // 2. Swap with current (noexcept — can't fail)
    SafeArray& operator=(SafeArray other) {  // pass by value = copy
        std::swap(data, other.data);         // swap is noexcept
        return *this;
        // old data destroyed in other's destructor
    }

    void display() const {
        for (int x : data) std::cout << x << " ";
        std::cout << std::endl;
    }
};

// ─── CHECKING noexcept AT COMPILE TIME ───
void nothrow() noexcept {}
void maythrow() {}

int main() {
    // noexcept operator — compile time check
    std::cout << std::boolalpha;
    std::cout << noexcept(nothrow()) << std::endl;   // true
    std::cout << noexcept(maythrow()) << std::endl;  // false
    std::cout << noexcept(1 + 1) << std::endl;       // true

    // Vector uses move (because Buffer's move is noexcept)
    std::vector<Buffer> buffers;
    buffers.emplace_back(100);
    buffers.emplace_back(200);
    buffers.emplace_back(300);
    // When vector reallocates, it MOVES (not copies) Buffers — fast!

    // Copy-and-swap strong guarantee
    SafeArray arr1({1, 2, 3});
    SafeArray arr2({4, 5, 6});
    arr1 = arr2;  // strong guarantee — either fully works or no change
    arr1.display();  // 4 5 6

    return 0;
}

📝 KEY POINTS:
✅ Always mark move constructors and move assignment noexcept
✅ Always mark swap() noexcept
✅ noexcept enables STL to use move instead of copy during reallocation
✅ Copy-and-swap idiom provides strong exception safety easily
✅ noexcept(expr) is a compile-time operator that checks if expr is noexcept
❌ If a noexcept function throws, std::terminate() is called — no recovery
❌ Don't mark functions noexcept just to be optimistic — be accurate
''',
  quiz: [
    Quiz(question: 'What happens if a noexcept function throws an exception?', options: [
      QuizOption(text: 'std::terminate() is called — the program ends immediately', correct: true),
      QuizOption(text: 'The exception is silently swallowed', correct: false),
      QuizOption(text: 'The noexcept specifier is ignored', correct: false),
      QuizOption(text: 'The exception propagates normally up the call stack', correct: false),
    ]),
    Quiz(question: 'Why should move constructors be marked noexcept?', options: [
      QuizOption(text: 'So std::vector uses move (not copy) when reallocating its buffer', correct: true),
      QuizOption(text: 'To prevent the move constructor from being called', correct: false),
      QuizOption(text: 'noexcept is required for all constructors in modern C++', correct: false),
      QuizOption(text: 'To allow the move constructor to call throwing functions', correct: false),
    ]),
    Quiz(question: 'What is the "strong exception safety guarantee"?', options: [
      QuizOption(text: 'An operation either fully succeeds or leaves the state exactly as before', correct: true),
      QuizOption(text: 'A function that never throws', correct: false),
      QuizOption(text: 'An object that stays valid but in an unspecified state after a throw', correct: false),
      QuizOption(text: 'A guarantee that all exceptions are caught', correct: false),
    ]),
  ],
);
