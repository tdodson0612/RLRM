// lib/lessons/csharp/csharp_57_serialization.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson57 = Lesson(
  language: 'C#',
  title: 'Serialization: JSON, XML, and Binary',
  content: '''
🎯 METAPHOR:
Serialization is like packing your belongings for a move.
Your C# objects (furniture) need to fit through a door
(a wire, a file, a database column). You disassemble
the furniture into flat pieces (a string of bytes or text),
ship it, and reassemble it at the destination.
JSON is like flat-pack furniture diagrams — human-readable,
widely understood. XML is more verbose, like detailed
engineering blueprints. Binary is like vacuum-sealing —
compact and efficient but not human-readable.

📖 EXPLANATION:
SYSTEM.TEXT.JSON (built-in, C# 8+ / .NET Core 3+):
  The modern, fast, built-in JSON serializer.
  JsonSerializer.Serialize / Deserialize

XML SERIALIZATION:
  XmlSerializer — attribute-based
  System.Text.Json supports JSON only

BINARY:
  BinaryFormatter — obsolete, insecure, removed in .NET 7
  MessagePack, Protobuf, MemoryPack — modern alternatives

💻 CODE:
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Xml.Serialization;

// ─── MODEL ───
public class Product
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public bool InStock { get; set; }
    public List<string> Tags { get; set; } = new();

    // JSON attribute — rename in JSON output
    [JsonPropertyName("created_at")]
    public DateTime CreatedAt { get; set; }

    // Ignore in JSON output
    [JsonIgnore]
    public string InternalCode { get; set; }
}

// ─── JSON OPTIONS ───
class Program
{
    static JsonSerializerOptions PrettyOptions => new()
    {
        WriteIndented = true,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        NumberHandling = JsonNumberHandling.AllowReadingFromString,
        Converters = { new JsonStringEnumConverter() }
    };

    static void Main()
    {
        var product = new Product
        {
            Id       = 1,
            Name     = "Widget Pro",
            Price    = 29.99m,
            InStock  = true,
            Tags     = new List<string> { "electronics", "popular" },
            CreatedAt = DateTime.UtcNow,
            InternalCode = "WDGT-001"  // will be ignored
        };

        // ─── JSON SERIALIZE ───
        string json = JsonSerializer.Serialize(product, PrettyOptions);
        Console.WriteLine(json);
        // {
        //   "id": 1,
        //   "name": "Widget Pro",
        //   "price": 29.99,
        //   ...
        //   "created_at": "2024-03-15T...",
        //   (InternalCode missing)
        // }

        // ─── JSON DESERIALIZE ───
        Product back = JsonSerializer.Deserialize<Product>(json, PrettyOptions);
        Console.WriteLine(\$"{back.Name} — {back.Price:C}");

        // ─── DESERIALIZE FROM FILE ───
        File.WriteAllText("product.json", json);
        using var readStream = File.OpenRead("product.json");
        Product fromFile = JsonSerializer.Deserialize<Product>(readStream, PrettyOptions);

        // ─── ASYNC JSON ───
        async System.Threading.Tasks.Task JsonAsync()
        {
            using var ws = File.Create("product_async.json");
            await JsonSerializer.SerializeAsync(ws, product, PrettyOptions);

            using var rs = File.OpenRead("product_async.json");
            var p2 = await JsonSerializer.DeserializeAsync<Product>(rs, PrettyOptions);
        }

        // ─── PARTIAL / DYNAMIC JSON ───
        string raw = """{"name":"Alice","age":30,"extra":"ignored"}""";

        // Deserialize to Dictionary
        var dict = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(raw);
        Console.WriteLine(dict["name"].GetString());  // Alice
        Console.WriteLine(dict["age"].GetInt32());    // 30

        // JsonDocument for read-only traversal
        using JsonDocument doc = JsonDocument.Parse(raw);
        JsonElement root = doc.RootElement;
        Console.WriteLine(root.GetProperty("name").GetString());

        // ─── XML SERIALIZATION ───
        [XmlRoot("Product")]
        class XmlProduct
        {
            [XmlAttribute("id")]
            public int Id { get; set; }

            [XmlElement("Name")]
            public string Name { get; set; }

            [XmlArray("Tags")]
            [XmlArrayItem("Tag")]
            public List<string> Tags { get; set; } = new();

            [XmlIgnore]
            public string Secret { get; set; }
        }

        var xp = new XmlProduct { Id = 1, Name = "Widget", Tags = { "a", "b" } };
        var xs = new XmlSerializer(typeof(XmlProduct));

        // Serialize to XML string
        using var sw = new StringWriter();
        xs.Serialize(sw, xp);
        string xml = sw.ToString();
        Console.WriteLine(xml);

        // Deserialize from XML
        using var sr = new StringReader(xml);
        var xpBack = (XmlProduct)xs.Deserialize(sr);
        Console.WriteLine(xpBack.Name);  // Widget

        // ─── JSON SOURCE GENERATION (AOT-friendly) ───
        [JsonSerializable(typeof(Product))]
        partial class ProductContext : JsonSerializerContext { }

        string fastJson = JsonSerializer.Serialize(product, ProductContext.Default.Product);
        Product fastBack = JsonSerializer.Deserialize(fastJson, ProductContext.Default.Product);
    }
}

─────────────────────────────────────
JSON ATTRIBUTES:
─────────────────────────────────────
[JsonPropertyName("name")]     rename property in JSON
[JsonIgnore]                   exclude from serialization
[JsonInclude]                  include non-public members
[JsonConverter(typeof(...))]   custom converter
[JsonNumberHandling(...)]      control number parsing
[JsonRequired]                 property must be present
─────────────────────────────────────

📝 KEY POINTS:
✅ System.Text.Json is the modern choice — fast and built-in
✅ Use JsonSerializerOptions to configure naming, nulls, indentation
✅ JsonDocument / JsonElement for read-only dynamic JSON traversal
✅ Use source generation ([JsonSerializable]) for AOT and performance
✅ XmlSerializer for XML — attribute-driven, no external packages needed
❌ BinaryFormatter is removed in .NET 7+ — it is a security vulnerability
❌ Don't share JsonSerializerOptions instances created with new — use singletons
''',
  quiz: [
    Quiz(question: 'What does [JsonIgnore] do on a property?', options: [
      QuizOption(text: 'Excludes the property from both serialization and deserialization', correct: true),
      QuizOption(text: 'Makes the property read-only in JSON output', correct: false),
      QuizOption(text: 'Encrypts the property value in the JSON', correct: false),
      QuizOption(text: 'Sets the property to null during deserialization', correct: false),
    ]),
    Quiz(question: 'What does JsonNamingPolicy.CamelCase do?', options: [
      QuizOption(text: 'Converts PascalCase property names to camelCase in JSON output', correct: true),
      QuizOption(text: 'Converts all property names to lowercase', correct: false),
      QuizOption(text: 'Removes underscores from property names', correct: false),
      QuizOption(text: 'Validates that all JSON keys follow camelCase', correct: false),
    ]),
    Quiz(question: 'What is the advantage of JSON source generation over runtime reflection?', options: [
      QuizOption(text: 'Serialization code is generated at compile time — faster and AOT-compatible', correct: true),
      QuizOption(text: 'Source generation produces smaller JSON output', correct: false),
      QuizOption(text: 'It supports more JSON features than reflection-based serialization', correct: false),
      QuizOption(text: 'It automatically handles circular references', correct: false),
    ]),
  ],
);
