// lib/lessons/csharp/csharp_48_pinvoke_interop.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson48 = Lesson(
  language: 'C#',
  title: 'P/Invoke and Native Interop',
  content: '''
🎯 METAPHOR:
P/Invoke is like a certified interpreter at a diplomatic
meeting. Your C# code speaks "managed .NET." The native
library speaks "unmanaged C/C++." The interpreter
(P/Invoke marshaler) sits between them, translating data
types, handling memory ownership, and ensuring neither
side misunderstands the other. Without the interpreter,
passing the wrong type is a crash, not a compile error.
The [DllImport] attribute is the interpreter's business card.

📖 EXPLANATION:
P/Invoke (Platform Invocation Services) lets C# call
functions in native DLL libraries (Windows APIs, C libraries,
hardware drivers, etc.) without writing C++.

Key concepts:
  [DllImport]         declare the native function
  Marshal class       convert between managed/unmanaged types
  [MarshalAs]         control how a parameter is marshaled
  SafeHandle          RAII wrapper for native handles
  fixed statement     pin managed memory for native code
  GCHandle            manually pin objects for native callbacks

COM INTEROP:
  [ComImport] — work with COM objects (Office, Windows shell, etc.)
  dynamic — late-bind COM objects easily

💻 CODE:
using System;
using System.Runtime.InteropServices;
using System.Text;

class Program
{
    // ─── P/INVOKE: WINDOWS API ───
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool Beep(uint frequency, uint duration);

    [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
    static extern uint GetCurrentDirectoryW(uint bufSize, StringBuilder buffer);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    static extern int MessageBox(IntPtr hWnd, string text, string caption, uint type);

    // ─── LINUX / MAC C LIBRARY ───
    [DllImport("libc")]
    static extern int getpid();

    [DllImport("libc", CharSet = CharSet.Ansi)]
    static extern IntPtr getenv(string name);

    // ─── STRUCT MARSHALING ───
    [StructLayout(LayoutKind.Sequential)]  // important! field order matters
    struct SystemTime
    {
        public short Year, Month, DayOfWeek, Day;
        public short Hour, Minute, Second, Milliseconds;
    }

    [DllImport("kernel32.dll")]
    static extern void GetSystemTime(out SystemTime time);

    // ─── CALLBACK (delegate as function pointer) ───
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    delegate int CompareFunc(IntPtr a, IntPtr b);

    [DllImport("libc")]
    static extern void qsort(IntPtr @base, UIntPtr nmemb, UIntPtr size,
                              [MarshalAs(UnmanagedType.FunctionPtr)] CompareFunc compare);

    // ─── SAFEHANDLE — RAII for native handles ───
    class SafeFileHandle : SafeHandle
    {
        public SafeFileHandle() : base(IntPtr.Zero, ownsHandle: true) { }

        public override bool IsInvalid => handle == IntPtr.Zero || handle == new IntPtr(-1);

        protected override bool ReleaseHandle()
        {
            return CloseHandle(handle);
        }

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool CloseHandle(IntPtr handle);
    }

    static void Main()
    {
        // ─── BEEP (Windows only) ───
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            Beep(440, 200);   // A note, 200ms
            Beep(880, 200);   // A octave up
        }

        // ─── GET CURRENT DIRECTORY ───
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            var sb = new StringBuilder(260);
            GetCurrentDirectoryW(260, sb);
            Console.WriteLine(\$"Current dir: {sb}");
        }
        else
        {
            // Cross-platform alternative
            Console.WriteLine(Environment.CurrentDirectory);
        }

        // ─── SYSTEM TIME (Windows) ───
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            GetSystemTime(out SystemTime time);
            Console.WriteLine(\$"UTC: {time.Year}-{time.Month:D2}-{time.Day:D2} " +
                              \$"{time.Hour:D2}:{time.Minute:D2}:{time.Second:D2}");
        }

        // ─── MARSHAL CLASS ───
        // Convert string to native pointer and back
        IntPtr nativeStr = Marshal.StringToHGlobalAnsi("Hello, native!");
        try
        {
            string back = Marshal.PtrToStringAnsi(nativeStr);
            Console.WriteLine(back);  // Hello, native!
        }
        finally
        {
            Marshal.FreeHGlobal(nativeStr);  // must free manually!
        }

        // Allocate and fill native memory
        IntPtr mem = Marshal.AllocHGlobal(4 * sizeof(int));
        try
        {
            for (int i = 0; i < 4; i++)
                Marshal.WriteInt32(mem, i * sizeof(int), i * 10);

            for (int i = 0; i < 4; i++)
                Console.Write(Marshal.ReadInt32(mem, i * sizeof(int)) + " ");
            Console.WriteLine();  // 0 10 20 30
        }
        finally
        {
            Marshal.FreeHGlobal(mem);
        }

        // ─── GETLASTERROR ───
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            // SetLastError = true in [DllImport] enables this
            int error = Marshal.GetLastWin32Error();
            Console.WriteLine(\$"Last Win32 error: {error}");
        }
    }
}

─────────────────────────────────────
MARSHALING CHEAT SHEET:
─────────────────────────────────────
C# string          →  const char* / LPCTSTR
C# StringBuilder   →  char* (writable buffer)
C# byte[]          →  unsigned char*
C# ref int         →  int*
C# IntPtr          →  void* / HANDLE
C# bool            →  BOOL (4 bytes) with [MarshalAs(Bool)]
C# struct          →  struct (LayoutKind.Sequential required)
─────────────────────────────────────

📝 KEY POINTS:
✅ Use [DllImport] to call native C/C++ functions from C#
✅ Use Marshal class for manual memory allocation and pointer conversion
✅ Always free Marshal.AllocHGlobal / StringToHGlobalAnsi in a finally block
✅ Use SafeHandle for native handles — ensures cleanup even on exception
✅ Check RuntimeInformation.IsOSPlatform for cross-platform code
❌ Don't forget to free manually allocated native memory — it won't be GC'd
❌ Wrong data type sizes in struct marshaling cause subtle data corruption
''',
  quiz: [
    Quiz(question: 'What does [DllImport] do in C#?', options: [
      QuizOption(text: 'Declares a native function from an external DLL that can be called from C#', correct: true),
      QuizOption(text: 'Imports a DLL as a namespace', correct: false),
      QuizOption(text: 'Loads a DLL at compile time and embeds it', correct: false),
      QuizOption(text: 'Creates a managed wrapper class for a DLL', correct: false),
    ]),
    Quiz(question: 'Why is [StructLayout(LayoutKind.Sequential)] important for P/Invoke structs?', options: [
      QuizOption(text: 'It ensures the struct fields are laid out in memory in declaration order, matching the native struct', correct: true),
      QuizOption(text: 'It makes the struct immutable', correct: false),
      QuizOption(text: 'It tells the GC not to collect the struct', correct: false),
      QuizOption(text: 'It enables the struct to be passed to native code at all', correct: false),
    ]),
    Quiz(question: 'What must you always do with memory allocated by Marshal.AllocHGlobal?', options: [
      QuizOption(text: 'Free it with Marshal.FreeHGlobal — it is not managed by the GC', correct: true),
      QuizOption(text: 'Call Dispose() on the pointer', correct: false),
      QuizOption(text: 'Set it to IntPtr.Zero — the GC handles the rest', correct: false),
      QuizOption(text: 'Nothing — it is automatically freed when the method returns', correct: false),
    ]),
  ],
);
