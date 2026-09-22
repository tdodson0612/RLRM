// lib/lessons/cpp/cpp_08_loops.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson08 = Lesson(
  language: 'C++',
  title: 'Loops: for, while, do-while',
  content: '''
🎯 METAPHOR:
A loop is like a workout routine.
"Do 10 push-ups" is a for loop — you know exactly how many.
"Keep running until you feel tired" is a while loop — you
keep going based on a condition you check each time.
"Eat at least one bite, then keep eating until full" is a
do-while loop — you always do it at least once, THEN check.

📖 EXPLANATION:
C++ has three loop types:

1. for   — best when you know the count in advance
2. while — best when the stopping condition can change
3. do-while — guaranteed to run at least once

PLUS: range-based for (C++11) — cleanest for collections.

─────────────────────────────────────
LOOP CONTROL:
─────────────────────────────────────
break     → exit the loop immediately
continue  → skip to next iteration
─────────────────────────────────────

💻 CODE:
#include <iostream>

int main() {
    // FOR loop — init; condition; update
    for (int i = 0; i < 5; i++) {
        std::cout << i << " ";  // 0 1 2 3 4
    }
    std::cout << std::endl;

    // Count down
    for (int i = 10; i > 0; i--) {
        std::cout << i << " ";  // 10 9 8 ... 1
    }

    // WHILE loop — condition checked BEFORE each iteration
    int count = 0;
    while (count < 5) {
        std::cout << count << " ";
        count++;  // don't forget this or you loop forever!
    }

    // DO-WHILE — runs at least once, condition checked AFTER
    int attempts = 0;
    do {
        std::cout << "Attempt " << attempts + 1 << std::endl;
        attempts++;
    } while (attempts < 3);

    // RANGE-BASED FOR (C++11) — cleanest way to iterate
    int numbers[] = {10, 20, 30, 40, 50};
    for (int num : numbers) {
        std::cout << num << " ";  // 10 20 30 40 50
    }

    // Use auto to avoid spelling out the type
    for (auto num : numbers) {
        std::cout << num << " ";
    }

    // BREAK and CONTINUE
    for (int i = 0; i < 10; i++) {
        if (i == 3) continue;  // skip 3
        if (i == 7) break;     // stop at 7
        std::cout << i << " "; // 0 1 2 4 5 6
    }

    // Nested loops
    for (int row = 1; row <= 3; row++) {
        for (int col = 1; col <= 3; col++) {
            std::cout << row * col << "\\t";
        }
        std::cout << std::endl;
    }

    return 0;
}

📝 KEY POINTS:
✅ Use for when you know the iteration count
✅ Use while when the stop condition is dynamic
✅ Use do-while when the body must run at least once
✅ Range-based for is the cleanest for iterating collections
✅ Always make sure the loop condition will eventually be false
❌ Infinite loops happen when the condition never becomes false
❌ Off-by-one errors: i < n vs i <= n — know which you need
❌ Don't modify the loop variable inside the loop body (confusing)
''',
  quiz: [
    Quiz(question: 'Which loop is guaranteed to execute its body at least once?', options: [
      QuizOption(text: 'do-while', correct: true),
      QuizOption(text: 'while', correct: false),
      QuizOption(text: 'for', correct: false),
      QuizOption(text: 'range-based for', correct: false),
    ]),
    Quiz(question: 'What does "continue" do inside a loop?', options: [
      QuizOption(text: 'Skips the rest of the current iteration and goes to the next', correct: true),
      QuizOption(text: 'Exits the loop entirely', correct: false),
      QuizOption(text: 'Restarts the loop from the beginning', correct: false),
      QuizOption(text: 'Pauses execution', correct: false),
    ]),
    Quiz(question: 'What is the range-based for loop syntax in C++?', options: [
      QuizOption(text: 'for (auto item : collection)', correct: true),
      QuizOption(text: 'for (item in collection)', correct: false),
      QuizOption(text: 'foreach (item : collection)', correct: false),
      QuizOption(text: 'for each (auto item in collection)', correct: false),
    ]),
  ],
);
