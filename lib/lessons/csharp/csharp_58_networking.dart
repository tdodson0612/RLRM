// lib/lessons/csharp/csharp_58_networking.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson58 = Lesson(
  language: 'C#',
  title: 'Networking and HttpClient',
  content: '''
🎯 METAPHOR:
HttpClient is like a post office window clerk.
You hand them a request (envelope), they send it out,
and eventually bring back the response (reply). The clever
part: modern post offices (HttpClientFactory) have a pool
of clerks that are reused efficiently — you don't hire
a new clerk for every letter (creating new HttpClient).
That would overwhelm the post office's socket connections.

📖 EXPLANATION:
System.Net.Http.HttpClient is the standard HTTP client.

KEY RULES:
  - HttpClient should be REUSED — not created per request
  - Use IHttpClientFactory in ASP.NET / DI contexts
  - Or use a static/singleton HttpClient for simple apps

METHODS:
  GetStringAsync(url)             GET → string
  GetAsync(url)                   GET → HttpResponseMessage
  GetFromJsonAsync<T>(url)        GET → deserialize to T
  PostAsync(url, content)         POST
  PostAsJsonAsync(url, obj)       POST JSON
  PutAsync / PatchAsync / DeleteAsync
  SendAsync(request)              full control

HttpResponseMessage:
  .StatusCode                     HttpStatusCode enum
  .IsSuccessStatusCode            bool
  .EnsureSuccessStatusCode()      throws if not 2xx
  .Content.ReadAsStringAsync()    body as string
  .Content.ReadFromJsonAsync<T>() body as T

💻 CODE:
using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;

// ─── SIMPLE MODEL ───
record Post(int UserId, int Id, string Title, string Body);

class Program
{
    // ─── SINGLETON HTTPCLIENT (simple apps) ───
    private static readonly HttpClient _client = new()
    {
        BaseAddress = new Uri("https://jsonplaceholder.typicode.com/"),
        Timeout     = TimeSpan.FromSeconds(30)
    };

    static async Task Main()
    {
        // ─── GET REQUEST ───
        string html = await _client.GetStringAsync("https://example.com");
        Console.WriteLine(html[..100]);  // first 100 chars

        // ─── GET JSON ───
        Post post = await _client.GetFromJsonAsync<Post>("posts/1");
        Console.WriteLine(\$"{post.Id}: {post.Title}");

        // ─── GET WITH FULL RESPONSE ───
        HttpResponseMessage response = await _client.GetAsync("posts/1");
        response.EnsureSuccessStatusCode();  // throws if 4xx/5xx

        Console.WriteLine((int)response.StatusCode);  // 200
        Console.WriteLine(response.Headers.ContentType?.MediaType); // application/json

        string body = await response.Content.ReadAsStringAsync();
        Post deserialized = JsonSerializer.Deserialize<Post>(body,
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        // ─── POST JSON ───
        var newPost = new { Title = "Test Post", Body = "Hello!", UserId = 1 };
        HttpResponseMessage postResp = await _client.PostAsJsonAsync("posts", newPost);
        postResp.EnsureSuccessStatusCode();

        Post created = await postResp.Content.ReadFromJsonAsync<Post>(
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
        Console.WriteLine(\$"Created with ID: {created.Id}");

        // ─── CUSTOM HEADERS ───
        using var request = new HttpRequestMessage(HttpMethod.Get, "posts/1");
        request.Headers.Add("User-Agent", "MyApp/1.0");
        request.Headers.Add("Accept", "application/json");
        request.Headers.Add("Authorization", "Bearer my-token-here");

        var customResp = await _client.SendAsync(request);
        Console.WriteLine(customResp.StatusCode);

        // ─── CANCELLATION ───
        var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
        try
        {
            var cancelResp = await _client.GetStringAsync(
                "posts/1", cts.Token);
        }
        catch (TaskCanceledException)
        {
            Console.WriteLine("Request timed out or was cancelled");
        }

        // ─── STREAMING LARGE RESPONSES ───
        using var streamResp = await _client.GetAsync("posts",
            HttpCompletionOption.ResponseHeadersRead);
        using var stream = await streamResp.Content.ReadAsStreamAsync();

        var posts = await JsonSerializer.DeserializeAsync<List<Post>>(stream,
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
        Console.WriteLine(\$"Got {posts?.Count} posts");

        // ─── FORM DATA ───
        var formData = new FormUrlEncodedContent(new[]
        {
            new KeyValuePair<string, string>("username", "alice"),
            new KeyValuePair<string, string>("password", "secret")
        });
        await _client.PostAsync("login", formData);

        // ─── MULTIPART (file upload) ───
        using var multipart = new MultipartFormDataContent();
        multipart.Add(new StringContent("alice"), "username");
        // multipart.Add(new StreamContent(fileStream), "file", "photo.jpg");
        await _client.PostAsync("upload", multipart);

        // ─── RETRY PATTERN ───
        async Task<T> GetWithRetry<T>(string url, int maxRetries = 3)
        {
            for (int i = 0; i < maxRetries; i++)
            {
                try
                {
                    return await _client.GetFromJsonAsync<T>(url);
                }
                catch (HttpRequestException) when (i < maxRetries - 1)
                {
                    await Task.Delay(TimeSpan.FromSeconds(Math.Pow(2, i))); // exponential backoff
                }
            }
            return await _client.GetFromJsonAsync<T>(url);  // last attempt
        }

        var reliablePost = await GetWithRetry<Post>("posts/1");
        Console.WriteLine(reliablePost.Title);
    }
}

─────────────────────────────────────
HTTP STATUS CODE RANGES:
─────────────────────────────────────
2xx  Success    200 OK, 201 Created, 204 No Content
3xx  Redirect   301 Moved, 302 Found
4xx  Client err 400 Bad Request, 401 Unauthorized,
                404 Not Found, 429 Too Many Requests
5xx  Server err 500 Internal, 503 Unavailable
─────────────────────────────────────

📝 KEY POINTS:
✅ Reuse HttpClient — don't create new instances per request
✅ Use GetFromJsonAsync / PostAsJsonAsync for typed JSON operations
✅ EnsureSuccessStatusCode() throws HttpRequestException on 4xx/5xx
✅ Use HttpCompletionOption.ResponseHeadersRead for streaming large responses
✅ Always pass CancellationToken to async HTTP calls for timeouts
❌ Never create new HttpClient per request — socket exhaustion
❌ Don't use HttpClient in a using block unless you truly want to dispose it
''',
  quiz: [
    Quiz(question: 'Why should HttpClient be reused rather than created per request?', options: [
      QuizOption(text: 'Creating many instances exhausts socket connections (socket exhaustion)', correct: true),
      QuizOption(text: 'HttpClient is not thread-safe and must be reused', correct: false),
      QuizOption(text: 'Each new HttpClient instance uses 100MB of memory', correct: false),
      QuizOption(text: 'HttpClient has a fixed total request limit', correct: false),
    ]),
    Quiz(question: 'What does EnsureSuccessStatusCode() do?', options: [
      QuizOption(text: 'Throws HttpRequestException if the response status code is not in the 2xx range', correct: true),
      QuizOption(text: 'Retries the request if the status code is not 200', correct: false),
      QuizOption(text: 'Returns false if the request failed', correct: false),
      QuizOption(text: 'Logs the error and returns null', correct: false),
    ]),
    Quiz(question: 'What does HttpCompletionOption.ResponseHeadersRead enable?', options: [
      QuizOption(text: 'Reading the response body as a stream without buffering it all in memory', correct: true),
      QuizOption(text: 'Receiving only the headers without downloading the body', correct: false),
      QuizOption(text: 'Automatically decompressing gzip responses', correct: false),
      QuizOption(text: 'Reading headers before the connection is established', correct: false),
    ]),
  ],
);
