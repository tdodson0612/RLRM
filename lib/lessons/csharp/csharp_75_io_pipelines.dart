// lib/lessons/csharp/csharp_75_io_pipelines.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson75 = Lesson(
  language: 'C#',
  title: 'System.IO.Pipelines and High-Performance I/O',
  content: '''
🎯 METAPHOR:
Traditional stream I/O is like a one-person assembly line.
Read some bytes into a buffer, process them, read more.
If processing is slow, the read blocks. If the buffer is
too small, you truncate messages. Too large, you waste memory.

System.IO.Pipelines is like a factory conveyor belt with
two independent workers. The writer (producer) keeps
filling the belt from one end. The reader (consumer) takes
from the other end at their own pace. The belt handles
buffering automatically — the writer pauses if the belt is
full (backpressure), the reader waits if it's empty.
Zero copies, zero allocations in the hot path.

📖 EXPLANATION:
System.IO.Pipelines (NuGet: System.IO.Pipelines):

PipeWriter — write bytes into the pipe
PipeReader — read bytes from the pipe
Pipe       — connects writer and reader

KEY ADVANTAGES over Stream:
  - Zero-copy: operate on Memory<byte> directly
  - Backpressure: writer waits if reader falls behind
  - Partial reads: examine data, then advance only what processed
  - Automatic buffer management

OPERATIONS:
  writer.GetMemory(sizeHint)   get buffer to write into
  writer.Advance(bytes)        commit written bytes
  writer.FlushAsync()          make data available to reader
  reader.ReadAsync()           get available data
  result.Buffer               the ReadOnlySequence<byte> of data
  reader.AdvanceTo(pos)        mark data as consumed

USED BY: Kestrel (ASP.NET Core), SignalR, gRPC transport

💻 CODE:
using System;
using System.Buffers;
using System.IO.Pipelines;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        // ─── BASIC PIPE ───
        var pipe = new Pipe();

        Task writeTask = WriteAsync(pipe.Writer);
        Task readTask  = ReadAsync(pipe.Reader);

        await Task.WhenAll(writeTask, readTask);
    }

    // ─── WRITER ───
    static async Task WriteAsync(PipeWriter writer)
    {
        string[] messages = { "Hello\n", "World\n", "Pipeline\n", "Done\n" };

        foreach (string msg in messages)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(msg);

            // Get a buffer from the pipe
            Memory<byte> buffer = writer.GetMemory(bytes.Length);

            // Copy data into the buffer
            bytes.CopyTo(buffer);

            // Advance: tell pipe how many bytes we wrote
            writer.Advance(bytes.Length);

            // Flush: make data available to reader
            FlushResult result = await writer.FlushAsync();

            if (result.IsCompleted) break;

            await Task.Delay(50);  // simulate slower producer
        }

        // Signal: no more data coming
        await writer.CompleteAsync();
        Console.WriteLine("Writer done");
    }

    // ─── READER ───
    static async Task ReadAsync(PipeReader reader)
    {
        while (true)
        {
            ReadResult result = await reader.ReadAsync();
            ReadOnlySequence<byte> buffer = result.Buffer;

            // Process complete lines
            while (TryReadLine(ref buffer, out ReadOnlySequence<byte> line))
            {
                ProcessLine(line);
            }

            // Tell pipe: consumed everything up to current position
            reader.AdvanceTo(buffer.Start, buffer.End);

            // Exit when writer is done AND buffer is empty
            if (result.IsCompleted && buffer.IsEmpty)
                break;
        }

        await reader.CompleteAsync();
        Console.WriteLine("Reader done");
    }

    static bool TryReadLine(ref ReadOnlySequence<byte> buffer,
                             out ReadOnlySequence<byte> line)
    {
        // Search for newline
        SequencePosition? position = buffer.PositionOf((byte)'\n');
        if (position == null)
        {
            line = default;
            return false;
        }

        // Slice up to and including the newline
        line = buffer.Slice(0, position.Value);
        buffer = buffer.Slice(buffer.GetPosition(1, position.Value));
        return true;
    }

    static void ProcessLine(ReadOnlySequence<byte> line)
    {
        // Zero-copy: read from sequence without allocating string
        if (line.IsSingleSegment)
        {
            // Fast path: single contiguous segment
            string text = Encoding.UTF8.GetString(line.FirstSpan);
            Console.WriteLine(\$"[Processed] {text.TrimEnd()}");
        }
        else
        {
            // Multi-segment: use SequenceReader or copy
            string text = Encoding.UTF8.GetString(line.ToArray());
            Console.WriteLine(\$"[Processed] {text.TrimEnd()}");
        }
    }

    // ─── PIPE FROM STREAM ───
    static async Task ReadFromStream(System.IO.Stream stream)
    {
        // Wrap any Stream in a PipeReader
        PipeReader reader = PipeReader.Create(stream);

        while (true)
        {
            ReadResult result = await reader.ReadAsync();
            ReadOnlySequence<byte> buffer = result.Buffer;

            Console.WriteLine(\$"Read {buffer.Length} bytes");

            reader.AdvanceTo(buffer.End);

            if (result.IsCompleted) break;
        }

        await reader.CompleteAsync();
    }
}

─────────────────────────────────────
PIPELINE vs STREAM:
─────────────────────────────────────
Stream:
  - Simple: Read(buffer, offset, count)
  - Allocates: caller manages buffers
  - No backpressure
  - Good for simple file I/O

Pipeline:
  - Complex but powerful
  - Zero-copy buffer management
  - Built-in backpressure
  - Good for network protocols, high-throughput parsing
─────────────────────────────────────

📝 KEY POINTS:
✅ Pipelines are the foundation of ASP.NET Core's Kestrel server
✅ PipeReader.AdvanceTo(consumed, examined) — consumed marks processed data
✅ Writer.CompleteAsync() signals no more data — reader loop terminates
✅ PipeReader.Create(stream) wraps any Stream as a PipeReader
✅ ReadOnlySequence<byte> may span multiple memory segments — handle both cases
❌ Don't advance past examined — you'll lose unprocessed data
❌ Pipelines have a learning curve — use streams for simple file I/O
''',
  quiz: [
    Quiz(question: 'What is the role of writer.Advance(n) in a PipeWriter?', options: [
      QuizOption(text: 'Tells the pipe how many bytes were written into the buffer', correct: true),
      QuizOption(text: 'Moves the write position forward without writing data', correct: false),
      QuizOption(text: 'Flushes n bytes to the reader', correct: false),
      QuizOption(text: 'Allocates n more bytes in the pipe', correct: false),
    ]),
    Quiz(question: 'What does reader.AdvanceTo(buffer.Start, buffer.End) tell the pipe?', options: [
      QuizOption(text: 'Nothing was consumed yet but all data up to buffer.End was examined', correct: true),
      QuizOption(text: 'All data in the buffer was consumed', correct: false),
      QuizOption(text: 'The reader is done and no more data will be read', correct: false),
      QuizOption(text: 'The buffer should be reset to the start', correct: false),
    ]),
    Quiz(question: 'What advantage do Pipelines have over Streams for network I/O?', options: [
      QuizOption(text: 'Zero-copy buffer management, automatic backpressure, and partial read support', correct: true),
      QuizOption(text: 'Pipelines are simpler to use than Streams', correct: false),
      QuizOption(text: 'Pipelines support encryption while Streams do not', correct: false),
      QuizOption(text: 'Pipelines automatically parse protocols like HTTP', correct: false),
    ]),
  ],
);
