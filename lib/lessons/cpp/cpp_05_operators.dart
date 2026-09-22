// lib/lessons/cpp/cpp_05_operators.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson05 = Lesson(
  language: 'C++',
  title: 'Operators',
  content: '''
🎯 METAPHOR:
Operators are the verbs of programming.
Variables are nouns (things that exist), operators are
the actions you perform on them — add, compare, combine.
Just like English has different verb types (action, linking,
helping), C++ has different operator types, each with
its own rules and precedence.

📖 EXPLANATION:
C++ operators fall into categories:

─────────────────────────────────────
1. ARITHMETIC OPERATORS:
─────────────────────────────────────
+    addition          5 + 3 = 8
-    subtraction       5 - 3 = 2
*    multiplication    5 * 3 = 15
/    division          5 / 2 = 2  (integer division!)
%    modulo (remainder) 5 % 2 = 1
++   increment         x++ or ++x
--   decrement         x-- or --x
─────────────────────────────────────

─────────────────────────────────────
2. COMPARISON OPERATORS (return bool):
─────────────────────────────────────
==   equal to          5 == 5 → true
!=   not equal         5 != 3 → true
<    less than         3 < 5  → true
>    greater than      5 > 3  → true
<=   less or equal     3 <= 3 → true
>=   greater or equal  5 >= 5 → true
─────────────────────────────────────

─────────────────────────────────────
3. LOGICAL OPERATORS:
─────────────────────────────────────
&&   AND   true && false → false
||   OR    true || false → true
!    NOT   !true → false
─────────────────────────────────────

─────────────────────────────────────
4. ASSIGNMENT OPERATORS:
─────────────────────────────────────
=    assign            x = 5
+=   add and assign    x += 3  (x = x + 3)
-=   subtract assign   x -= 3
*=   multiply assign   x *= 2
/=   divide assign     x /= 2
%=   modulo assign     x %= 3
─────────────────────────────────────

💻 CODE:
#include <iostream>

int main() {
    int a = 10, b = 3;

    // Arithmetic
    std::cout << a + b << std::endl;  // 13
    std::cout << a - b << std::endl;  // 7
    std::cout << a * b << std::endl;  // 30
    std::cout << a / b << std::endl;  // 3 (integer division!)
    std::cout << a % b << std::endl;  // 1 (remainder)

    // Integer division gotcha:
    double result = 10 / 3;      // still 3.0 — division happens first
    double result2 = 10.0 / 3;   // 3.333 — now it's floating point

    // Pre vs post increment:
    int x = 5;
    std::cout << x++ << std::endl; // prints 5, THEN increments
    std::cout << ++x << std::endl; // increments FIRST, then prints 7

    // Compound assignment
    int score = 100;
    score -= 10;   // score is now 90
    score *= 2;    // score is now 180

    // Logical operators
    bool sunny = true;
    bool warm = false;
    std::cout << (sunny && warm) << std::endl; // 0 (false)
    std::cout << (sunny || warm) << std::endl; // 1 (true)
    std::cout << (!sunny) << std::endl;        // 0 (false)

    return 0;
}

📝 KEY POINTS:
✅ 10 / 3 = 3 in integer division — decimals are truncated
✅ 10.0 / 3 = 3.333 — at least one operand must be double
✅ x++ returns value THEN increments (post-increment)
✅ ++x increments THEN returns value (pre-increment)
✅ Prefer ++x over x++ in loops — slightly more efficient
❌ Don't confuse = (assignment) with == (comparison)
❌ if (x = 5) always true — you meant if (x == 5)
''',
  quiz: [
    Quiz(question: 'What does 10 / 3 evaluate to in C++ with integer types?', options: [
      QuizOption(text: '3', correct: true),
      QuizOption(text: '3.33', correct: false),
      QuizOption(text: '3.0', correct: false),
      QuizOption(text: '4', correct: false),
    ]),
    Quiz(question: 'What is the difference between x++ and ++x?', options: [
      QuizOption(text: 'x++ returns value then increments; ++x increments then returns', correct: true),
      QuizOption(text: 'They are identical in all cases', correct: false),
      QuizOption(text: '++x adds 2; x++ adds 1', correct: false),
      QuizOption(text: 'x++ is for doubles; ++x is for ints', correct: false),
    ]),
    Quiz(question: 'What does the % operator do?', options: [
      QuizOption(text: 'Returns the remainder of division', correct: true),
      QuizOption(text: 'Calculates a percentage', correct: false),
      QuizOption(text: 'Divides and rounds up', correct: false),
      QuizOption(text: 'Converts to floating point', correct: false),
    ]),
  ],
);
