// lib/lessons/html/html_03_links.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson03 = Lesson(
  language: 'HTML',
  title: 'Links and Navigation',
  content: '''
🎯 METAPHOR:
Hyperlinks are the veins and arteries of the internet.
Without them, every web page would be an island — a document
floating alone in the void. Links connect islands into
continents. The entire World Wide Web is literally a
web of interconnected documents, all woven together
by the humble <a> tag. Tim Berners-Lee's greatest invention
was not HTML itself — it was the hyperlink. The ability
to click and instantly travel anywhere in the world.
Every anchor you write extends that web a little further.

📖 EXPLANATION:
The <a> (anchor) element creates hyperlinks.

HREF VALUES:
  Absolute URL    href="https://example.com/page"
  Relative URL    href="/about"  or  href="../images/photo.jpg"
  Same page       href="#section-id"  (scroll to element with that id)
  Email           href="mailto:user@example.com"
  Phone           href="tel:+15551234567"
  File download   href="/files/report.pdf" download

TARGET ATTRIBUTE:
  _self     open in same tab (default)
  _blank    open in new tab
  _parent   open in parent frame
  _top      open in full window

REL ATTRIBUTE (relationship):
  noopener noreferrer   — security for _blank links
  nofollow              — tell search engines not to follow
  external              — link goes to external site
  author                — link to author's page
  license               — link to license
  next / prev           — pagination

DOWNLOAD ATTRIBUTE:
  Forces the browser to download instead of navigate.
  download="filename.pdf" — optional filename hint

NAVIGATION:
  <nav> element wraps navigation links semantically.
  <a> with class="active" marks current page.

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Links Demo</title>
</head>
<body>

  <!-- ─── BASIC LINKS ─── -->
  <!-- Absolute URL -->
  <a href="https://developer.mozilla.org">Visit MDN</a>

  <!-- Relative URL -->
  <a href="/about">About Us</a>
  <a href="./contact.html">Contact</a>
  <a href="../index.html">Go Up One Level</a>

  <!-- ─── OPENING IN NEW TAB (SAFELY) ─── -->
  <!-- rel="noopener noreferrer" prevents security exploit -->
  <!-- where new tab could access parent window via window.opener -->
  <a
    href="https://example.com"
    target="_blank"
    rel="noopener noreferrer"
  >
    Opens in new tab 🔗
  </a>

  <!-- ─── SAME-PAGE ANCHOR LINKS ─── -->
  <!-- Jump to an element with id="section-two" -->
  <a href="#section-two">Jump to Section 2</a>

  <!-- The target element must have a matching id -->
  <h2 id="section-two">Section Two</h2>
  <p>You jumped here!</p>

  <!-- ─── MAILTO AND TEL ─── -->
  <a href="mailto:hello@example.com">Email Us</a>
  <a href="mailto:hello@example.com?subject=Hello&body=Hi%20there!">
    Pre-filled email
  </a>

  <a href="tel:+15551234567">Call: (555) 123-4567</a>

  <!-- ─── DOWNLOAD LINK ─── -->
  <a href="/files/annual-report.pdf" download>
    Download Annual Report (PDF)
  </a>
  <!-- download="custom-name.pdf" sets the saved filename -->
  <a href="/files/report.pdf" download="Company-Report-2024.pdf">
    Download with custom filename
  </a>

  <!-- ─── NAVIGATION (SEMANTIC) ─── -->
  <nav aria-label="Main navigation">
    <ul>
      <li><a href="/" aria-current="page">Home</a></li>
      <li><a href="/about">About</a></li>
      <li><a href="/services">Services</a></li>
      <li><a href="/blog">Blog</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
  </nav>

  <!-- ─── BREADCRUMB NAVIGATION ─── -->
  <nav aria-label="Breadcrumb">
    <ol>
      <li><a href="/">Home</a></li>
      <li><a href="/blog">Blog</a></li>
      <li aria-current="page">Current Article</li>
    </ol>
  </nav>

  <!-- ─── SKIP LINK (ACCESSIBILITY) ─── -->
  <!-- First element in body — lets keyboard users skip nav -->
  <a href="#main-content" class="skip-link">
    Skip to main content
  </a>

  <!-- ─── IMAGE AS LINK ─── -->
  <a href="/home">
    <img src="/logo.png" alt="Company Name — Go to homepage">
  </a>

  <!-- ─── LINK WITH ICON ─── -->
  <a
    href="https://github.com/username"
    target="_blank"
    rel="noopener noreferrer"
    aria-label="Visit GitHub profile"
  >
    <img src="/icons/github.svg" alt="" aria-hidden="true">
    GitHub Profile
  </a>

</body>
</html>

─────────────────────────────────────
URL TYPES:
─────────────────────────────────────
https://example.com/page    absolute — full address
/about                      root-relative — from site root
./contact.html              relative — from current folder
../index.html               relative — one level up
#section-id                 fragment — same page
mailto:user@example.com     email protocol
tel:+15551234567            phone protocol
─────────────────────────────────────

📝 KEY POINTS:
✅ Always add rel="noopener noreferrer" to target="_blank" links — security
✅ aria-current="page" marks the active navigation link for screen readers
✅ Use aria-label on icon-only links — screen readers need text
✅ Skip links (href="#main-content") help keyboard users bypass navigation
✅ download attribute forces file download instead of browser navigation
❌ Never use href="#" as a placeholder — use a button if there's no real destination
❌ Avoid using "click here" as link text — use descriptive text for accessibility
''',
  quiz: [
    Quiz(question: 'Why should you add rel="noopener noreferrer" to target="_blank" links?', options: [
      QuizOption(text: 'Security — prevents the new tab from accessing the original window via window.opener', correct: true),
      QuizOption(text: 'It makes the link open faster', correct: false),
      QuizOption(text: 'It prevents the browser from tracking the referrer in analytics', correct: false),
      QuizOption(text: 'It is required for target="_blank" to work', correct: false),
    ]),
    Quiz(question: 'What does href="#section-id" do?', options: [
      QuizOption(text: 'Scrolls the page to the element with id="section-id" on the same page', correct: true),
      QuizOption(text: 'Links to a page named section-id.html', correct: false),
      QuizOption(text: 'Creates a placeholder link that does nothing', correct: false),
      QuizOption(text: 'Links to a CSS class named section-id', correct: false),
    ]),
    Quiz(question: 'What does the download attribute on an <a> tag do?', options: [
      QuizOption(text: 'Forces the browser to download the linked file instead of navigating to it', correct: true),
      QuizOption(text: 'Adds a download icon next to the link', correct: false),
      QuizOption(text: 'Speeds up the loading of the linked resource', correct: false),
      QuizOption(text: 'Opens the file in the browser\'s download manager', correct: false),
    ]),
  ],
);
