// lib/lessons/css/css_33_accessibility_css.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson33 = Lesson(
  language: 'CSS',
  title: 'Accessibility in CSS',
  content: '''
🎯 METAPHOR:
Accessible CSS is like designing a building with everyone
in mind from the start. Ramps, wide corridors, and tactile
strips aren't afterthoughts — they're part of the design.
In CSS, that means not hiding focus indicators from keyboard
users, respecting when someone says "please reduce motion,"
honoring dark mode preferences, and never communicating
information through color alone. Accessibility isn't a
checkbox — it's a continuous design consideration that
makes your site work for MORE people.

📖 EXPLANATION:
CSS ACCESSIBILITY FEATURES:

prefers-reduced-motion
  User prefers less animation (vestibular disorder, seizures).
  Disable or reduce animations and transitions.

prefers-color-scheme
  User's OS is in dark or light mode.
  Provide appropriate color schemes.

prefers-contrast
  User prefers more contrast.
  Increase contrast ratios.

forced-colors
  High Contrast Mode (Windows).
  System overrides your colors — work with it.

:focus-visible
  Keyboard focus indicator — visible for keyboard, hidden for mouse.

visually-hidden
  Visible to screen readers, not visible on screen.

color-contrast()
  CSS function to ensure sufficient contrast (in progress).

💻 CODE:
/* ─── PREFERS-REDUCED-MOTION ─── */
/* Never fully disable transitions — just reduce them */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Better: opt-in to animations rather than opt-out */
.animated {
  /* No animation by default */
}

@media (prefers-reduced-motion: no-preference) {
  .animated {
    animation: slide-in 0.3s ease;
  }
}

/* Parallax effects are a major trigger */
@media (prefers-reduced-motion: reduce) {
  .parallax { transform: none !important; }
}

/* ─── PREFERS-COLOR-SCHEME ─── */
:root {
  /* Light mode defaults */
  --bg: #ffffff;
  --text: #1a1a1a;
  --primary: #6c63ff;
  --surface: #f5f5f5;
  --border: #e0e0e0;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #1a1a2e;
    --text: #e0e0e0;
    --primary: #9c88ff;
    --surface: #16213e;
    --border: #2d2d4e;
  }
}

body {
  background: var(--bg);
  color: var(--text);
}

/* Manual toggle with data attribute (JS sets it) */
[data-theme="dark"] {
  --bg: #1a1a2e;
  --text: #e0e0e0;
}

/* ─── PREFERS-CONTRAST ─── */
@media (prefers-contrast: more) {
  :root {
    --text: #000000;
    --bg: #ffffff;
    --primary: #0000cc;
  }

  button {
    border: 2px solid currentColor;
  }

  a {
    text-decoration: underline;
    text-underline-offset: 3px;
  }
}

/* ─── FORCED-COLORS (Windows High Contrast) ─── */
@media (forced-colors: active) {
  /* System controls colors — use system keywords */
  button {
    border: 1px solid ButtonText;
    background: ButtonFace;
    color: ButtonText;
  }

  /* Make sure SVG icons are visible */
  svg {
    fill: currentColor;
  }

  /* Don't rely on background-color for meaning */
  .badge {
    border: 1px solid;
  }
}

/* ─── FOCUS INDICATORS ─── */
/* NEVER just do this: */
/* *:focus { outline: none; } ← destroys keyboard navigation! */

/* DO this: keyboard focus visible, mouse focus hidden */
:focus-visible {
  outline: 3px solid #6c63ff;
  outline-offset: 3px;
  border-radius: 3px;
}

/* Optional: suppress outline for mouse click (use carefully) */
:focus:not(:focus-visible) {
  outline: none;
}

/* High-visibility focus for buttons */
button:focus-visible {
  outline: 3px solid #6c63ff;
  outline-offset: 4px;
  box-shadow: 0 0 0 6px rgba(108, 99, 255, 0.25);
}

/* ─── VISUALLY HIDDEN (screen reader only) ─── */
.visually-hidden,
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

/* Skip link — visible on focus (keyboard users) */
.skip-link {
  position: absolute;
  top: -100%;
  left: 1rem;
  padding: 0.5rem 1rem;
  background: #6c63ff;
  color: white;
  border-radius: 0 0 4px 4px;
  font-weight: bold;
  text-decoration: none;
  z-index: 9999;
}

.skip-link:focus {
  top: 0;
}

/* ─── COLOR AND CONTRAST ─── */
/* Minimum contrast ratios:
   Normal text: 4.5:1 (WCAG AA)
   Large text:  3:1 (WCAG AA)
   UI components: 3:1 */

/* Don't communicate ONLY through color */
.error-message {
  color: #d32f2f;
  /* Add icon or text prefix too */
}
.error-message::before {
  content: "⚠ ";
}

/* ─── TOUCH TARGET SIZE ─── */
button,
a,
input[type="checkbox"],
input[type="radio"] {
  min-width: 44px;   /* WCAG 2.5.8 — minimum 44×44px touch target */
  min-height: 44px;
}

/* ─── FONT SIZE AND LINE HEIGHT ─── */
body {
  font-size: 1rem;        /* Never set below 16px for body */
  line-height: 1.5;       /* WCAG recommends 1.5 for body */
  letter-spacing: 0.12em; /* WCAG SC 1.4.12 allows override */
}

/* Respect user's zoom without breaking layout */
html {
  text-size-adjust: none;  /* Don't override user's text size */
}

📝 KEY POINTS:
✅ prefers-reduced-motion: reduce should disable parallax and large animations
✅ NEVER remove outline without providing a visible alternative focus indicator
✅ :focus-visible shows focus rings for keyboard only — clean UX for mouse users
✅ .sr-only / .visually-hidden is the standard class for screen-reader-only text
✅ prefers-color-scheme + CSS variables is the clean way to implement dark mode
✅ Test with Windows High Contrast Mode — forced-colors media query helps
❌ Removing focus styles is the most common accessibility mistake in CSS
❌ Don't use color alone to convey meaning — color-blind users won't see it
''',
  quiz: [
    Quiz(question: 'What should you do when prefers-reduced-motion: reduce is active?', options: [
      QuizOption(text: 'Disable or significantly reduce animations and transitions', correct: true),
      QuizOption(text: 'Remove all CSS from the page', correct: false),
      QuizOption(text: 'Increase animation speed so they complete faster', correct: false),
      QuizOption(text: 'Do nothing — this media query is not widely supported', correct: false),
    ]),
    Quiz(question: 'What does :focus-visible do differently from :focus?', options: [
      QuizOption(text: 'Shows focus indicator only when focus is from keyboard — not mouse click', correct: true),
      QuizOption(text: 'Makes the focus indicator more visible with extra styling', correct: false),
      QuizOption(text: 'Focuses the element that is most visible on screen', correct: false),
      QuizOption(text: 'It is identical to :focus', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the visually-hidden / sr-only CSS pattern?', options: [
      QuizOption(text: 'Makes content invisible on screen but readable by screen readers', correct: true),
      QuizOption(text: 'Hides content from all users including screen readers', correct: false),
      QuizOption(text: 'Applies reduced opacity to secondary content', correct: false),
      QuizOption(text: 'Prevents content from being indexed by search engines', correct: false),
    ]),
  ],
);
