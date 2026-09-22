// lib/lessons/cpp/cpp_13_references.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson13 = Lesson(
  language: 'C++',
  title: 'References',
  content: '''
🎯 METAPHOR:
A reference is like a nickname.
"Robert" and "Bob" refer to the same person.
If Bob gets a haircut, Robert has one too — they ARE the
same person, just with two names. A reference gives a
variable a second name. Whatever you do through the
reference, you do to the original variable.

📖 EXPLANATION:
A reference is an alias — another name for an existing variable.
Unlike pointers:
  - References MUST be initialized when declared
  - References CANNOT be changed to refer to something else
  - References CANNOT be null
  - No * needed to access the value

─────────────────────────────────────
POINTER vs REFERENCE:
─────────────────────────────────────
Feature         Pointer         Reference
─────────────────────────────────────
Syntax          int* p          int& r
Initialization  can be null     must bind to variable
Reassignable    yes             no (always same target)
Dereference     *p              r (automatic)
Null possible   yes             no
─────────────────────────────────────

WHY REFERENCES MATTER:
Pass-by-reference lets functions modify the caller's
variables AND avoids copying large objects.

💻 CODE:
#include <iostream>
#include <string>

// Pass by VALUE — function gets a copy, original unchanged
void doubleValue(int x) {
    x *= 2;  // only changes the local copy
}

// Pass by REFERENCE — function gets the original
void doubleRef(int& x) {
    x *= 2;  // changes the CALLER's variable
}

// Pass by CONST REFERENCE — read access, no copy, no modify
void printName(const std::string& name) {
    std::cout << name << std::endl;
    // name = "Bob";  // ERROR: const reference
}

int main() {
    int a = 10;
    int& ref = a;   // ref is another name for a

    std::cout << a   << std::endl;  // 10
    std::cout << ref << std::endl;  // 10

    ref = 99;  // modifies a through the reference
    std::cout << a   << std::endl;  // 99
    std::cout << ref << std::endl;  // 99

    // Pass by value vs reference
    int x = 5;
    doubleValue(x);
    std::cout << x << std::endl;  // still 5

    doubleRef(x);
    std::cout << x << std::endl;  // now 10!

    // const reference — efficient read-only parameter
    std::string longName = "Bartholomew";
    printName(longName);  // no copy made of the string!

    // Returning a reference (careful!)
    // Only return references to things that outlive the function
    // NEVER return a reference to a local variable

    return 0;
}

─────────────────────────────────────
WHEN TO USE EACH:
─────────────────────────────────────
Pass by value        small types (int, char, bool)
Pass by reference    when you need to modify the caller's var
Pass by const ref    large objects you only need to read
─────────────────────────────────────

📝 KEY POINTS:
✅ References must be initialized at declaration — no dangling refs
✅ Use const references for large read-only parameters (avoids copy)
✅ References are cleaner than pointers for most use cases
✅ References cannot be null — safer than pointers
❌ Never return a reference to a local variable — it dies when the function ends
❌ References cannot be re-seated (changed to point at something else)
''',
  quiz: [
    Quiz(question: 'What is the key difference between a pointer and a reference?', options: [
      QuizOption(text: 'References must be initialized, cannot be null, and cannot be reassigned', correct: true),
      QuizOption(text: 'Pointers are faster than references', correct: false),
      QuizOption(text: 'References can be reassigned; pointers cannot', correct: false),
      QuizOption(text: 'References use * for access; pointers use &', correct: false),
    ]),
    Quiz(question: 'Why pass large objects by const reference instead of by value?', options: [
      QuizOption(text: 'It avoids making a copy while preventing modification', correct: true),
      QuizOption(text: 'It allows the function to modify the original', correct: false),
      QuizOption(text: 'It makes the function run in parallel', correct: false),
      QuizOption(text: 'It is required for objects over 4 bytes', correct: false),
    ]),
    Quiz(question: 'What happens when you modify a variable through a reference?', options: [
      QuizOption(text: 'The original variable is modified', correct: true),
      QuizOption(text: 'Only the reference copy is modified', correct: false),
      QuizOption(text: 'A new variable is created', correct: false),
      QuizOption(text: 'A compile error occurs', correct: false),
    ]),
  ],
);
