// lib/lessons/cpp/cpp_44_standard_library_overview.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson44 = Lesson(
  language: 'C++',
  title: 'Standard Library Overview',
  content: '''
🎯 METAPHOR:
The C++ Standard Library is like the tools that come with
a professional workshop. You could build every tool from
scratch — forge your own hammer, wind your own wire, grind
your own gears. But why? The standard library gives you
battle-tested, highly optimized tools for almost every
common task. Knowing what is available is half the battle.
A professional reaches for the right tool. An amateur
rewrites the wheel.

📖 EXPLANATION:
The C++ Standard Library is organized into categories.
Here is the complete map so you know where to look.

─────────────────────────────────────
CONTAINERS      <vector> <list> <deque>
                <map> <unordered_map>
                <set> <unordered_set>
                <stack> <queue>
                <array> <forward_list>

ALGORITHMS      <algorithm>    sort, find, count, transform...
                <numeric>      accumulate, iota, inner_product...

STRINGS         <string>       std::string
                <string_view>  std::string_view (C++17)
                <regex>        regular expressions
                <sstream>      string streams

I/O             <iostream>     cin, cout, cerr
                <fstream>      file streams
                <iomanip>      setw, setprecision, fixed

MEMORY          <memory>       unique_ptr, shared_ptr, allocator
                <new>          operator new/delete

UTILITIES       <utility>      pair, move, forward, swap
                <tuple>        tuple, get, tie
                <optional>     std::optional (C++17)
                <variant>      std::variant  (C++17)
                <any>          std::any      (C++17)
                <functional>   function, bind, less, greater
                <type_traits>  is_integral, is_same...

MATH            <cmath>        sin, cos, sqrt, pow, abs, floor...
                <cstdlib>      rand, abs, exit, atoi...
                <numeric>      gcd, lcm (C++17)
                <numbers>      pi, e constants (C++20)
                <complex>      complex numbers
                <random>       modern random number generation

TIME            <chrono>       high_resolution_clock, duration
                <ctime>        C-style time functions

CONCURRENCY     <thread>       std::thread
                <mutex>        mutex, lock_guard, unique_lock
                <atomic>       std::atomic
                <future>       async, future, promise
                <condition_variable>

EXCEPTIONS      <stdexcept>    runtime_error, logic_error...
                <exception>    base exception class

FILESYSTEM      <filesystem>   path, directory_iterator (C++17)
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <random>
#include <chrono>
#include <filesystem>
#include <numbers>    // C++20
#include <numeric>

int main() {
    // ─── RANDOM (modern way — not rand()!) ───
    std::random_device rd;               // true random seed
    std::mt19937 gen(rd());              // Mersenne Twister generator
    std::uniform_int_distribution<> dis(1, 6);  // dice: 1-6

    for (int i = 0; i < 5; i++) {
        std::cout << dis(gen) << " ";    // random dice rolls
    }
    std::cout << std::endl;

    // Normal distribution
    std::normal_distribution<double> normal(0.0, 1.0);
    std::cout << normal(gen) << std::endl;

    // ─── CHRONO ───
    auto start = std::chrono::high_resolution_clock::now();

    long sum = 0;
    for (int i = 0; i < 1000000; i++) sum += i;

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    std::cout << "Time: " << duration.count() << " us" << std::endl;

    // ─── FILESYSTEM (C++17) ───
    namespace fs = std::filesystem;

    fs::path p = fs::current_path();
    std::cout << "Current dir: " << p << std::endl;

    // List files in current directory
    for (const auto& entry : fs::directory_iterator(".")) {
        std::cout << entry.path().filename() << std::endl;
    }

    // ─── NUMERIC ───
    std::cout << std::gcd(24, 36) << std::endl;   // 12
    std::cout << std::lcm(4, 6) << std::endl;     // 12

    std::vector<int> v(10);
    std::iota(v.begin(), v.end(), 1);  // fill with 1, 2, 3, ..., 10
    for (auto x : v) std::cout << x << " ";

    // ─── MATH ───
    #include <cmath>
    std::cout << std::sqrt(144) << std::endl;  // 12
    std::cout << std::pow(2, 10) << std::endl; // 1024
    std::cout << std::abs(-42) << std::endl;   // 42
    std::cout << std::floor(3.7) << std::endl; // 3
    std::cout << std::ceil(3.2) << std::endl;  // 4

    return 0;
}

📝 KEY POINTS:
✅ Know the standard library — don't reinvent it
✅ Use <random> over rand() — it is vastly more correct and flexible
✅ Use <chrono> for timing — portable and precise
✅ Use <filesystem> (C++17) for file system operations
✅ std::iota fills a range with incrementing values
❌ Never use rand() in serious code — the distribution is poor
❌ Don't use ctime for anything precision-sensitive — use chrono
''',
  quiz: [
    Quiz(question: 'Which header provides modern random number generation in C++?', options: [
      QuizOption(text: '<random>', correct: true),
      QuizOption(text: '<cstdlib> with rand()', correct: false),
      QuizOption(text: '<math>', correct: false),
      QuizOption(text: '<utility>', correct: false),
    ]),
    Quiz(question: 'What does std::iota do?', options: [
      QuizOption(text: 'Fills a range with sequentially incrementing values', correct: true),
      QuizOption(text: 'Computes the sum of a range', correct: false),
      QuizOption(text: 'Finds the index of a value', correct: false),
      QuizOption(text: 'Converts a range to a string', correct: false),
    ]),
    Quiz(question: 'Which C++ standard introduced the <filesystem> library?', options: [
      QuizOption(text: 'C++17', correct: true),
      QuizOption(text: 'C++11', correct: false),
      QuizOption(text: 'C++14', correct: false),
      QuizOption(text: 'C++20', correct: false),
    ]),
  ],
);
