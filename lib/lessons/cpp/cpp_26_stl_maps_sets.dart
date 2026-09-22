// lib/lessons/cpp/cpp_26_stl_maps_sets.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson26 = Lesson(
  language: 'C++',
  title: 'STL: Maps and Sets',
  content: '''
🎯 METAPHOR:
A map is like a dictionary.
Each word (key) has a definition (value). You look up a word
to get its meaning. Keys are unique — no word appears twice.
A set is like a guest list at an event.
Names are unique — each person is either on the list or not.
You don't care about order or definitions, just presence.

📖 EXPLANATION:
std::map — key-value pairs, sorted by key, unique keys
std::unordered_map — same but hash-based, faster lookup O(1)
std::set — unique values, sorted
std::unordered_set — unique values, hash-based, faster

─────────────────────────────────────
MAP OPERATIONS:
─────────────────────────────────────
m[key]              access/insert by key
m.at(key)           access (throws if missing)
m.insert({k, v})    insert pair
m.erase(key)        remove by key
m.find(key)         returns iterator (end if not found)
m.count(key)        1 if exists, 0 if not
m.contains(key)     C++20 — true/false
m.size()            number of pairs
─────────────────────────────────────

💻 CODE:
#include <iostream>
#include <map>
#include <unordered_map>
#include <set>
#include <string>

int main() {
    // ─── MAP ───
    std::map<std::string, int> scores;

    // Insert
    scores["Alice"] = 95;
    scores["Bob"] = 87;
    scores["Charlie"] = 92;
    scores.insert({"Diana", 88});

    // Access
    std::cout << scores["Alice"] << std::endl;    // 95
    std::cout << scores.at("Bob") << std::endl;   // 87

    // Iterate — always in sorted key order
    for (const auto& [name, score] : scores) {  // C++17 structured binding
        std::cout << name << ": " << score << std::endl;
    }

    // Check if key exists
    if (scores.count("Alice")) {
        std::cout << "Alice is in the map" << std::endl;
    }

    // Find
    auto it = scores.find("Charlie");
    if (it != scores.end()) {
        std::cout << "Found: " << it->first << " = " << it->second << std::endl;
    }

    // Erase
    scores.erase("Bob");

    // ─── UNORDERED_MAP — faster, no guaranteed order ───
    std::unordered_map<std::string, int> fastMap;
    fastMap["x"] = 1;
    fastMap["y"] = 2;
    fastMap["z"] = 3;
    std::cout << fastMap["x"] << std::endl;  // 1

    // ─── SET ───
    std::set<int> primes = {2, 3, 5, 7, 11, 13};
    primes.insert(17);
    primes.insert(3);   // already exists — no duplicate added

    for (int p : primes) {
        std::cout << p << " ";  // 2 3 5 7 11 13 17 (sorted)
    }
    std::cout << std::endl;

    if (primes.count(7)) {
        std::cout << "7 is prime" << std::endl;
    }

    primes.erase(2);
    std::cout << primes.size() << std::endl;  // 6

    // Word frequency counter — classic map use case
    std::string text = "the cat sat on the mat the cat";
    std::unordered_map<std::string, int> freq;
    std::istringstream iss(text);
    std::string word;
    while (iss >> word) freq[word]++;

    for (const auto& [w, count] : freq) {
        std::cout << w << ": " << count << std::endl;
    }

    return 0;
}

─────────────────────────────────────
map vs unordered_map:
─────────────────────────────────────
map           sorted, O(log n) operations, ordered iteration
unordered_map unsorted, O(1) avg operations, faster lookup
─────────────────────────────────────

📝 KEY POINTS:
✅ Use map when you need sorted keys or range iteration
✅ Use unordered_map when you just need fast lookup
✅ m[key] inserts a default value if key doesn't exist — use find() to check first
✅ Structured bindings (auto& [k, v]) make map iteration clean (C++17)
❌ m[key] on a const map is an error — use m.at(key) instead
❌ Don't use [] to check existence — it inserts a default value
''',
  quiz: [
    Quiz(question: 'What happens when you use m[key] on a map with a key that does not exist?', options: [
      QuizOption(text: 'A new entry is created with the key and a default value', correct: true),
      QuizOption(text: 'An exception is thrown', correct: false),
      QuizOption(text: 'It returns 0 or empty string without inserting', correct: false),
      QuizOption(text: 'The program crashes', correct: false),
    ]),
    Quiz(question: 'What is the main advantage of unordered_map over map?', options: [
      QuizOption(text: 'Faster average lookup time O(1) vs O(log n)', correct: true),
      QuizOption(text: 'Elements are always sorted', correct: false),
      QuizOption(text: 'It uses less memory', correct: false),
      QuizOption(text: 'It supports duplicate keys', correct: false),
    ]),
    Quiz(question: 'What makes std::set different from std::vector?', options: [
      QuizOption(text: 'Sets only store unique values and are automatically sorted', correct: true),
      QuizOption(text: 'Sets can hold more elements', correct: false),
      QuizOption(text: 'Sets are faster for indexed access', correct: false),
      QuizOption(text: 'Sets allow duplicate values', correct: false),
    ]),
  ],
);
