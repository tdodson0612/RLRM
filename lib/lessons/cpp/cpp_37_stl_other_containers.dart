// lib/lessons/cpp/cpp_37_stl_other_containers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson37 = Lesson(
  language: 'C++',
  title: 'STL: Other Containers',
  content: '''
🎯 METAPHOR:
The STL container library is like a hardware store's
fastener section. You could use one giant box of mixed
screws for everything — but when you need exactly the right
fastener, the right container makes the job fast and clean.
Stack = a coin dispenser (last in, first out).
Queue = a ticket line (first in, first out).
Deque = a two-ended snake — add or remove from either end.
List = a chain of paper clips — easy to add/remove in middle.

📖 EXPLANATION:
Beyond vector, map, and set, the STL provides:

─────────────────────────────────────
CONTAINER         BEST FOR
─────────────────────────────────────
stack             LIFO — undo history, call stacks
queue             FIFO — task queues, breadth-first search
deque             fast insert/remove at BOTH ends
list              fast insert/remove anywhere (no random access)
forward_list      single-linked list — minimal memory
priority_queue    always get the highest-priority item next
pair              two values together
tuple             fixed collection of mixed types
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <stack>
#include <queue>
#include <deque>
#include <list>
#include <utility>   // pair
#include <tuple>

int main() {
    // ─── STACK (LIFO) ───
    std::stack<int> s;
    s.push(1);
    s.push(2);
    s.push(3);
    std::cout << s.top() << std::endl;  // 3 (peek)
    s.pop();
    std::cout << s.top() << std::endl;  // 2

    // ─── QUEUE (FIFO) ───
    std::queue<std::string> q;
    q.push("Alice");
    q.push("Bob");
    q.push("Charlie");
    std::cout << q.front() << std::endl;  // Alice (first in)
    q.pop();
    std::cout << q.front() << std::endl;  // Bob

    // ─── DEQUE (double-ended queue) ───
    std::deque<int> dq = {3, 4, 5};
    dq.push_front(2);   // add to front
    dq.push_front(1);
    dq.push_back(6);    // add to back
    // dq: 1 2 3 4 5 6
    for (int x : dq) std::cout << x << " ";
    std::cout << std::endl;

    // ─── LIST (doubly-linked) ───
    std::list<int> lst = {1, 2, 4, 5};
    auto it = lst.begin();
    std::advance(it, 2);        // move to position 2
    lst.insert(it, 3);          // insert 3 before position 2
    // lst: 1 2 3 4 5
    for (int x : lst) std::cout << x << " ";
    std::cout << std::endl;

    // ─── PRIORITY QUEUE (max-heap by default) ───
    std::priority_queue<int> pq;
    pq.push(30);
    pq.push(10);
    pq.push(50);
    pq.push(20);
    while (!pq.empty()) {
        std::cout << pq.top() << " ";  // 50 30 20 10
        pq.pop();
    }

    // Min-heap:
    std::priority_queue<int, std::vector<int>, std::greater<int>> minPQ;
    minPQ.push(30); minPQ.push(10); minPQ.push(50);
    std::cout << minPQ.top() << std::endl;  // 10

    // ─── PAIR ───
    std::pair<std::string, int> person = {"Alice", 30};
    std::cout << person.first << " is " << person.second << std::endl;
    auto p2 = std::make_pair("Bob", 25);

    // ─── TUPLE ───
    std::tuple<std::string, int, double> record = {"Alice", 30, 95.5};
    std::cout << std::get<0>(record) << std::endl;  // Alice
    std::cout << std::get<2>(record) << std::endl;  // 95.5

    // C++17 structured binding with tuple
    auto [name, age, score] = record;
    std::cout << name << " " << age << " " << score << std::endl;

    return 0;
}

📝 KEY POINTS:
✅ stack and queue are adaptors built on top of deque by default
✅ list allows O(1) insert/remove anywhere but has no random access
✅ priority_queue is a max-heap by default — largest element at top
✅ pair and tuple are great for returning multiple values from functions
✅ Use structured bindings (C++17) to unpack pairs and tuples cleanly
❌ Don't use list when you just need a vector — cache performance is worse
❌ list has no operator[] — must iterate to reach an element
''',
  quiz: [
    Quiz(question: 'What order does std::stack process elements?', options: [
      QuizOption(text: 'LIFO — last in, first out', correct: true),
      QuizOption(text: 'FIFO — first in, first out', correct: false),
      QuizOption(text: 'Sorted by value', correct: false),
      QuizOption(text: 'Random order', correct: false),
    ]),
    Quiz(question: 'What does std::priority_queue return from top() by default?', options: [
      QuizOption(text: 'The largest element', correct: true),
      QuizOption(text: 'The smallest element', correct: false),
      QuizOption(text: 'The most recently added element', correct: false),
      QuizOption(text: 'The first element added', correct: false),
    ]),
    Quiz(question: 'What is the advantage of std::list over std::vector?', options: [
      QuizOption(text: 'O(1) insertion and removal at any position', correct: true),
      QuizOption(text: 'Faster random access with []', correct: false),
      QuizOption(text: 'Better cache performance', correct: false),
      QuizOption(text: 'Smaller memory overhead', correct: false),
    ]),
  ],
);
