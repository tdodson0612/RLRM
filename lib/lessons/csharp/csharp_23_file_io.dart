// lib/lessons/csharp/csharp_23_file_io.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson23 = Lesson(
  language: 'C#',
  title: 'File I/O',
  content: '''
🎯 METAPHOR:
File I/O is like a post office and filing cabinet combined.
File.WriteAllText is like dropping a letter in the outbox —
address it (filename), put the content in, done.
File.ReadAllText is like opening a letter from your inbox.
StreamWriter/StreamReader is like a conveyor belt at that
post office — efficient for large volumes, letter by letter.
Directory is the filing cabinet itself — you can create,
rename, and list folders.

📖 EXPLANATION:
C# file I/O lives in System.IO. Three levels:

1. File / Directory — static helpers for simple operations
2. StreamReader / StreamWriter — for reading/writing line by line
3. FileStream — raw bytes, full control

Most file operations should be async in real applications.

💻 CODE:
using System;
using System.IO;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Text.Json;

class Program
{
    static async Task Main()
    {
        // ─── FILE CLASS (simple operations) ───
        string path = "example.txt";

        // Write (overwrites if exists)
        File.WriteAllText(path, "Hello, File!\\nLine 2\\nLine 3");

        // Read entire file
        string content = File.ReadAllText(path);
        Console.WriteLine(content);

        // Read all lines
        string[] lines = File.ReadAllLines(path);
        foreach (var line in lines)
            Console.WriteLine(\$"  > {line}");

        // Append
        File.AppendAllText(path, "\\nLine 4 (appended)");

        // File info
        Console.WriteLine(File.Exists(path));           // True
        Console.WriteLine(new FileInfo(path).Length);   // bytes

        // Copy, Move, Delete
        File.Copy(path, "backup.txt", overwrite: true);
        // File.Move("old.txt", "new.txt");
        // File.Delete(path);

        // ─── ASYNC FILE OPERATIONS (preferred) ───
        await File.WriteAllTextAsync("async.txt", "Written async!");
        string asyncContent = await File.ReadAllTextAsync("async.txt");
        Console.WriteLine(asyncContent);

        // ─── STREAMWRITER (line by line) ───
        using (var writer = new StreamWriter("log.txt", append: true))
        {
            writer.WriteLine(\$"[{DateTime.Now}] App started");
            writer.WriteLine(\$"[{DateTime.Now}] Processing...");
            writer.WriteLine(\$"[{DateTime.Now}] Done");
        }  // Dispose() called — file closed

        // ─── STREAMREADER ───
        using var reader = new StreamReader("log.txt");
        while (!reader.EndOfStream)
        {
            string line = reader.ReadLine();
            Console.WriteLine(line);
        }

        // ─── PATH CLASS ───
        string fullPath = Path.Combine("folder", "sub", "file.txt");
        Console.WriteLine(fullPath);  // folder/sub/file.txt or folder\\sub\\file.txt

        string ext      = Path.GetExtension("document.pdf"); // .pdf
        string filename = Path.GetFileNameWithoutExtension("document.pdf"); // document
        string dir      = Path.GetDirectoryName("/home/user/file.txt");     // /home/user
        string tempFile = Path.GetTempFileName();  // unique temp file path

        Console.WriteLine(\$"Ext: {ext}, Name: {filename}, Dir: {dir}");

        // ─── DIRECTORY CLASS ───
        Directory.CreateDirectory("myFolder/sub");
        Console.WriteLine(Directory.Exists("myFolder")); // True

        // List files
        foreach (string file in Directory.GetFiles(".", "*.txt"))
            Console.WriteLine(file);

        // List recursively
        foreach (string file in Directory.GetFiles(".", "*", SearchOption.AllDirectories))
            Console.WriteLine(file);

        // ─── JSON FILE (common pattern) ───
        var data = new { Name = "Alice", Age = 30, Scores = new[] { 95, 87, 92 } };
        string json = JsonSerializer.Serialize(data, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync("data.json", json);

        string jsonBack = await File.ReadAllTextAsync("data.json");
        Console.WriteLine(jsonBack);

        // ─── BINARY FILE ───
        byte[] bytes = { 0x48, 0x65, 0x6C, 0x6C, 0x6F };  // "Hello" in bytes
        await File.WriteAllBytesAsync("binary.bin", bytes);
        byte[] readBytes = await File.ReadAllBytesAsync("binary.bin");
        Console.WriteLine(System.Text.Encoding.UTF8.GetString(readBytes));  // Hello
    }
}

─────────────────────────────────────
QUICK REFERENCE:
─────────────────────────────────────
File.WriteAllText(path, text)     simple write
File.ReadAllText(path)            simple read
File.ReadAllLines(path)           → string[]
File.AppendAllText(path, text)    append
File.Exists(path)                 check exists
File.Copy / Move / Delete         file operations
Path.Combine(a, b, c)            cross-platform paths
Directory.CreateDirectory(path)   create dirs
Directory.GetFiles(path, pattern) list files
─────────────────────────────────────

📝 KEY POINTS:
✅ Use File.WriteAllText/ReadAllText for simple small files
✅ Use StreamReader/StreamWriter for large files (line by line)
✅ Always use Path.Combine for paths — never string concatenation
✅ Prefer async versions (WriteAllTextAsync) in real applications
✅ using ensures StreamReader/StreamWriter are properly closed
❌ Don't hardcode path separators — use Path.Combine
❌ Don't read huge files with ReadAllText — use streaming
''',
  quiz: [
    Quiz(question: 'Why should you use Path.Combine() instead of string concatenation for file paths?', options: [
      QuizOption(text: 'It uses the correct path separator for the current OS automatically', correct: true),
      QuizOption(text: 'It is faster than string concatenation', correct: false),
      QuizOption(text: 'It validates that the path exists', correct: false),
      QuizOption(text: 'It is required for async file operations', correct: false),
    ]),
    Quiz(question: 'What does the "using" statement do when wrapping a StreamWriter?', options: [
      QuizOption(text: 'Ensures Dispose() is called automatically — closing and flushing the file', correct: true),
      QuizOption(text: 'Imports the System.IO namespace', correct: false),
      QuizOption(text: 'Makes the StreamWriter available globally', correct: false),
      QuizOption(text: 'Prevents the file from being opened by other processes', correct: false),
    ]),
    Quiz(question: 'Which File method is best for reading a large log file line by line efficiently?', options: [
      QuizOption(text: 'StreamReader with while(!reader.EndOfStream)', correct: true),
      QuizOption(text: 'File.ReadAllText — it reads everything at once', correct: false),
      QuizOption(text: 'File.ReadAllLines — loads all lines into memory', correct: false),
      QuizOption(text: 'File.OpenRead with a FileStream', correct: false),
    ]),
  ],
);
