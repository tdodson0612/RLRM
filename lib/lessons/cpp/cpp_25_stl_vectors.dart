// lib/lessons/cpp/cpp_25_stl_vectors.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson25 = Lesson(
  language: 'C++',
  title: 'STL: Vectors',
  content: '''
🎯 METAPHOR:
A vector is like a stretchy accordion folder.
A regular array is a rigid binder — fixed slots, fixed size.
A vector starts with some capacity, and when you add more
papers than it can hold, it automatically gets a bigger
folder and moves everything over. You never have to worry
about running out of space — it handles that for you.

📖 EXPLANATION:
std::vector is the most-used container in C++.
It is a dynamic array — it grows automatically as you add elements.
Internally it manages a heap-allocated array and doubles
its capacity when it runs out of space (amortized O(1) push_back).

#include <vector>

─────────────────────────────────────
KEY VECTOR OPERATIONS:
─────────────────────────────────────
v.push_back(x)      add to end
v.pop_back()        remove from end
v.insert(it, x)     insert at iterator position
v.erase(it)         remove at iterator position
v.size()            number of elements
v.capacity()        allocated space
v.empty()           true if no elements
v.clear()           remove all elements
v.at(i)             element at i (bounds checked)
v[i]                element at i (no bounds check)
v.front()           first element
v.back()            last element
v.begin() / v.end() iterators
v.reserve(n)        pre-allocate space for n elements
v.resize(n)         set size to n (fills with default)
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    // Create and initialize
    std::vector<int> v = {5, 3, 8, 1, 9, 2};

    // Add elements
    v.push_back(7);
    v.push_back(4);

    // Access
    std::cout << v[0] << std::endl;      // 5
    std::cout << v.at(1) << std::endl;   // 3
    std::cout << v.front() << std::endl; // 5
    std::cout << v.back() << std::endl;  // 4
    std::cout << v.size() << std::endl;  // 8

    // Range-based for
    for (const auto& x : v) {
        std::cout << x << " ";
    }
    std::cout << std::endl;

    // Iterator-based for
    for (auto it = v.begin(); it != v.end(); ++it) {
        std::cout << *it << " ";
    }

    // Sort (from <algorithm>)
    std::sort(v.begin(), v.end());
    // v is now: 1 2 3 4 5 7 8 9

    // Find
    auto it = std::find(v.begin(), v.end(), 7);
    if (it != v.end()) {
        std::cout << "Found 7 at index: " << (it - v.begin()) << std::endl;
    }

    // Erase element at index 2
    v.erase(v.begin() + 2);

    // Remove last element
    v.pop_back();

    // 2D vector (vector of vectors)
    std::vector<std::vector<int>> matrix(3, std::vector<int>(3, 0));
    matrix[1][1] = 5;
    std::cout << matrix[1][1] << std::endl; // 5

    // Reserve to avoid reallocations
    std::vector<int> big;
    big.reserve(1000);  // pre-allocate, no size change yet
    for (int i = 0; i < 1000; i++) big.push_back(i);

    return 0;
}

📝 KEY POINTS:
✅ Use vector as your default container — versatile and fast
✅ reserve() avoids repeated reallocation when size is known
✅ Use at() for bounds-checked access; [] for performance-critical code
✅ push_back is amortized O(1) — occasionally triggers a reallocation
✅ Iterators can be invalidated after insert/erase — re-fetch after modifying
❌ Don't use size()-1 on an empty vector — size() returns unsigned, wraps to huge number
❌ Don't insert/erase in the middle of large vectors — O(n) operation
''',
  quiz: [
    Quiz(question: 'What does v.reserve(n) do?', options: [
      QuizOption(text: 'Pre-allocates memory for n elements without changing the size', correct: true),
      QuizOption(text: 'Sets the vector size to n and fills with zeros', correct: false),
      QuizOption(text: 'Limits the vector to at most n elements', correct: false),
      QuizOption(text: 'Removes all elements beyond index n', correct: false),
    ]),
    Quiz(question: 'What is the difference between v.size() and v.capacity()?', options: [
      QuizOption(text: 'size() is the number of elements; capacity() is the allocated space', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'capacity() is the number of elements; size() is allocated space', correct: false),
      QuizOption(text: 'size() includes null terminators; capacity() does not', correct: false),
    ]),
    Quiz(question: 'What happens internally when a vector runs out of capacity?', options: [
      QuizOption(text: 'It allocates a larger block, copies all elements, and frees the old block', correct: true),
      QuizOption(text: 'It throws an out_of_range exception', correct: false),
      QuizOption(text: 'It stops accepting new elements', correct: false),
      QuizOption(text: 'It asks the OS for one more slot at a time', correct: false),
    ]),
  ],
);
