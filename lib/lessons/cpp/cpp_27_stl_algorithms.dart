// lib/lessons/cpp/cpp_27_stl_algorithms.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson27 = Lesson(
  language: 'C++',
  title: 'STL: Algorithms',
  content: '''
🎯 METAPHOR:
The STL algorithms are like a Swiss Army knife for data.
Instead of writing a loop to search through data,
another loop to sort it, another to filter it — you pull
out the right tool: std::sort, std::find, std::count,
std::transform. Professional C++ developers use these
constantly. Writing a manual sort loop when std::sort
exists is like using a spoon to drive a screw.

📖 EXPLANATION:
#include <algorithm> provides 100+ algorithms that work
on any container using iterators. They follow one pattern:

  algorithm(begin, end, ...extra args...)

This separation of algorithms from containers is one of
C++'s most powerful design decisions — the same sort works
on a vector, array, deque, or list.

─────────────────────────────────────
MOST COMMON ALGORITHMS:
─────────────────────────────────────
Searching:
  find          find first occurrence
  find_if       find first matching predicate
  count         count occurrences
  count_if      count matching predicate
  binary_search check if value exists (sorted range)

Sorting:
  sort          sort ascending (or custom comparator)
  stable_sort   sort, preserving equal elements' order
  partial_sort  sort only first n elements
  nth_element   partial sort around nth element

Transforming:
  transform     apply function to each element
  replace       replace specific value
  replace_if    replace elements matching predicate
  fill          set all elements to a value
  reverse       reverse order

Removing:
  remove        mark elements for removal (returns new end)
  remove_if     mark elements matching predicate
  unique        remove consecutive duplicates

Min/Max:
  min_element   iterator to smallest
  max_element   iterator to largest
  minmax_element both at once
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>

int main() {
    std::vector<int> v = {5, 3, 8, 1, 9, 2, 7, 4, 6};

    // Sort ascending
    std::sort(v.begin(), v.end());
    // v: 1 2 3 4 5 6 7 8 9

    // Sort descending
    std::sort(v.begin(), v.end(), std::greater<int>());
    // v: 9 8 7 6 5 4 3 2 1

    // Sort with custom comparator (lambda)
    std::vector<std::string> words = {"banana", "apple", "cherry", "date"};
    std::sort(words.begin(), words.end(),
              [](const std::string& a, const std::string& b) {
                  return a.length() < b.length();  // sort by length
              });
    // words: date apple banana cherry

    std::vector<int> nums = {1, 2, 3, 4, 5, 6, 7, 8, 9};

    // Find
    auto it = std::find(nums.begin(), nums.end(), 5);
    std::cout << "Found: " << *it << std::endl;

    // Find with predicate
    auto even = std::find_if(nums.begin(), nums.end(),
                             [](int x) { return x % 2 == 0; });
    std::cout << "First even: " << *even << std::endl;  // 2

    // Count
    int evens = std::count_if(nums.begin(), nums.end(),
                              [](int x) { return x % 2 == 0; });
    std::cout << "Even count: " << evens << std::endl;  // 4

    // Transform (square each element)
    std::vector<int> squared(nums.size());
    std::transform(nums.begin(), nums.end(), squared.begin(),
                   [](int x) { return x * x; });
    // squared: 1 4 9 16 25 36 49 64 81

    // Accumulate (sum) — from <numeric>
    int sum = std::accumulate(nums.begin(), nums.end(), 0);
    std::cout << "Sum: " << sum << std::endl;  // 45

    // Min and max
    auto [minIt, maxIt] = std::minmax_element(nums.begin(), nums.end());
    std::cout << "Min: " << *minIt << " Max: " << *maxIt << std::endl;

    // Reverse
    std::reverse(nums.begin(), nums.end());

    // Fill
    std::vector<int> zeros(5);
    std::fill(zeros.begin(), zeros.end(), 0);

    // Remove-erase idiom (the right way to remove elements)
    std::vector<int> data = {1, 2, 3, 2, 4, 2, 5};
    data.erase(std::remove(data.begin(), data.end(), 2), data.end());
    // data: 1 3 4 5

    return 0;
}

📝 KEY POINTS:
✅ Use STL algorithms instead of manual loops — cleaner, faster, tested
✅ Algorithms work on any container with iterators
✅ Lambdas make algorithms powerful and expressive
✅ Remove-erase idiom: remove() + erase() to actually delete elements
✅ Include <numeric> for accumulate, iota, inner_product
❌ std::remove does NOT erase — it just moves elements to the end
❌ Don't forget the second argument to erase after remove
''',
  quiz: [
    Quiz(question: 'What does std::remove actually do to a vector?', options: [
      QuizOption(text: 'Moves matching elements to the end and returns a new end iterator', correct: true),
      QuizOption(text: 'Deletes matching elements from the vector immediately', correct: false),
      QuizOption(text: 'Creates a new vector without the matching elements', correct: false),
      QuizOption(text: 'Sets matching elements to 0', correct: false),
    ]),
    Quiz(question: 'What header contains std::sort and std::find?', options: [
      QuizOption(text: '<algorithm>', correct: true),
      QuizOption(text: '<vector>', correct: false),
      QuizOption(text: '<numeric>', correct: false),
      QuizOption(text: '<utility>', correct: false),
    ]),
    Quiz(question: 'What does std::accumulate do?', options: [
      QuizOption(text: 'Reduces a range to a single value by applying an operation (default: sum)', correct: true),
      QuizOption(text: 'Counts all elements in a range', correct: false),
      QuizOption(text: 'Combines two ranges element-wise', correct: false),
      QuizOption(text: 'Accumulates memory for a container', correct: false),
    ]),
  ],
);
