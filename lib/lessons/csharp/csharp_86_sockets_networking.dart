// lib/lessons/csharp/csharp_86_sockets_networking.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson86 = Lesson(
  language: 'C#',
  title: 'Sockets and Low-Level Networking',
  content: '''
🎯 METAPHOR:
HttpClient is like ordering pizza by phone — comfortable,
high-level, and handles all the details for you.
Sockets are the actual delivery system underneath — the truck
route, the driver, the roads, the packaging protocol.
Raw sockets let you build ANY kind of network communication:
custom binary protocols, game servers, IoT sensors, real-time
data feeds. You decide exactly what bytes go on the wire.
More work, total control.

A TCP socket is a phone call — connection established,
then two-way reliable stream until one side hangs up.
A UDP socket is a postcard — you send it and hope it arrives.
No connection, no guarantee, but very fast.

📖 EXPLANATION:
System.Net.Sockets:
  Socket    — low-level, works with TCP and UDP
  TcpClient / TcpListener   — TCP convenience wrappers
  UdpClient — UDP convenience wrapper
  NetworkStream — Stream over a TCP connection

TCP: reliable, ordered, connection-based
UDP: unreliable, unordered, connectionless, fast

ASYNC SOCKETS (preferred):
  ConnectAsync, AcceptAsync, SendAsync, ReceiveAsync
  All return ValueTask<int> for zero-allocation hot paths

💻 CODE:
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    // ─── TCP SERVER ───
    static async Task RunTcpServerAsync(int port, CancellationToken ct)
    {
        var listener = new TcpListener(IPAddress.Loopback, port);
        listener.Start();
        Console.WriteLine(\$"[Server] Listening on port {port}");

        try
        {
            while (!ct.IsCancellationRequested)
            {
                TcpClient client = await listener.AcceptTcpClientAsync(ct);
                Console.WriteLine(\$"[Server] Client connected: {client.Client.RemoteEndPoint}");

                // Handle each client on its own task
                _ = Task.Run(() => HandleClientAsync(client, ct), ct);
            }
        }
        catch (OperationCanceledException) { }
        finally
        {
            listener.Stop();
            Console.WriteLine("[Server] Stopped");
        }
    }

    static async Task HandleClientAsync(TcpClient client, CancellationToken ct)
    {
        using client;
        using NetworkStream stream = client.GetStream();
        byte[] buffer = new byte[4096];

        try
        {
            while (!ct.IsCancellationRequested)
            {
                int bytesRead = await stream.ReadAsync(buffer, ct);
                if (bytesRead == 0) break;  // client disconnected

                string message = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                Console.WriteLine(\$"[Server] Received: {message.Trim()}");

                // Echo back
                string response = \$"Echo: {message.Trim()}\n";
                byte[] responseBytes = Encoding.UTF8.GetBytes(response);
                await stream.WriteAsync(responseBytes, ct);
            }
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            Console.WriteLine(\$"[Server] Client error: {ex.Message}");
        }

        Console.WriteLine("[Server] Client disconnected");
    }

    // ─── TCP CLIENT ───
    static async Task RunTcpClientAsync(int port)
    {
        using var client = new TcpClient();
        await client.ConnectAsync(IPAddress.Loopback, port);
        Console.WriteLine("[Client] Connected!");

        using NetworkStream stream = client.GetStream();
        byte[] buffer = new byte[4096];

        string[] messages = { "Hello Server!", "How are you?", "Goodbye!" };
        foreach (string msg in messages)
        {
            // Send
            byte[] data = Encoding.UTF8.GetBytes(msg + "\n");
            await stream.WriteAsync(data);

            // Receive response
            int bytesRead = await stream.ReadAsync(buffer);
            string response = Encoding.UTF8.GetString(buffer, 0, bytesRead);
            Console.WriteLine(\$"[Client] Got: {response.Trim()}");

            await Task.Delay(100);
        }
    }

    // ─── UDP CLIENT / SERVER ───
    static async Task UdpDemo()
    {
        int port = 9001;

        // UDP Server
        var server = new UdpClient(port);
        var serverTask = Task.Run(async () =>
        {
            for (int i = 0; i < 3; i++)
            {
                UdpReceiveResult result = await server.ReceiveAsync();
                string msg = Encoding.UTF8.GetString(result.Buffer);
                Console.WriteLine(\$"[UDP Server] Got: {msg} from {result.RemoteEndPoint}");
            }
            server.Close();
        });

        // UDP Client
        await Task.Delay(100);
        using var udpClient = new UdpClient();
        var serverEndpoint = new IPEndPoint(IPAddress.Loopback, port);

        for (int i = 0; i < 3; i++)
        {
            byte[] data = Encoding.UTF8.GetBytes(\$"UDP message {i + 1}");
            await udpClient.SendAsync(data, data.Length, serverEndpoint);
            await Task.Delay(50);
        }

        await serverTask;
    }

    // ─── RAW SOCKET ───
    static async Task RawSocketDemo()
    {
        // Low-level TCP with Socket directly
        using var socket = new Socket(
            AddressFamily.InterNetwork,
            SocketType.Stream,
            ProtocolType.Tcp);

        socket.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.ReuseAddress, true);
        socket.NoDelay = true;  // disable Nagle algorithm for low latency

        await socket.ConnectAsync("example.com", 80);

        // Send HTTP/1.1 request manually
        string request = "GET / HTTP/1.1\r\nHost: example.com\r\nConnection: close\r\n\r\n";
        byte[] requestBytes = Encoding.ASCII.GetBytes(request);
        await socket.SendAsync(requestBytes, SocketFlags.None);

        // Receive response
        byte[] buffer = new byte[4096];
        int received = await socket.ReceiveAsync(buffer, SocketFlags.None);
        string response = Encoding.ASCII.GetString(buffer, 0, received);
        Console.WriteLine(response[..Math.Min(200, response.Length)]);

        socket.Shutdown(SocketShutdown.Both);
    }

    static async Task Main()
    {
        // TCP Echo Server / Client Demo
        int port = 9000;
        var cts = new CancellationTokenSource();

        var serverTask = RunTcpServerAsync(port, cts.Token);
        await Task.Delay(100);  // let server start

        await RunTcpClientAsync(port);

        cts.Cancel();
        await serverTask;

        // UDP Demo
        Console.WriteLine("\n=== UDP ===");
        await UdpDemo();
    }
}

─────────────────────────────────────
TCP vs UDP:
─────────────────────────────────────
TCP     reliable, ordered, connection-based, slower
UDP     unreliable, unordered, connectionless, faster
Use TCP for: file transfer, HTTP, databases, chat
Use UDP for: gaming, live video, DNS, IoT telemetry
─────────────────────────────────────

📝 KEY POINTS:
✅ TcpListener / TcpClient are simpler than raw Socket for TCP
✅ Always handle each client connection in its own Task
✅ NetworkStream.ReadAsync returns 0 when client disconnects
✅ socket.NoDelay = true disables Nagle algorithm — better for real-time apps
✅ UDP is fire-and-forget — implement your own reliability if needed
❌ Don't use synchronous socket methods — they block threads
❌ Always dispose TcpClient and NetworkStream — they hold OS socket handles
''',
  quiz: [
    Quiz(question: 'What does a return value of 0 from NetworkStream.ReadAsync() indicate?', options: [
      QuizOption(text: 'The client has disconnected', correct: true),
      QuizOption(text: 'No data was available at this moment', correct: false),
      QuizOption(text: 'The buffer was too small to read any data', correct: false),
      QuizOption(text: 'The stream reached end-of-file', correct: false),
    ]),
    Quiz(question: 'When should you use UDP instead of TCP?', options: [
      QuizOption(text: 'When low latency matters more than guaranteed delivery — gaming, live video, DNS', correct: true),
      QuizOption(text: 'When you need reliable ordered delivery of all packets', correct: false),
      QuizOption(text: 'When transferring large files', correct: false),
      QuizOption(text: 'UDP is always preferred because it is faster', correct: false),
    ]),
    Quiz(question: 'What does socket.NoDelay = true do?', options: [
      QuizOption(text: 'Disables the Nagle algorithm — sends small packets immediately instead of buffering', correct: true),
      QuizOption(text: 'Prevents the socket from blocking on send operations', correct: false),
      QuizOption(text: 'Removes the connection timeout', correct: false),
      QuizOption(text: 'Makes the socket non-blocking', correct: false),
    ]),
  ],
);
