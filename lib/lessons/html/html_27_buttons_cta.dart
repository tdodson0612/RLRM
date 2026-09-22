// lib/lessons/html/html_27_buttons_cta.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson27 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Buttons and Call-to-Action',
  content: '''
🎯 METAPHOR:
A button is a promise. When a user sees it, they make a
micro-commitment: "If I press this, something will happen."
The button's visual design communicates the magnitude of that
promise — a small grey button says "minor action, low stakes."
A large vibrant purple button says "THIS is the thing to do."
A red button says "danger, think twice." A ghost button says
"alternative option, less preferred." CSS gives you an entire
vocabulary of visual promises. Use it deliberately. Every
button on your page should communicate exactly how important
and consequential its action is — before anyone clicks it.

📖 EXPLANATION:
BUTTON VARIANTS:
  Primary    — main action (filled, brand color)
  Secondary  — alternative action (outlined/ghost)
  Danger     — destructive action (red)
  Ghost      — low-emphasis action (transparent)
  Icon       — icon only with aria-label
  Link-style — looks like a link, acts as button

STATES:
  :hover          — mouse over
  :active         — being pressed
  :focus-visible  — keyboard focus
  :disabled       — cannot be used
  .loading        — processing state

CSS TECHNIQUES:
  transition for smooth state changes
  transform: scale() for press feedback
  box-shadow for elevation
  border-radius variants (rounded, pill, square)
  gap for icon + text alignment

IMPORTANT:
  Use <button> for actions (not navigation)
  Use <a> for navigation (not actions)
  button type="button" prevents accidental form submit

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Button System — BeanCo</title>
  <style>
    :root {
      --brand:        #6c63ff;
      --brand-dark:   #5a52d5;
      --danger:       #dc2626;
      --danger-dark:  #b91c1c;
      --success:      #16a34a;
      --text:         #1a1a2e;
      --border:       #d1d5db;
      --muted:        #6b7280;
      --focus-ring:   rgba(108,99,255,0.35);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: system-ui, sans-serif;
      background: #f5f5fc;
      padding: 3rem 2rem;
      color: var(--text);
    }

    .section { margin-bottom: 3rem; }
    .section h2 {
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      margin-bottom: 1rem;
    }

    .button-row {
      display: flex;
      flex-wrap: wrap;
      gap: 0.75rem;
      align-items: center;
    }

    /* ─── BASE BUTTON ─── */
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      padding: 0.625rem 1.25rem;
      font-size: 0.95rem;
      font-weight: 600;
      font-family: inherit;
      line-height: 1;
      border: 2px solid transparent;
      border-radius: 8px;
      cursor: pointer;
      text-decoration: none;
      white-space: nowrap;
      transition:
        background 0.15s,
        border-color 0.15s,
        box-shadow 0.15s,
        transform 0.1s,
        color 0.15s;
      user-select: none;
      min-height: 44px;  /* WCAG touch target */
    }

    .btn:hover   { transform: translateY(-1px); }
    .btn:active  { transform: translateY(0) scale(0.97); }

    .btn:focus-visible {
      outline: 3px solid var(--focus-ring);
      outline-offset: 3px;
    }

    .btn:disabled {
      opacity: 0.45;
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }

    /* ─── SIZES ─── */
    .btn--sm {
      padding: 0.4rem 0.875rem;
      font-size: 0.8rem;
      border-radius: 6px;
      min-height: 36px;
    }

    .btn--lg {
      padding: 0.875rem 2rem;
      font-size: 1.1rem;
      border-radius: 10px;
    }

    .btn--xl {
      padding: 1.125rem 2.5rem;
      font-size: 1.2rem;
      border-radius: 12px;
    }

    /* ─── PILL ─── */
    .btn--pill { border-radius: 999px; }

    /* ─── PRIMARY ─── */
    .btn--primary {
      background: var(--brand);
      color: white;
      box-shadow: 0 4px 14px rgba(108,99,255,0.35);
    }
    .btn--primary:hover:not(:disabled) {
      background: var(--brand-dark);
      box-shadow: 0 8px 20px rgba(108,99,255,0.45);
    }

    /* ─── SECONDARY (outlined) ─── */
    .btn--secondary {
      background: transparent;
      color: var(--brand);
      border-color: var(--brand);
    }
    .btn--secondary:hover:not(:disabled) {
      background: rgba(108,99,255,0.06);
    }

    /* ─── GHOST ─── */
    .btn--ghost {
      background: transparent;
      color: var(--text);
      border-color: var(--border);
    }
    .btn--ghost:hover:not(:disabled) {
      background: white;
      border-color: var(--brand);
      color: var(--brand);
    }

    /* ─── DANGER ─── */
    .btn--danger {
      background: var(--danger);
      color: white;
      box-shadow: 0 4px 14px rgba(220,38,38,0.25);
    }
    .btn--danger:hover:not(:disabled) {
      background: var(--danger-dark);
      box-shadow: 0 8px 20px rgba(220,38,38,0.35);
    }

    /* ─── DANGER GHOST ─── */
    .btn--danger-ghost {
      background: transparent;
      color: var(--danger);
      border-color: var(--danger);
    }
    .btn--danger-ghost:hover:not(:disabled) {
      background: rgba(220,38,38,0.05);
    }

    /* ─── SUCCESS ─── */
    .btn--success {
      background: var(--success);
      color: white;
      box-shadow: 0 4px 14px rgba(22,163,74,0.25);
    }

    /* ─── ICON BUTTON ─── */
    .btn--icon {
      padding: 0.625rem;
      border-radius: 8px;
      min-width: 44px;
    }

    .btn--icon.btn--circle { border-radius: 50%; }

    /* ─── LOADING STATE ─── */
    .btn--loading {
      pointer-events: none;
      position: relative;
      color: transparent;
    }

    .btn--loading::after {
      content: "";
      position: absolute;
      width: 1rem;
      height: 1rem;
      border: 2px solid rgba(255,255,255,0.4);
      border-top-color: white;
      border-radius: 50%;
      animation: spin 0.6s linear infinite;
    }

    @keyframes spin { to { transform: rotate(360deg); } }

    /* ─── FULL WIDTH ─── */
    .btn--block { width: 100%; }

    /* ─── LINK STYLE BUTTON ─── */
    .btn--link {
      background: transparent;
      color: var(--brand);
      border: none;
      padding: 0;
      text-decoration: underline;
      text-underline-offset: 3px;
      min-height: auto;
      font-weight: 500;
    }
    .btn--link:hover { text-decoration-color: var(--brand-dark); transform: none; }
  </style>
</head>
<body>

<div class="section">
  <h2>Variants</h2>
  <div class="button-row">
    <button class="btn btn--primary" type="button">Primary</button>
    <button class="btn btn--secondary" type="button">Secondary</button>
    <button class="btn btn--ghost" type="button">Ghost</button>
    <button class="btn btn--danger" type="button">Danger</button>
    <button class="btn btn--danger-ghost" type="button">Danger Outline</button>
    <button class="btn btn--success" type="button">Success</button>
  </div>
</div>

<div class="section">
  <h2>Sizes</h2>
  <div class="button-row">
    <button class="btn btn--primary btn--sm" type="button">Small</button>
    <button class="btn btn--primary" type="button">Default</button>
    <button class="btn btn--primary btn--lg" type="button">Large</button>
    <button class="btn btn--primary btn--xl" type="button">Extra Large</button>
  </div>
</div>

<div class="section">
  <h2>Shapes</h2>
  <div class="button-row">
    <button class="btn btn--primary btn--pill" type="button">☕ Pill Button</button>
    <button class="btn btn--secondary btn--pill" type="button">Order Now →</button>
    <button class="btn btn--ghost" type="button" style="border-radius:0">Sharp</button>
  </div>
</div>

<div class="section">
  <h2>States</h2>
  <div class="button-row">
    <button class="btn btn--primary" type="button">Active</button>
    <button class="btn btn--primary" type="button" disabled>Disabled</button>
    <button class="btn btn--primary btn--loading" type="button" aria-label="Loading, please wait">
      Submit
    </button>
  </div>
</div>

<div class="section">
  <h2>Icon Buttons</h2>
  <div class="button-row">
    <button class="btn btn--primary btn--icon" type="button" aria-label="Add to cart">🛒</button>
    <button class="btn btn--ghost btn--icon btn--circle" type="button" aria-label="Like">❤️</button>
    <button class="btn btn--primary" type="button">
      <span aria-hidden="true">☕</span>
      Buy Coffee
    </button>
    <button class="btn btn--secondary" type="button">
      Learn More
      <span aria-hidden="true">→</span>
    </button>
  </div>
</div>

<div class="section">
  <h2>Full Width CTA</h2>
  <button class="btn btn--primary btn--xl btn--block btn--pill" type="button">
    ☕ Start Your Coffee Journey
  </button>
</div>

</body>
</html>

📝 KEY POINTS:
✅ Use <button type="button"> for actions — prevents accidental form submission
✅ min-height: 44px on all buttons satisfies WCAG touch target requirements
✅ :focus-visible shows focus ring only for keyboard — clean mouse experience
✅ .btn--loading hides text with color: transparent and shows CSS spinner
✅ Icon-only buttons MUST have aria-label — the icon has no text
✅ Consistent base class .btn + modifier .btn--primary follows BEM pattern
❌ Don't use <a href="#"> for buttons — use <button type="button">
❌ Don't disable buttons in forms — explain why instead (better UX)
''',
  quiz: [
    Quiz(question: 'Why should icon-only buttons always have an aria-label?', options: [
      QuizOption(text: 'Screen readers have no visible text to announce — aria-label provides the accessible name', correct: true),
      QuizOption(text: 'aria-label is required for buttons to be clickable', correct: false),
      QuizOption(text: 'It improves the button\'s SEO ranking', correct: false),
      QuizOption(text: 'Without it the icon won\'t display correctly', correct: false),
    ]),
    Quiz(question: 'What does type="button" on a <button> prevent?', options: [
      QuizOption(text: 'Prevents the button from accidentally submitting a parent form', correct: true),
      QuizOption(text: 'Prevents the button from being styled with CSS', correct: false),
      QuizOption(text: 'Prevents focus on the button', correct: false),
      QuizOption(text: 'Prevents JavaScript event listeners from attaching', correct: false),
    ]),
    Quiz(question: 'How does the loading spinner work in the .btn--loading example?', options: [
      QuizOption(text: 'color: transparent hides the text and ::after adds an animated CSS spinner on top', correct: true),
      QuizOption(text: 'The button text is replaced with an image', correct: false),
      QuizOption(text: 'display: none hides the text and JS adds a spinner element', correct: false),
      QuizOption(text: 'opacity: 0 hides the text but keeps it accessible', correct: false),
    ]),
  ],
);
