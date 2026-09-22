// lib/lessons/cpp/cpp_54_nested_classes_scope.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson54 = Lesson(
  language: 'C++',
  title: 'Nested Classes, Scope, and Lifetime',
  content: '''
🎯 METAPHOR:
A nested class is like a department within a company.
The Payroll department only makes sense inside the company —
it is not an independent business. You would not call up
"Payroll" as a standalone entity. Nesting it says:
"this class is an implementation detail that lives inside
and is conceptually owned by its outer class."
Scope rules are the rules of the building — who can see
what, and for how long do they stick around.

📖 EXPLANATION:
NESTED CLASSES:
  A class defined inside another class.
  The nested class is scoped to the outer class.
  Has no special access to outer class members (unless friend).
  Use for: helper types, iterators, implementation details.

SCOPE RULES:
  Local scope     — inside a function or block {}
  Class scope     — inside a class
  Namespace scope — inside a namespace
  Global scope    — outside everything

LIFETIME:
  Automatic — local variables, destroyed when scope exits
  Static    — exists for the entire program duration
  Dynamic   — heap memory, manually or smart-pointer managed

💻 CODE:
#include <iostream>
#include <vector>
#include <string>

// ─── NESTED CLASS ───
class LinkedList {
private:
    // Node is an implementation detail — users don't need to see it
    struct Node {
        int value;
        Node* next;
        Node(int v) : value(v), next(nullptr) {}
    };

    Node* head = nullptr;

public:
    void push(int val) {
        Node* n = new Node(val);
        n->next = head;
        head = n;
    }

    // Nested iterator class — scoped to LinkedList
    class Iterator {
        Node* current;
    public:
        Iterator(Node* n) : current(n) {}
        bool hasNext() const { return current != nullptr; }
        int next() {
            int val = current->value;
            current = current->next;
            return val;
        }
    };

    Iterator begin() { return Iterator(head); }

    ~LinkedList() {
        Node* curr = head;
        while (curr) {
            Node* tmp = curr->next;
            delete curr;
            curr = tmp;
        }
    }
};

// ─── SCOPE AND LIFETIME DEMO ───
int globalVar = 100;           // global scope — exists entire program

void scopeDemo() {
    int localVar = 10;         // local scope — exists only in this function
    static int staticVar = 0;  // static local — persists between calls!
    staticVar++;

    std::cout << "local: "  << localVar   << std::endl;
    std::cout << "static: " << staticVar  << std::endl;
    std::cout << "global: " << globalVar  << std::endl;

    {
        int blockVar = 42;     // block scope — dies at the }
        std::cout << "block: " << blockVar << std::endl;
    }
    // blockVar is gone here
}

// ─── VARIABLE SHADOWING ───
int x = 1;  // global x

void shadowDemo() {
    int x = 2;           // shadows global x
    std::cout << x << std::endl;       // 2 (local)
    std::cout << ::x << std::endl;     // 1 (global — :: forces global scope)
    {
        int x = 3;       // shadows function x
        std::cout << x << std::endl;   // 3
    }
    std::cout << x << std::endl;       // 2 (back to function x)
}

// ─── STATIC LOCAL — classic lazy singleton ───
class Config {
public:
    static Config& get() {
        static Config instance;  // created once on first call, thread-safe in C++11
        return instance;
    }
    int timeout = 30;
private:
    Config() { std::cout << "Config created" << std::endl; }
};

int main() {
    // Nested class usage
    LinkedList list;
    list.push(1);
    list.push(2);
    list.push(3);

    // LinkedList::Node* n;  // ERROR — Node is private
    LinkedList::Iterator it = list.begin();  // Iterator is public
    while (it.hasNext()) {
        std::cout << it.next() << " ";  // 3 2 1
    }
    std::cout << std::endl;

    // Scope and lifetime
    scopeDemo();  // static: 1
    scopeDemo();  // static: 2 (persists!)
    scopeDemo();  // static: 3

    // Shadowing
    shadowDemo();

    // Static local singleton
    Config::get().timeout = 60;
    std::cout << Config::get().timeout << std::endl;  // 60

    return 0;
}

📝 KEY POINTS:
✅ Nested classes scope implementation details inside their owner
✅ Static local variables persist between function calls — initialized once
✅ Use :: to access the global scope when shadowed by a local name
✅ Static local singletons are thread-safe since C++11
✅ Block scope {} is a useful tool to control lifetime and reduce error-prone state
❌ Shadowing outer variables is legal but confusing — avoid it
❌ Don't confuse static local (persists in function) with static member (belongs to class)
''',
  quiz: [
    Quiz(question: 'What is a nested class in C++?', options: [
      QuizOption(text: 'A class defined inside another class, scoped to the outer class', correct: true),
      QuizOption(text: 'A class that inherits from another class', correct: false),
      QuizOption(text: 'A class declared inside a function', correct: false),
      QuizOption(text: 'A class that contains a pointer to another class', correct: false),
    ]),
    Quiz(question: 'What is special about a static local variable inside a function?', options: [
      QuizOption(text: 'It is initialized once and persists its value between function calls', correct: true),
      QuizOption(text: 'It is shared between all threads automatically', correct: false),
      QuizOption(text: 'It is stored in a register for fast access', correct: false),
      QuizOption(text: 'It is destroyed when the function returns', correct: false),
    ]),
    Quiz(question: 'What does the :: operator do when used alone (as in ::x)?', options: [
      QuizOption(text: 'Accesses the global scope version of the name', correct: true),
      QuizOption(text: 'Accesses a namespace member', correct: false),
      QuizOption(text: 'Accesses a static class member', correct: false),
      QuizOption(text: 'Dereferences a pointer to a class', correct: false),
    ]),
  ],
);
