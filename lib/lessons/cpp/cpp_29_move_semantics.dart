// lib/lessons/cpp/cpp_29_move_semantics.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson29 = Lesson(
  language: 'C++',
  title: 'Move Semantics and Rvalue References',
  content: '''
🎯 METAPHOR:
Imagine moving out of an apartment.
Copying is like hiring movers to DUPLICATE every piece of
furniture — you keep your apartment fully furnished AND
the new place gets copies. Expensive and wasteful.
Moving is like actually MOVING your furniture — the old
apartment is now empty, the new one has everything.
Fast and efficient, no duplication.
Move semantics let C++ "move" resources instead of copying them.

📖 EXPLANATION:
Before C++11: everything was copied. Passing a vector to a
function? Copy all its elements. Return a string from a function?
Copy it. This was incredibly wasteful.

C++11 introduced MOVE SEMANTICS:
  - rvalue reference (&&) — can bind to temporary objects
  - Move constructor — takes ownership of another object's resources
  - Move assignment — transfers resources instead of copying

─────────────────────────────────────
LVALUE vs RVALUE:
─────────────────────────────────────
lvalue  → has a name, has a persistent address
          int x = 5;  (x is an lvalue)
rvalue  → temporary, no name, no persistent address
          5 + 3, std::string("hello"), the result of a function
─────────────────────────────────────

std::move() — cast an lvalue to an rvalue
  Tells the compiler: "I don't need this anymore, steal its guts"

💻 CODE:
#include <iostream>
#include <string>
#include <vector>

class Buffer {
public:
    int* data;
    size_t size;

    // Regular constructor
    Buffer(size_t s) : size(s), data(new int[s]) {
        std::cout << "Constructed (" << size << ")" << std::endl;
    }

    // Copy constructor — expensive! allocates new memory
    Buffer(const Buffer& other) : size(other.size), data(new int[other.size]) {
        std::copy(other.data, other.data + size, data);
        std::cout << "Copied (" << size << ")" << std::endl;
    }

    // Move constructor — cheap! just steal the pointer
    Buffer(Buffer&& other) noexcept
        : size(other.size), data(other.data) {
        other.data = nullptr;  // leave source in valid empty state
        other.size = 0;
        std::cout << "Moved (" << size << ")" << std::endl;
    }

    // Move assignment operator
    Buffer& operator=(Buffer&& other) noexcept {
        if (this != &other) {
            delete[] data;          // free existing resources
            data = other.data;      // steal
            size = other.size;
            other.data = nullptr;
            other.size = 0;
        }
        return *this;
    }

    ~Buffer() { delete[] data; }
};

Buffer makeBuffer(size_t s) {
    Buffer b(s);
    return b;  // move semantics kick in here (RVO / NRVO)
}

int main() {
    Buffer b1(100);              // Constructed
    Buffer b2 = b1;              // Copied (expensive)
    Buffer b3 = std::move(b1);  // Moved (cheap!) — b1 is now empty

    // b1.data is now nullptr — don't use b1 after move!

    // Practical use: adding to vector without copying
    std::vector<std::string> names;
    std::string name = "Alice";
    names.push_back(name);            // copies "Alice"
    names.push_back(std::move(name)); // moves "Alice" — name is now ""

    // Return value — compiler uses move or RVO automatically
    Buffer b4 = makeBuffer(50);      // Moved or RVO-optimized

    return 0;
}

─────────────────────────────────────
RULE OF FIVE (modern C++):
─────────────────────────────────────
If you define ANY of these, define ALL five:
  1. Destructor
  2. Copy constructor
  3. Copy assignment operator
  4. Move constructor
  5. Move assignment operator
─────────────────────────────────────

📝 KEY POINTS:
✅ Move semantics eliminate expensive copies of large objects
✅ std::move() is a cast — it enables moving but doesn't guarantee it
✅ After moving FROM an object, leave it in a valid but empty state
✅ noexcept on move operations lets STL containers optimize
✅ The compiler often applies RVO (Return Value Optimization) automatically
❌ Don't use an object after std::move() — it is in an unspecified state
❌ Don't move const objects — the move degrades to a copy
''',
  quiz: [
    Quiz(question: 'What is the key difference between a copy constructor and a move constructor?', options: [
      QuizOption(text: 'Copy allocates new memory; move steals the source object\'s resources', correct: true),
      QuizOption(text: 'Move makes a deep copy; copy makes a shallow copy', correct: false),
      QuizOption(text: 'Copy is for lvalues; move is only for pointers', correct: false),
      QuizOption(text: 'They are identical in behavior', correct: false),
    ]),
    Quiz(question: 'What does std::move() actually do?', options: [
      QuizOption(text: 'Casts an lvalue to an rvalue reference, enabling move semantics', correct: true),
      QuizOption(text: 'Physically moves data in memory', correct: false),
      QuizOption(text: 'Deletes the source object', correct: false),
      QuizOption(text: 'Copies the object to a new location', correct: false),
    ]),
    Quiz(question: 'What state should an object be in after being moved from?', options: [
      QuizOption(text: 'A valid but unspecified (empty) state — safe to destroy but not use', correct: true),
      QuizOption(text: 'Exactly the same state as before the move', correct: false),
      QuizOption(text: 'Deleted — the object no longer exists', correct: false),
      QuizOption(text: 'Filled with zeros', correct: false),
    ]),
  ],
);
