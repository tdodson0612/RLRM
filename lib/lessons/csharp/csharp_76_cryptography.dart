// lib/lessons/csharp/csharp_76_cryptography.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson76 = Lesson(
  language: 'C#',
  title: 'Cryptography and Security',
  content: '''
🎯 METAPHOR:
Hashing is like a meat grinder — input goes in, a fixed-size
output comes out. You cannot reverse it. The same input always
produces the same output. SHA256 of "hello" is always the same
256-bit value. Change one character and the output is
completely different (avalanche effect). This is how passwords
are stored: never the password itself, only the hash.

Encryption is like a lockbox — you can lock it (encrypt)
and anyone with the key can unlock it (decrypt). Symmetric
encryption (AES) uses the same key for both. Asymmetric
(RSA) uses a public key to lock and a private key to unlock —
like a slot you can drop messages into, but only the owner
can open.

📖 EXPLANATION:
System.Security.Cryptography

HASHING (one-way):
  SHA256, SHA384, SHA512   — general purpose hashing
  MD5                      — fast but BROKEN for security
  HMACSHA256               — keyed hash (tamper detection)

PASSWORD HASHING:
  Don't use SHA for passwords! Use:
  Rfc2898DeriveBytes (PBKDF2) — slow, salted, key derivation
  BCrypt.Net / Argon2 (NuGet)  — modern password hashing

SYMMETRIC ENCRYPTION (same key both ways):
  AES — Advanced Encryption Standard, industry standard

ASYMMETRIC ENCRYPTION (public/private key pair):
  RSA  — for key exchange, digital signatures
  ECDsa — elliptic curve, smaller keys than RSA

RANDOM NUMBERS:
  RandomNumberGenerator — cryptographically secure random
  Don't use Random for security!

💻 CODE:
using System;
using System.Security.Cryptography;
using System.Text;

class Program
{
    static void Main()
    {
        // ─── SHA256 HASHING ───
        string data = "Hello, World!";
        byte[] bytes = Encoding.UTF8.GetBytes(data);

        byte[] hash = SHA256.HashData(bytes);
        string hex  = Convert.ToHexString(hash);
        Console.WriteLine(\$"SHA256: {hex}");
        // B94D27B9934D3E08A52E52D7DA7DABFAC484EFE04294E576E6A04...

        // Using instance (for multiple hashes)
        using var sha256 = SHA256.Create();
        byte[] hash2 = sha256.ComputeHash(bytes);

        // SHA512
        byte[] sha512 = SHA512.HashData(bytes);
        Console.WriteLine(\$"SHA512 length: {sha512.Length} bytes");  // 64

        // ─── HMAC (keyed hash — tamper detection) ───
        byte[] key = RandomNumberGenerator.GetBytes(32);
        byte[] message = Encoding.UTF8.GetBytes("Important message");

        byte[] mac = HMACSHA256.HashData(key, message);
        Console.WriteLine(\$"HMAC: {Convert.ToHexString(mac)}");

        // Verify: same message + key → same MAC
        bool valid = CryptographicOperations.FixedTimeEquals(
            mac, HMACSHA256.HashData(key, message));
        Console.WriteLine(\$"HMAC valid: {valid}");  // True

        // ─── PASSWORD HASHING (PBKDF2) ───
        string password = "MySuperSecretPassword123!";
        byte[] salt = RandomNumberGenerator.GetBytes(32);

        // Derive a key from the password (slow by design)
        byte[] passwordHash = Rfc2898DeriveBytes.Pbkdf2(
            password: Encoding.UTF8.GetBytes(password),
            salt: salt,
            iterations: 310_000,    // OWASP recommended minimum
            hashAlgorithm: HashAlgorithmName.SHA256,
            outputLength: 32
        );

        Console.WriteLine(\$"Password hash: {Convert.ToBase64String(passwordHash)}");
        Console.WriteLine(\$"Salt: {Convert.ToBase64String(salt)}");

        // Store BOTH hash and salt. Verify by hashing again with same salt:
        byte[] verify = Rfc2898DeriveBytes.Pbkdf2(
            Encoding.UTF8.GetBytes(password), salt, 310_000,
            HashAlgorithmName.SHA256, 32);

        bool passwordMatch = CryptographicOperations.FixedTimeEquals(passwordHash, verify);
        Console.WriteLine(\$"Password matches: {passwordMatch}");  // True

        // ─── AES SYMMETRIC ENCRYPTION ───
        byte[] aesKey = RandomNumberGenerator.GetBytes(32);   // 256-bit key
        byte[] aesIV  = RandomNumberGenerator.GetBytes(16);   // 128-bit IV

        string plaintext = "Secret message to encrypt!";
        byte[] plainBytes = Encoding.UTF8.GetBytes(plaintext);

        // Encrypt
        byte[] ciphertext;
        using (var aes = Aes.Create())
        {
            aes.Key = aesKey;
            aes.IV  = aesIV;
            using var encryptor = aes.CreateEncryptor();
            ciphertext = encryptor.TransformFinalBlock(plainBytes, 0, plainBytes.Length);
        }
        Console.WriteLine(\$"Encrypted: {Convert.ToBase64String(ciphertext)}");

        // Decrypt
        byte[] decrypted;
        using (var aes = Aes.Create())
        {
            aes.Key = aesKey;
            aes.IV  = aesIV;
            using var decryptor = aes.CreateDecryptor();
            decrypted = decryptor.TransformFinalBlock(ciphertext, 0, ciphertext.Length);
        }
        Console.WriteLine(\$"Decrypted: {Encoding.UTF8.GetString(decrypted)}");

        // ─── RSA ASYMMETRIC ───
        using var rsa = RSA.Create(2048);  // 2048-bit key pair

        // Export public key (share this)
        byte[] publicKey  = rsa.ExportRSAPublicKey();
        byte[] privateKey = rsa.ExportRSAPrivateKey();

        // Encrypt with public key (anyone can do this)
        byte[] rsaEncrypted = rsa.Encrypt(
            Encoding.UTF8.GetBytes("Secret"),
            RSAEncryptionPadding.OaepSHA256);

        // Decrypt with private key (only key owner can do this)
        byte[] rsaDecrypted = rsa.Decrypt(rsaEncrypted, RSAEncryptionPadding.OaepSHA256);
        Console.WriteLine(\$"RSA decrypted: {Encoding.UTF8.GetString(rsaDecrypted)}");

        // ─── CRYPTOGRAPHICALLY SECURE RANDOM ───
        byte[] randomBytes = RandomNumberGenerator.GetBytes(16);
        Console.WriteLine(\$"Secure random: {Convert.ToHexString(randomBytes)}");

        int randomInt = RandomNumberGenerator.GetInt32(1, 100);  // [1, 100)
        Console.WriteLine(\$"Secure int: {randomInt}");
    }
}

📝 KEY POINTS:
✅ Use SHA256.HashData() for general hashing — the static method is simplest
✅ NEVER use SHA/MD5 directly for password storage — use PBKDF2 or BCrypt
✅ Always use a cryptographically unique random SALT per password
✅ Use CryptographicOperations.FixedTimeEquals for timing-attack-safe comparison
✅ AES-256 (32-byte key) is the standard for symmetric encryption
✅ Use RandomNumberGenerator, not Random, for security-sensitive values
❌ MD5 and SHA1 are broken for security use — only use for checksums
❌ Never store passwords as plaintext or simple hashes
❌ Never reuse IVs — generate a new random IV for each AES encryption
''',
  quiz: [
    Quiz(question: 'Why should you never use SHA256 directly to hash passwords?', options: [
      QuizOption(text: 'SHA256 is too fast — attackers can try billions of passwords per second', correct: true),
      QuizOption(text: 'SHA256 output is too short for passwords', correct: false),
      QuizOption(text: 'SHA256 is reversible', correct: false),
      QuizOption(text: 'SHA256 does not support Unicode passwords', correct: false),
    ]),
    Quiz(question: 'What is the purpose of a salt in password hashing?', options: [
      QuizOption(text: 'Makes each hash unique — prevents rainbow table attacks', correct: true),
      QuizOption(text: 'Makes the hash longer and more secure', correct: false),
      QuizOption(text: 'Encrypts the hash so it cannot be read', correct: false),
      QuizOption(text: 'Slows down the hashing function', correct: false),
    ]),
    Quiz(question: 'What does CryptographicOperations.FixedTimeEquals() prevent?', options: [
      QuizOption(text: 'Timing attacks — it always takes the same time regardless of where comparison fails', correct: true),
      QuizOption(text: 'Buffer overflow attacks on the comparison', correct: false),
      QuizOption(text: 'Integer overflow in the comparison', correct: false),
      QuizOption(text: 'Null reference exceptions during comparison', correct: false),
    ]),
  ],
);
