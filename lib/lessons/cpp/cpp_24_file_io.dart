// lib/lessons/cpp/cpp_24_file_io.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cppLesson24 = Lesson(
  language: 'C++',
  title: 'File I/O',
  content: '''
🎯 METAPHOR:
File I/O is like a mail system.
Writing to a file is like sending a letter — you address
the envelope (open the file), write the contents, seal it
(close the file). Reading from a file is like opening your
mailbox — you check if there's mail, take out the letter,
and read it line by line. The file is the mailbox that
persists even after your program stops running.

📖 EXPLANATION:
C++ file I/O uses streams from <fstream>:

  ofstream — output file stream (write to file)
  ifstream — input file stream (read from file)
  fstream  — both read and write

Open modes (flags):
  ios::in      read
  ios::out     write (creates or overwrites)
  ios::app     append (add to end)
  ios::trunc   truncate (clear file on open)
  ios::binary  binary mode (not text)

Combine with |: ios::out | ios::app

💻 CODE:
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

int main() {
    // ─── WRITING TO A FILE ───
    std::ofstream outFile("data.txt");

    if (!outFile.is_open()) {
        std::cerr << "Failed to open file!" << std::endl;
        return 1;
    }

    outFile << "Line 1: Hello, File!" << std::endl;
    outFile << "Line 2: C++ file I/O" << std::endl;
    outFile << "Line 3: " << 42 << std::endl;
    outFile.close();  // always close when done

    // ─── READING LINE BY LINE ───
    std::ifstream inFile("data.txt");

    if (!inFile.is_open()) {
        std::cerr << "Cannot open file!" << std::endl;
        return 1;
    }

    std::string line;
    while (std::getline(inFile, line)) {
        std::cout << line << std::endl;
    }
    inFile.close();

    // ─── APPENDING TO A FILE ───
    std::ofstream appendFile("data.txt", std::ios::app);
    appendFile << "Line 4: Appended!" << std::endl;
    appendFile.close();

    // ─── READING WORD BY WORD ───
    std::ifstream wordFile("data.txt");
    std::string word;
    while (wordFile >> word) {
        std::cout << "[" << word << "] ";
    }
    std::cout << std::endl;
    wordFile.close();

    // ─── STRING STREAMS (in-memory file-like I/O) ───
    std::ostringstream oss;
    oss << "Name: Alice" << std::endl;
    oss << "Score: " << 95 << std::endl;
    std::string content = oss.str();
    std::cout << content;

    std::istringstream iss("10 20 30 40 50");
    int num;
    while (iss >> num) {
        std::cout << num * 2 << " ";  // 20 40 60 80 100
    }

    return 0;
}

─────────────────────────────────────
BINARY FILES:
─────────────────────────────────────
std::ofstream bin("data.bin", std::ios::binary);
int x = 42;
bin.write(reinterpret_cast<char*>(&x), sizeof(x));
bin.close();

std::ifstream bin2("data.bin", std::ios::binary);
int y;
bin2.read(reinterpret_cast<char*>(&y), sizeof(y));
// y is now 42
─────────────────────────────────────

📝 KEY POINTS:
✅ Always check is_open() before using a file stream
✅ Always close files when done — or use RAII (scope-based auto-close)
✅ Use ios::app to add to a file without overwriting
✅ std::stringstream is great for building strings or parsing
✅ fstream files close automatically when they go out of scope
❌ Don't forget to check for EOF properly — use while(getline(...))
❌ Don't use binary mode for text files or vice versa
''',
  quiz: [
    Quiz(question: 'Which stream class is used to write to a file in C++?', options: [
      QuizOption(text: 'std::ofstream', correct: true),
      QuizOption(text: 'std::ifstream', correct: false),
      QuizOption(text: 'std::cout', correct: false),
      QuizOption(text: 'std::wstream', correct: false),
    ]),
    Quiz(question: 'What does the ios::app open mode do?', options: [
      QuizOption(text: 'Opens the file and appends new data to the end', correct: true),
      QuizOption(text: 'Opens the file and clears its contents', correct: false),
      QuizOption(text: 'Opens the file in binary mode', correct: false),
      QuizOption(text: 'Opens the file for reading only', correct: false),
    ]),
    Quiz(question: 'What is a std::stringstream useful for?', options: [
      QuizOption(text: 'In-memory stream operations for building or parsing strings', correct: true),
      QuizOption(text: 'Reading from standard input', correct: false),
      QuizOption(text: 'Writing directly to a file', correct: false),
      QuizOption(text: 'Compressing strings', correct: false),
    ]),
  ],
);
