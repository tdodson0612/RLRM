// lib/lessons/csharp/csharp_50_channels_reactive.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson50 = Lesson(
  language: 'C#',
  title: 'Channels and the Producer-Consumer Pattern',
  content: '''
🎯 METAPHOR:
A Channel is like a conveyor belt in a factory.
The producer (worker A) puts items on the belt.
The consumer (worker B) takes items off the other end.
The belt has a limited length (bounded channel) or is
effectively infinite (unbounded channel). If the belt
is full, the producer waits. If it's empty, the consumer
waits. Both workers operate independently at their own
pace — the belt handles coordination automatically.
No shared state, no locks, no race conditions.
Just a safe, efficient pipeline between async workers.

📖 EXPLANATION:
System.Threading.Channels (C# / .NET Core 3+) provides
thread-safe, async producer-consumer communication.

CHANNEL TYPES:
  Channel.CreateUnbounded<T>()   — unlimited capacity
  Channel.CreateBounded<T>(n)    — max n items (backpressure)

CHANNEL ENDPOINTS:
  ChannelWriter<T>   — producer: WriteAsync(), TryWrite(), Complete()
  ChannelReader<T>   — consumer: ReadAsync(), ReadAllAsync(), TryRead()

vs BlockingCollection: Channels are async-first, no thread blocking.
vs events: Channels buffer messages, don't lose them if no handler.
vs queue + locks: Channels handle all synchronization internally.

💻 CODE:
using System;
using System.Threading;
using System.Threading.Channels;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;

class Program
{
    // ─── BASIC PRODUCER/CONSUMER ───
    static async Task BasicChannelDemo()
    {
        var channel = Channel.CreateUnbounded<string>();

        // Producer
        var producer = Task.Run(async () =>
        {
            string[] messages = { "Hello", "World", "From", "Channel" };
            foreach (string msg in messages)
            {
                await channel.Writer.WriteAsync(msg);
                Console.WriteLine(\$"Produced: {msg}");
                await Task.Delay(100);
            }
            channel.Writer.Complete();  // signal: no more items
        });

        // Consumer
        var consumer = Task.Run(async () =>
        {
            // ReadAllAsync completes when writer is Complete()d
            await foreach (string msg in channel.Reader.ReadAllAsync())
            {
                Console.WriteLine(\$"Consumed: {msg}");
                await Task.Delay(200);  // slower consumer
            }
        });

        await Task.WhenAll(producer, consumer);
    }

    // ─── BOUNDED CHANNEL (backpressure) ───
    static async Task BoundedChannelDemo()
    {
        var options = new BoundedChannelOptions(3)
        {
            FullMode = BoundedChannelFullMode.Wait  // producer waits when full
        };
        var channel = Channel.CreateBounded<int>(options);

        var producer = Task.Run(async () =>
        {
            for (int i = 0; i < 10; i++)
            {
                await channel.Writer.WriteAsync(i);  // blocks if channel full
                Console.WriteLine(\$"  Wrote: {i}");
            }
            channel.Writer.Complete();
        });

        var consumer = Task.Run(async () =>
        {
            await foreach (int item in channel.Reader.ReadAllAsync())
            {
                await Task.Delay(300);  // slow consumer creates backpressure
                Console.WriteLine(\$"  Read: {item}");
            }
        });

        await Task.WhenAll(producer, consumer);
    }

    // ─── PIPELINE: chain channels ───
    static async Task PipelineDemo()
    {
        // Stage 1: generate numbers
        static async IAsyncEnumerable<int> Generate(int count)
        {
            for (int i = 1; i <= count; i++)
            {
                await Task.Delay(50);
                yield return i;
            }
        }

        // Stage 2 — filter evens using a channel
        var filtered = Channel.CreateUnbounded<int>();
        var squared  = Channel.CreateUnbounded<int>();

        // Stage 2: filter
        var filterTask = Task.Run(async () =>
        {
            await foreach (int n in Generate(10))
                if (n % 2 == 0)
                    await filtered.Writer.WriteAsync(n);
            filtered.Writer.Complete();
        });

        // Stage 3: square
        var squareTask = Task.Run(async () =>
        {
            await foreach (int n in filtered.Reader.ReadAllAsync())
                await squared.Writer.WriteAsync(n * n);
            squared.Writer.Complete();
        });

        // Consume final results
        var consumeTask = Task.Run(async () =>
        {
            await foreach (int n in squared.Reader.ReadAllAsync())
                Console.Write(n + " ");
            Console.WriteLine();
        });

        await Task.WhenAll(filterTask, squareTask, consumeTask);
        // Output: 4 16 36 64 100
    }

    // ─── MULTIPLE PRODUCERS / CONSUMERS ───
    static async Task MultiProducerConsumer()
    {
        var channel = Channel.CreateBounded<int>(10);

        // Multiple producers
        var producers = Enumerable.Range(0, 3).Select(p => Task.Run(async () =>
        {
            for (int i = 0; i < 5; i++)
            {
                await channel.Writer.WriteAsync(p * 100 + i);
            }
        })).ToArray();

        // Signal complete after all producers finish
        var signalTask = Task.WhenAll(producers)
            .ContinueWith(_ => channel.Writer.Complete());

        // Multiple consumers
        int total = 0;
        var lock_ = new object();
        var consumers = Enumerable.Range(0, 2).Select(_ => Task.Run(async () =>
        {
            await foreach (int item in channel.Reader.ReadAllAsync())
            {
                lock (lock_) total += item;
            }
        })).ToArray();

        await signalTask;
        await Task.WhenAll(consumers);
        Console.WriteLine(\$"Total: {total}");
    }

    static async Task Main()
    {
        Console.WriteLine("=== Basic Channel ===");
        await BasicChannelDemo();

        Console.WriteLine("\n=== Bounded Channel (backpressure) ===");
        await BoundedChannelDemo();

        Console.WriteLine("\n=== Pipeline ===");
        await PipelineDemo();

        Console.WriteLine("\n=== Multi Producer/Consumer ===");
        await MultiProducerConsumer();
    }
}

─────────────────────────────────────
CHANNEL vs OTHER PATTERNS:
─────────────────────────────────────
BlockingCollection  blocking, thread-based, older
Channel<T>          async-first, no thread blocking, modern
Events              no buffering, synchronous, lost if no handler
IAsyncEnumerable    pull-based, single consumer
Channel             push-based, buffered, multi-consumer capable
─────────────────────────────────────

📝 KEY POINTS:
✅ Use Channel<T> for async producer-consumer patterns
✅ BoundedChannel provides backpressure — producer slows when consumer is slow
✅ channel.Writer.Complete() signals no more items will be written
✅ ReadAllAsync() automatically completes when the writer is done
✅ Channels handle all thread synchronization internally — no locks needed
❌ Don't forget to call channel.Writer.Complete() — consumers will wait forever
❌ Don't use BlockingCollection in async code — it blocks threads
''',
  quiz: [
    Quiz(question: 'What does calling channel.Writer.Complete() do?', options: [
      QuizOption(text: 'Signals that no more items will be written — consumers will stop waiting after processing remaining items', correct: true),
      QuizOption(text: 'Immediately discards all remaining items in the channel', correct: false),
      QuizOption(text: 'Closes the channel and throws on any further reads', correct: false),
      QuizOption(text: 'Flushes all pending writes to the consumer', correct: false),
    ]),
    Quiz(question: 'What is backpressure in the context of a bounded channel?', options: [
      QuizOption(text: 'The producer slows down or waits when the channel is full', correct: true),
      QuizOption(text: 'The consumer pushes data back to the producer', correct: false),
      QuizOption(text: 'Items are discarded when the buffer is full', correct: false),
      QuizOption(text: 'The channel automatically grows to accommodate more items', correct: false),
    ]),
    Quiz(question: 'What is the key advantage of Channel<T> over BlockingCollection?', options: [
      QuizOption(text: 'Channel<T> is async-first — it never blocks threads while waiting', correct: true),
      QuizOption(text: 'Channel<T> supports more data types', correct: false),
      QuizOption(text: 'Channel<T> is faster for synchronous operations', correct: false),
      QuizOption(text: 'BlockingCollection cannot handle multiple consumers', correct: false),
    ]),
  ],
);
