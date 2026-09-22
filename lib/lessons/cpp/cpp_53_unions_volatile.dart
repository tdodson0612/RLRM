// lib/lessons/cpp/cpp_53_unions_volatile.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson53 = Lesson(
  language: 'C++',
  title: 'Unions, volatile, and mutable',
  content: '''
🎯 METAPHOR:
A union is like a parking spot that can hold a car, a
motorcycle, or a bicycle — but only ONE at a time. All
three share the same space. The spot is sized for the
largest vehicle. You must remember which vehicle is
currently parked there — the spot itself won't tell you.

volatile is like a live stock ticker on the wall.
The compiler normally caches values in registers — it
assumes "if I just read this, it hasn't changed."
volatile says "always re-read this from memory — something
outside my control could have changed it." Hardware registers,
signals, and shared memory need this.

mutable is the one exception to const — it says "this
specific member is allowed to change even on a const object."
Like a notepad a librarian keeps for indexing purposes —
the book collection (object) is read-only to patrons,
but the librarian's notes (mutable member) can still be updated.

📖 EXPLANATION:
These three keywords are lower-level or specialized.
You will see them in real codebases. Know what they mean.

─────────────────────────────────────
UNION:
─────────────────────────────────────
All members share the same memory location.
Size = size of the LARGEST member.
Only ONE member is valid at a time.
Useful for: memory-efficient type variants, hardware registers,
binary protocol parsing.
Prefer std::variant (C++17) when type safety matters.

VOLATILE:
  Prevents compiler from caching the value in a register.
  Used for: hardware memory-mapped registers, signal handlers,
  setjmp/longjmp code. NOT a substitute for thread synchronization.

MUTABLE:
  Allows a member to be modified even through a const object.
  Used for: lazy caching, mutexes inside const methods.
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <cstdint>
#include <mutex>

// ─── UNION ───
union Data {
    int    i;
    float  f;
    char   bytes[4];
};

// Tagged union — tracks which member is active
struct TaggedData {
    enum class Type { INT, FLOAT, CHAR };
    Type activeType;

    union {
        int   i;
        float f;
        char  c;
    };
};

// ─── VOLATILE ───
// Simulates a hardware register that can change externally
volatile int hardwareStatus = 0;

void checkStatus() {
    // WITHOUT volatile: compiler might optimize this to check once
    // WITH volatile: re-reads from memory every loop iteration
    while (hardwareStatus == 0) {
        // wait for hardware to set status
        // in real code this would be a hardware register
    }
    std::cout << "Status changed to: " << hardwareStatus << std::endl;
}

// ─── MUTABLE ───
class Cache {
    std::string data;
    mutable std::string cachedUpper;  // allowed to change on const object
    mutable bool cacheValid = false;
    mutable std::mutex mtx;           // mutable so lock() works on const objects

public:
    Cache(std::string d) : data(d) {}

    // const method — but we can still update the cache
    std::string getUpper() const {
        if (!cacheValid) {
            std::lock_guard<std::mutex> lock(mtx);
            cachedUpper = data;
            for (char& c : cachedUpper) c = std::toupper(c);
            cacheValid = true;
            std::cout << "(computing...)" << std::endl;
        }
        return cachedUpper;
    }
};

int main() {
    // ─── UNION ───
    Data d;
    d.i = 42;
    std::cout << "int: " << d.i << std::endl;

    d.f = 3.14f;  // now float is active — int value is garbage
    std::cout << "float: " << d.f << std::endl;
    // std::cout << d.i;  // technically undefined behavior (reading wrong member)

    // Raw bytes inspection
    d.i = 0x41424344;  // 'ABCD' in ASCII
    std::cout << d.bytes[0] << d.bytes[1]
              << d.bytes[2] << d.bytes[3] << std::endl;  // DCBA (little-endian)

    // Tagged union
    TaggedData td;
    td.activeType = TaggedData::Type::FLOAT;
    td.f = 2.718f;
    if (td.activeType == TaggedData::Type::FLOAT) {
        std::cout << "Float: " << td.f << std::endl;
    }

    // ─── VOLATILE ───
    // (cannot demonstrate live hardware here, but show the concept)
    volatile int flag = 1;
    // Compiler MUST re-read flag each iteration — no optimization
    while (flag) {
        flag = 0;  // would be set by interrupt in real code
    }
    std::cout << "Flag cleared" << std::endl;

    // ─── MUTABLE ───
    const Cache cache("hello world");
    std::cout << cache.getUpper() << std::endl;  // (computing...) HELLO WORLD
    std::cout << cache.getUpper() << std::endl;  // HELLO WORLD (cached)

    return 0;
}

📝 KEY POINTS:
✅ Union members share memory — only one is valid at a time
✅ Always track which union member is active (tagged union pattern)
✅ Prefer std::variant over raw unions for type-safe alternatives
✅ volatile prevents optimization, not data races — use atomic for threads
✅ mutable enables lazy evaluation and caching in const methods
❌ Reading the "wrong" union member is undefined behavior
❌ volatile is NOT a replacement for std::atomic in multithreaded code
❌ Don't overuse mutable — it undermines const correctness if abused
''',
  quiz: [
    Quiz(question: 'What is the size of a union?', options: [
      QuizOption(text: 'The size of its largest member', correct: true),
      QuizOption(text: 'The sum of all member sizes', correct: false),
      QuizOption(text: 'The size of its smallest member', correct: false),
      QuizOption(text: 'Always 8 bytes on 64-bit systems', correct: false),
    ]),
    Quiz(question: 'What does volatile tell the compiler?', options: [
      QuizOption(text: 'Always re-read this variable from memory — do not cache it in a register', correct: true),
      QuizOption(text: 'This variable is thread-safe', correct: false),
      QuizOption(text: 'This variable cannot be modified', correct: false),
      QuizOption(text: 'This variable is stored on the heap', correct: false),
    ]),
    Quiz(question: 'What does the mutable keyword allow?', options: [
      QuizOption(text: 'A member to be modified even when accessed through a const object', correct: true),
      QuizOption(text: 'A member to change its type at runtime', correct: false),
      QuizOption(text: 'A const method to call non-const methods', correct: false),
      QuizOption(text: 'A variable to be shared between threads safely', correct: false),
    ]),
  ],
);
