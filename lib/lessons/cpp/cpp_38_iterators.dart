// lib/lessons/cpp/cpp_38_iterators.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson38 = Lesson(
  language: 'C++',
  title: 'Iterators',
  content: '''
🎯 METAPHOR:
An iterator is like a reading cursor in a document.
The cursor knows where you are right now, lets you move
forward (or backward), and lets you read or write at the
current position. You don't need to know if the document
is stored in a file, in RAM, or on a network drive —
the cursor interface is the same. Iterators abstract
away HOW a container stores its data, giving algorithms
a uniform way to traverse anything.

📖 EXPLANATION:
An iterator is an object that points to an element inside
a container and lets you traverse the container.

─────────────────────────────────────
ITERATOR CATEGORIES:
─────────────────────────────────────
Input iterator       read-only, forward only (stream)
Output iterator      write-only, forward only
Forward iterator     read/write, forward only (forward_list)
Bidirectional        forward and backward (list, map)
Random access        jump anywhere, +/- (vector, array, deque)
─────────────────────────────────────

KEY ITERATOR OPERATIONS:
  *it          dereference (get value)
  ++it         advance to next
  --it         go back (bidirectional+)
  it + n       jump n steps (random access only)
  it1 == it2   compare iterators
  begin()      iterator to first element
  end()        iterator PAST the last element (not the last!)

💻 CODE:
#include <iostream>
#include <vector>
#include <list>
#include <algorithm>

int main() {
    std::vector<int> v = {10, 20, 30, 40, 50};

    // Iterator-based loop
    for (auto it = v.begin(); it != v.end(); ++it) {
        std::cout << *it << " ";
    }
    std::cout << std::endl;

    // Modify through iterator
    for (auto it = v.begin(); it != v.end(); ++it) {
        *it *= 2;  // double each element
    }
    // v: 20 40 60 80 100

    // Random access iterator arithmetic
    auto it = v.begin();
    std::cout << *(it + 2) << std::endl;  // 60 (jump to index 2)
    std::cout << v.end() - v.begin() << std::endl;  // 5 (size)

    // Reverse iterators
    for (auto it = v.rbegin(); it != v.rend(); ++it) {
        std::cout << *it << " ";  // 100 80 60 40 20
    }

    // const_iterator — read-only iteration
    for (auto it = v.cbegin(); it != v.cend(); ++it) {
        std::cout << *it << " ";
        // *it = 0;  // ERROR — const_iterator
    }

    // Insert using iterator
    it = v.begin() + 2;
    v.insert(it, 55);  // insert 55 before index 2
    // WARNING: it is now INVALID after insert — re-fetch if needed

    // Erase using iterator
    auto newEnd = std::remove(v.begin(), v.end(), 60);
    v.erase(newEnd, v.end());  // remove-erase idiom

    // std::advance — works on any iterator category
    std::list<int> lst = {1, 2, 3, 4, 5};
    auto lit = lst.begin();
    std::advance(lit, 3);  // move forward 3 (even for non-random-access)
    std::cout << *lit << std::endl;  // 4

    // std::distance — number of steps between iterators
    auto dist = std::distance(lst.begin(), lit);
    std::cout << "Distance: " << dist << std::endl;  // 3

    // std::next and std::prev (C++11)
    auto next2 = std::next(lst.begin(), 2);
    std::cout << *next2 << std::endl;  // 3

    return 0;
}

─────────────────────────────────────
ITERATOR INVALIDATION:
─────────────────────────────────────
Adding/removing elements can invalidate iterators!
Vector insert/erase  → all iterators potentially invalid
Map/set insert       → iterators remain valid
List insert/erase    → only erased element's iterator invalid
Always re-fetch iterators after modifying a container.
─────────────────────────────────────

📝 KEY POINTS:
✅ end() points PAST the last element — never dereference it
✅ Use std::advance for non-random-access iterators
✅ Use std::next/std::prev for one-step movement (returns new iterator)
✅ Prefer range-based for loops when you don't need the iterator itself
❌ Never dereference end() — undefined behavior
❌ Never use an iterator after the container it points to is modified
''',
  quiz: [
    Quiz(question: 'What does end() return?', options: [
      QuizOption(text: 'An iterator pointing one past the last element', correct: true),
      QuizOption(text: 'An iterator pointing to the last element', correct: false),
      QuizOption(text: 'A null pointer', correct: false),
      QuizOption(text: 'The size of the container', correct: false),
    ]),
    Quiz(question: 'What iterator category does std::vector provide?', options: [
      QuizOption(text: 'Random access iterator', correct: true),
      QuizOption(text: 'Bidirectional iterator', correct: false),
      QuizOption(text: 'Forward iterator', correct: false),
      QuizOption(text: 'Input iterator only', correct: false),
    ]),
    Quiz(question: 'What happens to iterators when you insert into a vector?', options: [
      QuizOption(text: 'All iterators may be invalidated due to reallocation', correct: true),
      QuizOption(text: 'Only the inserted position iterator changes', correct: false),
      QuizOption(text: 'Iterators are never invalidated in vectors', correct: false),
      QuizOption(text: 'Only iterators after the insertion point are invalidated', correct: false),
    ]),
  ],
);
