// lib/lessons/csharp/csharp_88_scoped_inline_arrays.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson88 = Lesson(
  language: 'C#',
  title: 'scoped, Inline Arrays, and C# 12/13 Low-Level Features',
  content: '''
🎯 METAPHOR:
The scoped keyword is like a "stay in this room" rule
for a reference. Normally a ref parameter could escape —
you could store it in a field and access it after the method
returns, pointing to dead stack memory. scoped says
"this ref must not outlive this method call." It enforces
the rule at compile time, preventing dangerous escapes.

Inline arrays are like having a fixed-size array built
directly into a struct — like a car having 4 seats that
are part of the car's body, not separate chairs placed inside.
No heap allocation, no pointer overhead, just contiguous memory
as part of the struct itself. This is how Span<T> works
internally in some cases.

📖 EXPLANATION:
SCOPED KEYWORD (C# 11):
  Applies to ref and ref struct parameters.
  Prevents the reference from escaping the current scope.
  Enables safe use of ref structs in more contexts.
  Used by the compiler for Span<T> safety.

INLINE ARRAYS (C# 12):
  [InlineArray(N)] attribute on a struct with one field.
  Creates a fixed-size array as part of the struct.
  Zero heap allocation, stack-friendly.
  Used internally by .NET runtime for performance.

FIELD KEYWORD (C# 14 preview / C# 13 experimental):
  Access the compiler-generated backing field in a property.
  Eliminates need for explicit private backing fields.

PARAMS WITH COLLECTIONS (C# 13):
  params now works with IEnumerable<T>, ReadOnlySpan<T>, etc.

COLLECTION BUILDER ATTRIBUTE:
  [CollectionBuilder] lets custom collections support
  collection expression initialization syntax.

💻 CODE:
using System;
using System.Runtime.CompilerServices;

// ─── SCOPED KEYWORD ───
ref struct SpanLike
{
    private Span<int> _data;

    public SpanLike(Span<int> data) => _data = data;
    public int this[int i] => _data[i];
    public int Length => _data.Length;
}

class ScopedDemo
{
    // scoped: the ref cannot escape this method
    static int SumWithScoped(scoped ref int value, scoped SpanLike span)
    {
        int sum = value;
        for (int i = 0; i < span.Length; i++)
            sum += span[i];
        return sum;
        // value ref cannot be stored — it is scoped to this method
    }

    // Without scoped: ref could theoretically escape (unsafe)
    static void DangerousRef(ref int x)
    {
        // Could store x somewhere that outlives the caller
        // scoped prevents this
    }

    public static void Run()
    {
        int value = 10;
        Span<int> data = stackalloc int[] { 1, 2, 3, 4, 5 };
        var spanLike = new SpanLike(data);

        int result = SumWithScoped(ref value, spanLike);
        Console.WriteLine(\$"Sum: {result}");  // 25
    }
}

// ─── INLINE ARRAYS (C# 12) ───
[InlineArray(4)]
struct Vector4
{
    private float _element;  // the single field — array of 4 floats
}

[InlineArray(16)]
struct Matrix4x4Buffer
{
    private float _element;  // 16 contiguous floats, no heap
}

class InlineArrayDemo
{
    public static void Run()
    {
        Vector4 v = default;
        v[0] = 1.0f;
        v[1] = 2.0f;
        v[2] = 3.0f;
        v[3] = 4.0f;

        Console.WriteLine(\$"Vector4: [{v[0]}, {v[1]}, {v[2]}, {v[3]}]");
        Console.WriteLine(\$"Size: {System.Runtime.InteropServices.Marshal.SizeOf<Vector4>()} bytes");
        // 16 bytes (4 floats × 4 bytes each) — no heap allocation!

        // Can be used as Span
        Span<float> asSpan = v;
        float sum = 0;
        foreach (float f in asSpan) sum += f;
        Console.WriteLine(\$"Sum: {sum}");  // 10

        // Matrix
        Matrix4x4Buffer matrix = default;
        for (int i = 0; i < 16; i++)
            matrix[i] = i;

        Span<float> matSpan = matrix;
        Console.WriteLine(\$"Matrix[5]: {matSpan[5]}");  // 5
    }
}

// ─── COLLECTION BUILDER (C# 12) ───
// Allows custom collection types to support collection expression syntax: [1, 2, 3]
[CollectionBuilder(typeof(ImmutableListBuilder), "Create")]
class ImmutableList<T> : System.Collections.Generic.IEnumerable<T>
{
    private readonly T[] _items;
    public ImmutableList(T[] items) => _items = items;
    public int Count => _items.Length;
    public T this[int i] => _items[i];

    public System.Collections.Generic.IEnumerator<T> GetEnumerator()
        => ((System.Collections.Generic.IEnumerable<T>)_items).GetEnumerator();
    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        => _items.GetEnumerator();
}

static class ImmutableListBuilder
{
    public static ImmutableList<T> Create<T>(ReadOnlySpan<T> items)
        => new ImmutableList<T>(items.ToArray());
}

// ─── INTERCEPTORS (C# 12, experimental) ───
// Allows replacing a specific method call site with different code
// Used by source generators for performance (e.g., LoggerMessage)
// Requires: <InterceptorsPreviewNamespaces>Microsoft.AspNetCore.Http.Generated</InterceptorsPreviewNamespaces>
// Example (concept only — requires specific tooling):
//
// namespace System.Runtime.CompilerServices
// {
//     [AttributeUsage(AttributeTargets.Method, AllowMultiple = true)]
//     sealed class InterceptsLocationAttribute : Attribute
//     {
//         public InterceptsLocationAttribute(string filePath, int line, int column) { }
//     }
// }

class Program
{
    static void Main()
    {
        // scoped
        ScopedDemo.Run();

        // inline arrays
        InlineArrayDemo.Run();

        // collection builder — custom collection with collection expression
        ImmutableList<int> list = [1, 2, 3, 4, 5];  // collection expression!
        Console.WriteLine(\$"List count: {list.Count}");
        Console.WriteLine(\$"List[2]: {list[2]}");

        foreach (int n in list) Console.Write(n + " ");
        Console.WriteLine();

        // ─── SIZEOF COMPARISONS ───
        Console.WriteLine(\$"\nMemory layout:");
        Console.WriteLine(\$"  int[4] on heap:   {4 * 4 + 24} bytes (approx with object header)");
        Console.WriteLine(\$"  Vector4 inline:   {System.Runtime.InteropServices.Marshal.SizeOf<Vector4>()} bytes (stack)");
        Console.WriteLine(\$"  (inline array wins by ~24 bytes and avoids GC entirely)");
    }
}

─────────────────────────────────────
INLINE ARRAY RULES:
─────────────────────────────────────
Must be a struct
Must have exactly ONE private field
[InlineArray(N)] attribute
Size = N × sizeof(field type)
Indexed with []
Can be converted to Span<T>
─────────────────────────────────────

📝 KEY POINTS:
✅ scoped ref prevents dangerous reference escape — enforced at compile time
✅ Inline arrays avoid heap allocation for fixed-size numerical data
✅ Inline arrays are indexable with [] and can be cast to Span<T>
✅ [CollectionBuilder] lets custom types use collection expression syntax
✅ These features are primarily for high-performance library code
❌ Inline arrays can only have one private field — it becomes the element type
❌ scoped parameters cannot be stored in fields or returned — that is the point
''',
  quiz: [
    Quiz(question: 'What does the "scoped" keyword on a ref parameter prevent?', options: [
      QuizOption(text: 'The reference from escaping the current scope — it cannot be stored or returned', correct: true),
      QuizOption(text: 'The parameter from being modified inside the method', correct: false),
      QuizOption(text: 'The method from being called recursively', correct: false),
      QuizOption(text: 'The parameter from being null', correct: false),
    ]),
    Quiz(question: 'What makes inline arrays different from regular arrays?', options: [
      QuizOption(text: 'They are embedded directly in the struct — no heap allocation, fixed size', correct: true),
      QuizOption(text: 'They are stored in read-only memory', correct: false),
      QuizOption(text: 'They cannot be indexed with []', correct: false),
      QuizOption(text: 'They are automatically copied on assignment', correct: false),
    ]),
    Quiz(question: 'What does [CollectionBuilder] enable for a custom collection type?', options: [
      QuizOption(text: 'The type can be initialized with collection expression syntax: [1, 2, 3]', correct: true),
      QuizOption(text: 'The collection automatically sorts its elements', correct: false),
      QuizOption(text: 'The collection supports LINQ without implementing IEnumerable', correct: false),
      QuizOption(text: 'The collection can be used as a generic constraint', correct: false),
    ]),
  ],
);
