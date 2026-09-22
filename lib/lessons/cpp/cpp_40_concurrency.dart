// lib/lessons/cpp/cpp_40_concurrency.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson40 = Lesson(
  language: 'C++',
  title: 'Concurrency and Threads',
  content: '''
🎯 METAPHOR:
A single-threaded program is like one chef in a kitchen.
They chop the vegetables, then boil the water, then stir
the sauce — one task at a time. Multi-threading is like
hiring a full kitchen crew. One chef chops, another boils,
another stirs — all at the same time. The meal gets done
faster, BUT they need to communicate and not reach for the
same knife at the same moment. That coordination is the
hard part of concurrency.

📖 EXPLANATION:
C++11 introduced a portable threading library in <thread>.

Key components:
  std::thread       — create and run a thread
  std::mutex        — mutual exclusion lock
  std::lock_guard   — RAII mutex lock
  std::unique_lock  — flexible mutex lock
  std::atomic<T>    — lock-free thread-safe variable
  std::future       — get a result from async work
  std::async        — run a function asynchronously

─────────────────────────────────────
THREAD SAFETY PROBLEMS:
─────────────────────────────────────
Race condition  → two threads read/write same data simultaneously
Deadlock        → two threads each wait for the other to unlock
Data corruption → non-atomic operations on shared data
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <thread>
#include <mutex>
#include <atomic>
#include <future>
#include <vector>

std::mutex coutMutex;  // protect cout from interleaved output

void printNumbers(int id, int count) {
    for (int i = 0; i < count; i++) {
        std::lock_guard<std::mutex> lock(coutMutex);
        std::cout << "Thread " << id << ": " << i << std::endl;
    }
}

// Shared counter — UNSAFE without protection
int unsafeCounter = 0;

// Safe version using atomic
std::atomic<int> safeCounter{0};

void incrementUnsafe(int times) {
    for (int i = 0; i < times; i++) unsafeCounter++;  // race condition!
}

void incrementSafe(int times) {
    for (int i = 0; i < times; i++) safeCounter++;    // atomic — safe
}

// Return value from thread using future
int computeSum(int n) {
    int sum = 0;
    for (int i = 1; i <= n; i++) sum += i;
    return sum;
}

int main() {
    // ─── BASIC THREADS ───
    std::thread t1(printNumbers, 1, 3);
    std::thread t2(printNumbers, 2, 3);

    t1.join();  // wait for t1 to finish
    t2.join();  // wait for t2 to finish

    // ─── LAMBDA IN THREAD ───
    std::thread t3([]() {
        std::lock_guard<std::mutex> lock(coutMutex);
        std::cout << "Lambda thread running" << std::endl;
    });
    t3.join();

    // ─── ATOMIC COUNTER ───
    std::vector<std::thread> threads;
    for (int i = 0; i < 10; i++) {
        threads.emplace_back(incrementSafe, 1000);
    }
    for (auto& t : threads) t.join();
    std::cout << "Safe counter: " << safeCounter << std::endl;  // 10000

    // ─── FUTURE / ASYNC ───
    // Run computeSum in background thread, get result later
    std::future<int> result = std::async(std::launch::async, computeSum, 100);

    // Do other work here while computeSum runs...
    std::cout << "Computing in background..." << std::endl;

    // Block until result is ready
    std::cout << "Sum 1-100 = " << result.get() << std::endl;  // 5050

    // ─── MULTIPLE FUTURES ───
    auto f1 = std::async(std::launch::async, computeSum, 100);
    auto f2 = std::async(std::launch::async, computeSum, 1000);
    std::cout << f1.get() + f2.get() << std::endl;  // 5050 + 500500

    return 0;
}

// Compile with: g++ -std=c++17 main.cpp -pthread -o program

─────────────────────────────────────
MUTEX USAGE PATTERN:
─────────────────────────────────────
std::mutex mtx;
void safeFunction() {
    std::lock_guard<std::mutex> lock(mtx);  // locks here
    // ... critical section ...
}  // unlocks automatically here (RAII)
─────────────────────────────────────

📝 KEY POINTS:
✅ Always join() or detach() every thread — forgetting causes std::terminate
✅ Use std::atomic for simple counters/flags — no mutex needed
✅ Use std::lock_guard for RAII mutex locking — never forget to unlock
✅ std::async is the easiest way to run work in background
✅ Compile with -pthread on Linux/Mac
❌ Never access shared data from multiple threads without protection
❌ Never lock the same non-recursive mutex twice — deadlock
❌ Don't detach threads that access local variables — they may outlive the scope
''',
  quiz: [
    Quiz(question: 'What is a race condition?', options: [
      QuizOption(text: 'When two threads access shared data simultaneously with at least one writing', correct: true),
      QuizOption(text: 'When two threads run at exactly the same speed', correct: false),
      QuizOption(text: 'When a thread finishes before another thread starts', correct: false),
      QuizOption(text: 'When std::async runs before the main thread', correct: false),
    ]),
    Quiz(question: 'What is the advantage of std::atomic over using a mutex for a counter?', options: [
      QuizOption(text: 'Atomic operations are lock-free and have lower overhead', correct: true),
      QuizOption(text: 'Atomic variables can hold any type', correct: false),
      QuizOption(text: 'Atomic is only available in C++20', correct: false),
      QuizOption(text: 'Atomic prevents deadlocks in all situations', correct: false),
    ]),
    Quiz(question: 'What does std::future::get() do?', options: [
      QuizOption(text: 'Blocks until the async result is ready, then returns it', correct: true),
      QuizOption(text: 'Immediately returns the result or throws if not ready', correct: false),
      QuizOption(text: 'Cancels the async operation', correct: false),
      QuizOption(text: 'Returns a copy of the future', correct: false),
    ]),
  ],
);
