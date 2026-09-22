// lib/lessons/html/html_13_accessibility.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson13 = Lesson(
  language: 'HTML',
  title: 'Accessibility in HTML (ARIA and WCAG)',
  content: '''
🎯 METAPHOR:
Accessible HTML is like designing a building for everyone.
You don't just think about people who walk in — you think
about people in wheelchairs (ramps), blind visitors
(braille signage and guided tours), deaf visitors
(visual alarms and captions), and people with cognitive
differences (clear signage and simple navigation).
The curb cut effect: features built for disabled people
end up helping everyone. Captions help people in noisy
cafes. High contrast helps people in bright sunlight.
Keyboard navigation helps power users. Accessibility
is not a niche feature — it is good design for all.

📖 EXPLANATION:
THE FOUR WCAG PRINCIPLES (POUR):
  Perceivable   — can sense it (see it, hear it, feel it)
  Operable      — can use it (keyboard, touch, click)
  Understandable — makes sense (clear language, predictable)
  Robust        — works with assistive technology

ACCESSIBILITY TREE:
  The browser builds an accessibility tree from HTML.
  Screen readers read this tree, not the visual page.
  Semantic HTML creates correct tree automatically.
  ARIA fills gaps where HTML semantics don't exist.

KEY ACCESSIBILITY REQUIREMENTS:
  ✅ All images have alt text
  ✅ All form inputs have labels
  ✅ Color is not the only way to convey information
  ✅ Keyboard navigation works for all interactive elements
  ✅ Focus is visible
  ✅ Pages work without JavaScript for core content

ARIA ROLES:
  Landmark: banner, navigation, main, complementary,
            contentinfo, search, region, form
  Widget:   button, checkbox, dialog, menu, tab,
            tabpanel, tooltip, alert, progressbar
  Document: article, heading, img, list, listitem

ARIA STATES/PROPERTIES:
  aria-label, aria-labelledby, aria-describedby
  aria-expanded, aria-selected, aria-checked
  aria-hidden, aria-live, aria-atomic, aria-relevant
  aria-disabled, aria-readonly, aria-required
  aria-haspopup, aria-controls, aria-owns
  aria-setsize, aria-posinset (for dynamic lists)
  aria-valuenow, aria-valuemin, aria-valuemax

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Accessibility Demo</title>
</head>
<body>

  <!-- ─── SKIP LINK ─── -->
  <!-- First element — keyboard users skip nav -->
  <a href="#main" class="skip-link">Skip to main content</a>

  <!-- ─── LANDMARKS ─── -->
  <header role="banner"><!-- role="banner" is implicit on <header> -->
    <nav aria-label="Primary navigation">
      <!-- aria-label differentiates multiple nav elements -->
    </nav>
  </header>

  <main id="main" role="main">

    <!-- ─── HEADINGS (logical hierarchy) ─── -->
    <h1>Accessibility in HTML</h1>

    <!-- ─── IMAGES ─── -->
    <!-- Informative image -->
    <img
      src="chart.png"
      alt="Bar chart showing 40% increase in accessibility compliance from 2020 to 2024"
    >

    <!-- Decorative image -->
    <img src="divider.png" alt="" role="presentation">

    <!-- Complex image with extended description -->
    <figure>
      <img
        src="complex-diagram.png"
        alt="System architecture diagram"
        aria-describedby="diagram-desc"
      >
      <figcaption id="diagram-desc">
        The diagram shows three layers: presentation (web browser),
        application (Node.js server), and data (PostgreSQL database),
        connected by REST APIs.
      </figcaption>
    </figure>

    <!-- ─── BUTTONS vs LINKS ─── -->
    <!-- Use <a> for navigation, <button> for actions -->
    <a href="/products">View Products</a>  <!-- navigates -->
    <button type="button">Add to Cart</button>  <!-- does something -->

    <!-- NEVER DO THIS: -->
    <!-- <div onclick="...">Click me</div> -->
    <!-- Missing: keyboard access, focus, role, enter key support -->

    <!-- ─── CUSTOM BUTTON (if you must) ─── -->
    <div
      role="button"
      tabindex="0"
      aria-label="Add item to cart"
      onkeydown="if(event.key==='Enter'||event.key===' ')this.click()"
    >
      Add to Cart
    </div>

    <!-- ─── DIALOG / MODAL ─── -->
    <!-- Native dialog — best option -->
    <dialog
      id="confirm-dialog"
      aria-labelledby="dialog-title"
      aria-describedby="dialog-desc"
    >
      <h2 id="dialog-title">Confirm Deletion</h2>
      <p id="dialog-desc">
        Are you sure you want to delete this item?
        This action cannot be undone.
      </p>
      <button autofocus>Delete</button>
      <button onclick="document.getElementById('confirm-dialog').close()">
        Cancel
      </button>
    </dialog>

    <!-- ─── LIVE REGIONS ─── -->
    <!-- Announce dynamic changes to screen readers -->
    <div aria-live="polite" id="status" aria-atomic="true">
      <!-- JS updates this: "Item added to cart" -->
      <!-- polite = wait for user to finish current action -->
      <!-- assertive = interrupt immediately (use rarely) -->
    </div>

    <!-- ─── TABS (ARIA PATTERN) ─── -->
    <div role="tablist" aria-label="Brewing Methods">
      <button
        role="tab"
        id="tab-espresso"
        aria-selected="true"
        aria-controls="panel-espresso"
      >
        Espresso
      </button>
      <button
        role="tab"
        id="tab-pour"
        aria-selected="false"
        aria-controls="panel-pour"
        tabindex="-1"
      >
        Pour Over
      </button>
    </div>

    <div
      role="tabpanel"
      id="panel-espresso"
      aria-labelledby="tab-espresso"
    >
      <p>Espresso uses 9 bars of pressure...</p>
    </div>

    <div
      role="tabpanel"
      id="panel-pour"
      aria-labelledby="tab-pour"
      hidden
    >
      <p>Pour over uses gravity and precise pouring...</p>
    </div>

    <!-- ─── FORM ACCESSIBILITY ─── -->
    <form>
      <div>
        <label for="name">
          Name <span aria-label="required">*</span>
        </label>
        <input
          type="text"
          id="name"
          name="name"
          required
          aria-required="true"
          aria-describedby="name-hint name-error"
        >
        <span id="name-hint" class="hint">
          Enter your full legal name
        </span>
        <span id="name-error" role="alert" class="error" hidden>
          Name is required
        </span>
      </div>
    </form>

    <!-- ─── LOADING INDICATOR ─── -->
    <div
      role="status"
      aria-label="Loading results"
      aria-live="polite"
    >
      <span aria-hidden="true">⏳</span>
      Loading...
    </div>

  </main>

  <aside aria-label="Related articles"></aside>
  <footer role="contentinfo"></footer>

</body>
</html>

📝 KEY POINTS:
✅ First rule of ARIA: don't use ARIA if native HTML semantics work
✅ Skip links let keyboard users bypass repetitive navigation
✅ aria-live="polite" announces dynamic changes without interrupting
✅ Use role="alert" for urgent messages; role="status" for non-urgent
✅ Tabs pattern: role="tablist" > role="tab" > role="tabpanel"
✅ aria-expanded, aria-selected, aria-checked reflect current state
❌ Never make div/span interactive — use button or a with proper keyboard handling
❌ aria-hidden="true" on interactive elements is wrong — screen readers can't reach them
''',
  quiz: [
    Quiz(question: 'What is the first rule of ARIA?', options: [
      QuizOption(text: 'Don\'t use ARIA if a native HTML element can do the job semantically', correct: true),
      QuizOption(text: 'Always add ARIA roles to all elements', correct: false),
      QuizOption(text: 'ARIA must be used for all interactive elements', correct: false),
      QuizOption(text: 'Add role="presentation" to decorative elements', correct: false),
    ]),
    Quiz(question: 'What does aria-live="polite" do?', options: [
      QuizOption(text: 'Announces dynamic content changes to screen readers without interrupting current speech', correct: true),
      QuizOption(text: 'Makes the element speak when clicked', correct: false),
      QuizOption(text: 'Prevents the element from being announced', correct: false),
      QuizOption(text: 'Announces changes immediately interrupting any current speech', correct: false),
    ]),
    Quiz(question: 'Why should you use <button> instead of <div onclick="..."> for actions?', options: [
      QuizOption(text: 'Buttons are keyboard-accessible, focusable, and have the correct ARIA role by default', correct: true),
      QuizOption(text: 'Divs cannot have onclick handlers', correct: false),
      QuizOption(text: 'Buttons are faster to process in the browser', correct: false),
      QuizOption(text: 'Only buttons can trigger JavaScript events', correct: false),
    ]),
  ],
);
