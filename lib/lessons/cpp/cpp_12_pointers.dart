// lib/lessons/cpp/cpp_12_pointers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson12 = Lesson(
  language: 'C++',
  title: 'Pointers',
  content: '''
🎯 METAPHOR:
A pointer is like a street address written on paper.
The paper is NOT the house — it tells you WHERE the house is.
The variable is the house (actual data in memory).
The pointer is the address written on a sticky note.
You can follow the address to find the house (dereference),
or give someone else the address so they can also find it.

📖 EXPLANATION:
Every variable lives at a specific memory address.
A pointer is a variable that STORES that address.

─────────────────────────────────────
POINTER SYNTAX:
─────────────────────────────────────
int* p;         declare a pointer to int
&x              address-of operator (gives the address of x)
*p              dereference operator (gives the value at address)
p = &x          store address of x in pointer p
*p = 10         change the value at the address p points to
─────────────────────────────────────

Two operators to know cold:
  & (address-of)  — "tell me where this variable lives"
  * (dereference) — "go to this address and get the value"

💻 CODE:
#include <iostream>

int main() {
    int x = 42;
    int* p = &x;  // p stores the address of x

    std::cout << x  << std::endl;  // 42   (the value)
    std::cout << &x << std::endl;  // 0x... (the address)
    std::cout << p  << std::endl;  // 0x... (same address)
    std::cout << *p << std::endl;  // 42   (value AT that address)

    // Modify x through the pointer
    *p = 99;
    std::cout << x << std::endl;   // 99! (x was changed via pointer)

    // Null pointer — points to nothing (safe default)
    int* nullPtr = nullptr;  // C++11 style (prefer over NULL)
    // *nullPtr = 5;  // CRASH — never dereference nullptr!

    // Pointer arithmetic (moves by sizeof the type)
    int arr[] = {10, 20, 30};
    int* ap = arr;              // pointer to first element
    std::cout << *ap << std::endl;      // 10
    std::cout << *(ap + 1) << std::endl; // 20
    std::cout << *(ap + 2) << std::endl; // 30

    // Pointer to pointer
    int** pp = &p;  // pp holds address of p
    std::cout << **pp << std::endl;  // 99 (double dereference)

    // const pointer variations:
    const int* cp = &x;    // can't change value through cp
    int* const pc = &x;    // can't change what pc points to
    const int* const cpc = &x; // can't change either

    return 0;
}

─────────────────────────────────────
READING POINTER DECLARATIONS (right-to-left):
─────────────────────────────────────
int* p         pointer to int
const int* p   pointer to const int (value locked)
int* const p   const pointer to int (address locked)
int** pp       pointer to pointer to int
─────────────────────────────────────

📝 KEY POINTS:
✅ Always initialize pointers — use nullptr if no target yet
✅ Check for nullptr before dereferencing
✅ & gives address, * gives value at address
✅ Pointer arithmetic steps by sizeof(type) automatically
❌ Never dereference nullptr — instant crash
❌ Never access memory after it has been freed (dangling pointer)
❌ Wild pointers (uninitialized) point to random memory — always init
''',
  quiz: [
    Quiz(question: 'What does the & operator do when used with a variable?', options: [
      QuizOption(text: 'Returns the memory address of the variable', correct: true),
      QuizOption(text: 'Returns the value of the variable', correct: false),
      QuizOption(text: 'Creates a new pointer', correct: false),
      QuizOption(text: 'Performs bitwise AND', correct: false),
    ]),
    Quiz(question: 'What is nullptr in C++?', options: [
      QuizOption(text: 'A pointer that points to nothing (safe null pointer)', correct: true),
      QuizOption(text: 'A pointer to address zero', correct: false),
      QuizOption(text: 'An uninitialized pointer', correct: false),
      QuizOption(text: 'A pointer that has been freed', correct: false),
    ]),
    Quiz(question: 'What does dereferencing a pointer mean?', options: [
      QuizOption(text: 'Accessing the value stored at the address the pointer holds', correct: true),
      QuizOption(text: 'Freeing the memory the pointer points to', correct: false),
      QuizOption(text: 'Setting the pointer to nullptr', correct: false),
      QuizOption(text: 'Getting the address of the pointer itself', correct: false),
    ]),
  ],
);
