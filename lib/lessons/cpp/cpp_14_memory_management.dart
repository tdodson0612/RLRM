// lib/lessons/cpp/cpp_14_memory_management.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson14 = Lesson(
  language: 'C++',
  title: 'Memory Management: Stack and Heap',
  content: '''
🎯 METAPHOR:
Memory has two regions:

The STACK is like a cafeteria tray stack.
Trays are added to the top, removed from the top.
Fast, automatic, but limited in size. When a function
returns, its tray is automatically removed.

The HEAP is like renting a storage unit.
You can rent any size, keep it as long as you want,
and store things of any size. BUT — you are responsible
for returning it. If you forget, that's a memory leak.
The storage company (OS) won't clean it up for you.

📖 EXPLANATION:
STACK memory:
  - Automatically managed — allocated when var is declared,
    freed when it goes out of scope
  - Fast — just moves a stack pointer
  - Limited size (~1-8MB typically)
  - Local variables and function call frames live here

HEAP memory:
  - Manually managed — you control when it's allocated and freed
  - Larger than stack (limited only by RAM)
  - Allocated with new, freed with delete
  - Essential for large data or data that outlives a function

💻 CODE:
#include <iostream>

int main() {
    // STACK allocation — automatic
    int x = 10;         // on the stack
    double d = 3.14;    // on the stack
    // freed automatically when main() ends

    // HEAP allocation — manual with new/delete
    int* p = new int;        // allocate int on heap
    *p = 42;
    std::cout << *p << std::endl;  // 42
    delete p;                // MUST free it!
    p = nullptr;             // good practice after delete

    // Heap array
    int* arr = new int[5];   // allocate array on heap
    for (int i = 0; i < 5; i++) arr[i] = i * 10;
    for (int i = 0; i < 5; i++) std::cout << arr[i] << " ";
    delete[] arr;            // use delete[] for arrays!
    arr = nullptr;

    // MEMORY LEAK — what you must NEVER do:
    int* leak = new int(99);
    // forgot to delete leak — memory is lost until program ends

    // DANGLING POINTER — accessing freed memory:
    int* bad = new int(5);
    delete bad;
    // *bad = 10;  // UNDEFINED BEHAVIOR — memory already freed

    return 0;
}

─────────────────────────────────────
new vs delete rules:
─────────────────────────────────────
new int         → delete p
new int[n]      → delete[] p
new MyClass()   → delete obj
new MyClass[n]  → delete[] objArr
─────────────────────────────────────

─────────────────────────────────────
COMMON MEMORY BUGS:
─────────────────────────────────────
Memory leak     → forgot to delete
Dangling ptr    → using after delete
Double free     → deleting twice
Buffer overflow → writing past array bounds
─────────────────────────────────────

📝 KEY POINTS:
✅ Every new must have a matching delete
✅ Every new[] must have a matching delete[]
✅ Set pointer to nullptr after deleting it
✅ Modern C++ uses smart pointers to avoid manual delete (next lesson)
❌ Never use delete on stack memory
❌ Never delete[] with plain delete or vice versa
❌ Never access memory after it has been freed
''',
  quiz: [
    Quiz(question: 'What is a memory leak?', options: [
      QuizOption(text: 'Heap memory that was allocated but never freed', correct: true),
      QuizOption(text: 'A pointer that is set to nullptr', correct: false),
      QuizOption(text: 'Using too many stack variables', correct: false),
      QuizOption(text: 'Accessing memory past array bounds', correct: false),
    ]),
    Quiz(question: 'How do you free a heap-allocated array in C++?', options: [
      QuizOption(text: 'delete[] arr', correct: true),
      QuizOption(text: 'delete arr', correct: false),
      QuizOption(text: 'free(arr)', correct: false),
      QuizOption(text: 'arr.release()', correct: false),
    ]),
    Quiz(question: 'What is a dangling pointer?', options: [
      QuizOption(text: 'A pointer that still holds an address after that memory was freed', correct: true),
      QuizOption(text: 'A pointer initialized to nullptr', correct: false),
      QuizOption(text: 'A pointer that was never initialized', correct: false),
      QuizOption(text: 'A pointer pointing to the stack', correct: false),
    ]),
  ],
);
