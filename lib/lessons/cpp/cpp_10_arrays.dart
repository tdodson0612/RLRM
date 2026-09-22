// lib/lessons/cpp/cpp_10_arrays.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson10 = Lesson(
  language: 'C++',
  title: 'Arrays',
  content: '''
🎯 METAPHOR:
An array is like a row of numbered mailboxes.
Each mailbox (element) holds exactly one item of the same type.
They are numbered starting at 0 (not 1!), and to access
a mailbox you just say its number: mailbox[3].
The entire row is reserved at once — you can't add more
mailboxes in the middle of the building.

📖 EXPLANATION:
A C-style array is a fixed-size, contiguous block of memory
holding elements of the same type. Once declared, the size
cannot change.

C++ also has std::array (fixed) and std::vector (dynamic) —
prefer those in modern C++. But understanding raw arrays
is essential for understanding how memory works.

─────────────────────────────────────
ARRAY BASICS:
─────────────────────────────────────
type name[size];             declare
type name[size] = {values};  declare + initialize
name[index]                  access element
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <array>    // for std::array
#include <vector>   // for std::vector

int main() {
    // C-style array
    int scores[5] = {95, 87, 92, 78, 88};

    std::cout << scores[0] << std::endl;  // 95 (first element)
    std::cout << scores[4] << std::endl;  // 88 (last element)

    scores[2] = 99;  // modify element at index 2

    // Iterate with for loop
    for (int i = 0; i < 5; i++) {
        std::cout << scores[i] << " ";
    }

    // Range-based for (cleaner)
    for (auto s : scores) {
        std::cout << s << " ";
    }

    // MULTIDIMENSIONAL ARRAY (grid / matrix)
    int grid[3][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };
    std::cout << grid[1][2] << std::endl;  // 6 (row 1, col 2)

    // std::array — C++11, safer than raw arrays
    std::array<int, 5> arr = {10, 20, 30, 40, 50};
    std::cout << arr.size() << std::endl;  // 5
    std::cout << arr.at(2) << std::endl;   // 30 (bounds checked!)

    // std::vector — dynamic size, preferred in modern C++
    std::vector<int> v = {1, 2, 3};
    v.push_back(4);             // add element
    std::cout << v.size();      // 4

    return 0;
}

─────────────────────────────────────
C-ARRAY vs std::array vs std::vector:
─────────────────────────────────────
C array       fixed size, no bounds check, raw pointer
std::array    fixed size, bounds check (.at()), size()
std::vector   dynamic size, bounds check, preferred
─────────────────────────────────────

📝 KEY POINTS:
✅ Arrays are zero-indexed — first element is [0]
✅ Last valid index is size - 1
✅ Use std::array for fixed-size arrays in modern C++
✅ Use std::vector when size may change
✅ arr.at(i) throws an exception on out-of-bounds; arr[i] does not
❌ Accessing out of bounds (arr[10] on a size-5 array) is undefined behavior
❌ C-arrays don't know their own size — pass the size separately
❌ Don't use C-style arrays in new code — prefer std::array or vector
''',
  quiz: [
    Quiz(question: 'What index does the first element of an array have?', options: [
      QuizOption(text: '0', correct: true),
      QuizOption(text: '1', correct: false),
      QuizOption(text: '-1', correct: false),
      QuizOption(text: 'It depends on declaration', correct: false),
    ]),
    Quiz(question: 'What is the advantage of std::array over a C-style array?', options: [
      QuizOption(text: 'It knows its own size and supports bounds-checked access with .at()', correct: true),
      QuizOption(text: 'It can grow dynamically', correct: false),
      QuizOption(text: 'It uses less memory', correct: false),
      QuizOption(text: 'It is faster than C-arrays', correct: false),
    ]),
    Quiz(question: 'Which container should you use when the number of elements can change?', options: [
      QuizOption(text: 'std::vector', correct: true),
      QuizOption(text: 'C-style array', correct: false),
      QuizOption(text: 'std::array', correct: false),
      QuizOption(text: 'int[]', correct: false),
    ]),
  ],
);
