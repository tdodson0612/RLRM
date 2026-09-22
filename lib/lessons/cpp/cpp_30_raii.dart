// lib/lessons/cpp/cpp_30_raii.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson30 = Lesson(
  language: 'C++',
  title: 'RAII: Resource Acquisition Is Initialization',
  content: '''
🎯 METAPHOR:
RAII is like a hotel key card system.
When you check in (constructor), you get the key — access
to your room, the gym, the pool. When you check out
(destructor), the key is automatically deactivated —
all your access is revoked. You can't forget to return it.
RAII ties the LIFETIME of a resource to the LIFETIME of
an object. When the object dies, the resource is released.
Automatic, guaranteed, no manual cleanup required.

📖 EXPLANATION:
RAII is C++'s most important idiom. The idea:
  - Acquire a resource in the CONSTRUCTOR
  - Release it in the DESTRUCTOR
  - Since destructors are always called (even when exceptions throw),
    resources are ALWAYS properly released

Resources that RAII manages:
  - Heap memory (smart pointers)
  - File handles (fstream)
  - Mutex locks (lock_guard)
  - Network connections
  - Database connections
  - Any acquired/released resource

WITHOUT RAII: you manually call delete, close(), unlock()
  → you'll forget one day, or an exception will skip it

WITH RAII: cleanup is AUTOMATIC. No leaks possible.

💻 CODE:
#include <iostream>
#include <fstream>
#include <mutex>
#include <memory>

// ─── CUSTOM RAII WRAPPER ───
class FileHandle {
    FILE* handle;
public:
    FileHandle(const char* filename, const char* mode) {
        handle = fopen(filename, mode);
        if (!handle) throw std::runtime_error("Cannot open file");
        std::cout << "File opened" << std::endl;
    }

    ~FileHandle() {
        if (handle) {
            fclose(handle);
            std::cout << "File closed automatically" << std::endl;
        }
    }

    // Delete copy — resource should not be duplicated
    FileHandle(const FileHandle&) = delete;
    FileHandle& operator=(const FileHandle&) = delete;

    FILE* get() { return handle; }
};

// ─── RAII TIMER ───
#include <chrono>
class Timer {
    std::chrono::time_point<std::chrono::high_resolution_clock> start;
    std::string name;
public:
    Timer(std::string n) : name(n) {
        start = std::chrono::high_resolution_clock::now();
        std::cout << name << " started" << std::endl;
    }
    ~Timer() {
        auto end = std::chrono::high_resolution_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>
                        (end - start).count();
        std::cout << name << " took " << duration << " microseconds" << std::endl;
    }
};

// ─── MUTEX RAII ───
std::mutex mtx;

void safeFunction() {
    std::lock_guard<std::mutex> lock(mtx);  // locks on construction
    // ... do work ...
    std::cout << "Working with locked mutex" << std::endl;
    // lock released automatically when lock_guard goes out of scope
    // even if an exception is thrown!
}

int main() {
    // Smart pointer RAII — most common form
    {
        auto ptr = std::make_unique<int>(42);
        std::cout << *ptr << std::endl;
        // ptr deleted automatically when scope ends
    }

    // File RAII
    {
        FileHandle f("test.txt", "w");
        fprintf(f.get(), "Hello RAII\\n");
        // file closed automatically — even if fprintf throws
    }

    // Timer RAII
    {
        Timer t("loop");
        int sum = 0;
        for (int i = 0; i < 1000000; i++) sum += i;
        std::cout << "Sum: " << sum << std::endl;
    }  // timer reports time here

    // Mutex RAII
    safeFunction();

    return 0;
}

─────────────────────────────────────
RAII IN THE STANDARD LIBRARY:
─────────────────────────────────────
unique_ptr / shared_ptr   → memory
fstream                   → file handles
lock_guard / unique_lock  → mutex locks
jthread (C++20)           → threads
─────────────────────────────────────

📝 KEY POINTS:
✅ RAII is the single most important C++ idiom — learn it deeply
✅ Destructors always run — even when exceptions are thrown
✅ Tie every resource to an object's lifetime
✅ Delete copy constructor/assignment for non-copyable resources
✅ The standard library is built on RAII throughout
❌ Don't manage resources manually when a RAII wrapper exists
❌ RAII fails if you catch exceptions and re-use a "moved-from" object
''',
  quiz: [
    Quiz(question: 'What is the core idea of RAII?', options: [
      QuizOption(text: 'Tie resource lifetime to object lifetime — acquire in constructor, release in destructor', correct: true),
      QuizOption(text: 'Always use raw pointers for performance', correct: false),
      QuizOption(text: 'Allocate all resources at program start and free at end', correct: false),
      QuizOption(text: 'Use try/finally to ensure cleanup', correct: false),
    ]),
    Quiz(question: 'Why does RAII work even when exceptions are thrown?', options: [
      QuizOption(text: 'Destructors are always called when a scope exits, including due to exceptions', correct: true),
      QuizOption(text: 'RAII catches all exceptions internally', correct: false),
      QuizOption(text: 'Exceptions cannot occur inside RAII classes', correct: false),
      QuizOption(text: 'The compiler inserts cleanup code at exception points', correct: false),
    ]),
    Quiz(question: 'What does std::lock_guard demonstrate about RAII?', options: [
      QuizOption(text: 'It locks a mutex on construction and unlocks automatically on destruction', correct: true),
      QuizOption(text: 'It is a global lock for all threads', correct: false),
      QuizOption(text: 'It prevents RAII from being used with threads', correct: false),
      QuizOption(text: 'It allocates memory for thread-safe operations', correct: false),
    ]),
  ],
);
