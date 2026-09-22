// lib/lessons/cpp/cpp_56_copy_elision_rvo.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson56 = Lesson(
  language: 'C++',
  title: 'Copy Elision, RVO, and NRVO',
  content: '''
🎯 METAPHOR:
Imagine ordering a cake from a bakery. Normally you might
expect the baker to bake it in the back, bring it to the
counter, then you carry it to your car — three locations,
two transfers. RVO (Return Value Optimization) is the baker
saying: "I'll just bake it directly in your car's trunk."
No transfers at all. Zero copies made, even though the code
looks like there should be one. The compiler is smarter
than your naive reading of the code.

📖 EXPLANATION:
COPY ELISION: the compiler is allowed (and in C++17, REQUIRED
in certain cases) to eliminate unnecessary copy/move operations.

RVO — Return Value Optimization:
  When a function returns a temporary object, the compiler
  constructs it DIRECTLY in the caller's storage.
  No copy, no move — the object is built in place.

NRVO — Named Return Value Optimization:
  Same as RVO but for named (non-temporary) local variables.
  Not guaranteed — compiler applies it when possible.

C++17 MANDATORY COPY ELISION (prvalue elision):
  When returning a temporary or constructing from a temporary,
  the compiler MUST elide the copy. No move constructor needed.

💻 CODE:
#include <iostream>

class Heavy {
public:
    int* data;
    size_t size;

    Heavy(size_t s) : size(s), data(new int[s]) {
        std::cout << "Constructed (" << size << ")" << std::endl;
    }

    Heavy(const Heavy& other) : size(other.size), data(new int[other.size]) {
        std::copy(other.data, other.data + size, data);
        std::cout << "COPIED (" << size << ")" << std::endl;
    }

    Heavy(Heavy&& other) noexcept : size(other.size), data(other.data) {
        other.data = nullptr;
        other.size = 0;
        std::cout << "MOVED (" << size << ")" << std::endl;
    }

    ~Heavy() {
        delete[] data;
        std::cout << "Destroyed" << std::endl;
    }
};

// RVO — compiler builds Heavy directly in caller's memory
Heavy makeHeavy(size_t s) {
    return Heavy(s);  // temporary — RVO applies, no copy or move
}

// NRVO — named variable, compiler may elide the copy
Heavy makeHeavyNamed(size_t s) {
    Heavy h(s);       // named local variable
    return h;         // NRVO likely applies — usually no copy/move
}

// When NRVO may NOT apply (multiple return paths)
Heavy maybeHeavy(bool flag, size_t s) {
    Heavy a(s);
    Heavy b(s * 2);
    if (flag) return a;  // compiler may not NRVO — two possible returns
    return b;
}

int main() {
    std::cout << "=== RVO ===" << std::endl;
    Heavy h1 = makeHeavy(10);
    // Output: Constructed (10)
    // NO copy, NO move — built directly in h1's space

    std::cout << "=== NRVO ===" << std::endl;
    Heavy h2 = makeHeavyNamed(20);
    // Output: Constructed (20)
    // Likely: no copy or move — NRVO applied

    std::cout << "=== Direct init ===" << std::endl;
    Heavy h3(30);           // Constructed (30) — no copies at all

    std::cout << "=== Assignment ===" << std::endl;
    Heavy h4(5);
    h4 = makeHeavy(5);      // Constructed + MOVED (assignment, not construction)

    std::cout << "=== C++17 Mandatory elision ===" << std::endl;
    // This is GUARANTEED to not copy or move in C++17:
    Heavy h5 = Heavy(40);   // Constructed (40) — mandatory elision
    // Even if Heavy had no copy or move constructor, this still works!

    return 0;
}

─────────────────────────────────────
PRACTICAL RULES:
─────────────────────────────────────
✅ Return objects by value from functions — trust RVO/NRVO
❌ Do NOT std::move a return value — it PREVENTS RVO!
   return std::move(h);   // WRONG — disables NRVO, forces a move
   return h;              // RIGHT — allows NRVO to eliminate all copies
─────────────────────────────────────

─────────────────────────────────────
WHAT THIS MEANS FOR YOU:
─────────────────────────────────────
Don't fear returning objects by value from functions.
The compiler eliminates the copy in virtually all
real-world cases. Modern C++ return-by-value is NOT slow.
─────────────────────────────────────

📝 KEY POINTS:
✅ Trust the compiler — return objects by value, RVO handles it
✅ C++17 guarantees copy elision for prvalue (temporary) returns
✅ NRVO is not guaranteed but applied by all major compilers in simple cases
✅ Returning by value is idiomatic modern C++ — not a performance problem
❌ Never write "return std::move(local_var)" — it disables NRVO
❌ Don't try to "optimize" returns with pointers/refs when value return is fine
''',
  quiz: [
    Quiz(question: 'What does RVO (Return Value Optimization) do?', options: [
      QuizOption(text: 'Constructs the return value directly in the caller\'s memory — no copy or move needed', correct: true),
      QuizOption(text: 'Moves the return value instead of copying it', correct: false),
      QuizOption(text: 'Caches return values to avoid recomputing them', correct: false),
      QuizOption(text: 'Optimizes the return type to use less memory', correct: false),
    ]),
    Quiz(question: 'Why should you NOT write "return std::move(localVar)" in a function?', options: [
      QuizOption(text: 'It disables NRVO — forcing a move where the compiler could have elided it entirely', correct: true),
      QuizOption(text: 'std::move is not allowed in return statements', correct: false),
      QuizOption(text: 'It causes a dangling reference', correct: false),
      QuizOption(text: 'It prevents the destructor from running', correct: false),
    ]),
    Quiz(question: 'In C++17, when is copy elision MANDATORY?', options: [
      QuizOption(text: 'When returning or initializing from a prvalue (temporary) of the same type', correct: true),
      QuizOption(text: 'Whenever a named local variable is returned', correct: false),
      QuizOption(text: 'Only when the move constructor is noexcept', correct: false),
      QuizOption(text: 'Only when the -O2 optimization flag is used', correct: false),
    ]),
  ],
);
