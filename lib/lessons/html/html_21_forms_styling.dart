// lib/lessons/html/html_21_forms_styling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson21 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Styling Your First Form',
  content: '''
🎯 METAPHOR:
A raw HTML form is like a government tax form — functional,
complete, but utterly joyless. Every field is the same
lifeless grey box. Every button is a flat rectangle.
The information flows fine but nobody WANTS to fill it out.
CSS is the interior designer who transforms that tax office
into a welcoming boutique. Same information, same fields —
but now there are generous padding, smooth focus rings
that glow purple, labels that float above the field
when you start typing, a submit button that pulses with
confidence. The form still works exactly the same.
But now people actually want to use it.

📖 EXPLANATION:
This lesson combines HTML form structure with CSS styling
to create a beautiful, accessible sign-up form.

KEY CONCEPTS COMBINED:
  HTML:  form, fieldset, legend, label, input, button
  CSS:   Flexbox, custom properties, transitions,
         :focus-visible, :valid, :invalid, :placeholder-shown

THE FLOATING LABEL PATTERN:
  Label sits inside the input field as placeholder.
  When user types, label floats up above the field.
  Achieved with CSS :focus + :not(:placeholder-shown).
  Pure CSS — no JavaScript needed.

COLOR SYSTEM:
  CSS custom properties for consistent theming.
  Dark mode via @media (prefers-color-scheme: dark).

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Your Account — BeanCo ☕</title>
  <style>
    /* ─── DESIGN TOKENS ─── */
    :root {
      --color-brand:       #6c63ff;
      --color-brand-dark:  #5a52d5;
      --color-surface:     #ffffff;
      --color-bg:          #f0f0f8;
      --color-text:        #1a1a2e;
      --color-text-muted:  #6b7280;
      --color-border:      #d1d5db;
      --color-error:       #dc2626;
      --color-success:     #16a34a;
      --color-focus-ring:  rgba(108, 99, 255, 0.2);
      --radius:            10px;
      --shadow:            0 4px 24px rgba(108,99,255,0.08);
      --transition:        0.2s ease;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --color-surface:    #1e1e2e;
        --color-bg:         #13131f;
        --color-text:       #e2e2f0;
        --color-text-muted: #9ca3af;
        --color-border:     #374151;
      }
    }

    /* ─── RESET AND BASE ─── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: system-ui, -apple-system, sans-serif;
      background: var(--color-bg);
      color: var(--color-text);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem 1rem;
    }

    /* ─── FORM CARD ─── */
    .form-card {
      background: var(--color-surface);
      border-radius: 20px;
      padding: 2.5rem;
      width: 100%;
      max-width: 440px;
      box-shadow: var(--shadow);
    }

    .form-card__header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .form-card__logo {
      font-size: 2.5rem;
      display: block;
      margin-bottom: 0.5rem;
    }

    .form-card__title {
      font-size: 1.5rem;
      font-weight: 700;
      color: var(--color-text);
      margin-bottom: 0.25rem;
    }

    .form-card__subtitle {
      color: var(--color-text-muted);
      font-size: 0.9rem;
    }

    /* ─── FORM GROUPS ─── */
    .form-group {
      position: relative;
      margin-bottom: 1.25rem;
    }

    /* ─── INPUTS ─── */
    .form-input {
      display: block;
      width: 100%;
      padding: 1rem 1rem 0.5rem;
      font-size: 1rem;
      font-family: inherit;
      color: var(--color-text);
      background: var(--color-surface);
      border: 1.5px solid var(--color-border);
      border-radius: var(--radius);
      outline: none;
      transition: border-color var(--transition), box-shadow var(--transition);
      appearance: none;
    }

    .form-input:focus {
      border-color: var(--color-brand);
      box-shadow: 0 0 0 4px var(--color-focus-ring);
    }

    /* ─── FLOATING LABEL ─── */
    .form-label {
      position: absolute;
      left: 1rem;
      top: 0.9rem;
      font-size: 1rem;
      color: var(--color-text-muted);
      pointer-events: none;
      transition: transform var(--transition), font-size var(--transition), color var(--transition);
      transform-origin: left top;
    }

    /* Float up when focused OR has content */
    .form-input:focus ~ .form-label,
    .form-input:not(:placeholder-shown) ~ .form-label {
      transform: translateY(-0.6rem) scale(0.75);
      color: var(--color-brand);
    }

    /* Placeholder must be space to trigger :not(:placeholder-shown) */
    .form-input::placeholder { color: transparent; }

    /* ─── VALIDATION STATES ─── */
    .form-input:not(:placeholder-shown):valid {
      border-color: var(--color-success);
    }

    .form-input:not(:placeholder-shown):invalid {
      border-color: var(--color-error);
    }

    .form-input:focus:invalid {
      box-shadow: 0 0 0 4px rgba(220, 38, 38, 0.15);
    }

    /* Validation icon */
    .form-input:not(:placeholder-shown):valid  + .form-label::after { content: " ✓"; color: var(--color-success); }
    .form-input:not(:placeholder-shown):invalid + .form-label::after { content: " ✕"; color: var(--color-error); }

    /* ─── SUBMIT BUTTON ─── */
    .btn-primary {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      width: 100%;
      padding: 0.875rem;
      font-size: 1rem;
      font-family: inherit;
      font-weight: 600;
      color: white;
      background: var(--color-brand);
      border: none;
      border-radius: var(--radius);
      cursor: pointer;
      transition: background var(--transition), transform 0.1s, box-shadow var(--transition);
      margin-top: 0.5rem;
    }

    .btn-primary:hover {
      background: var(--color-brand-dark);
      box-shadow: 0 8px 20px rgba(108,99,255,0.35);
      transform: translateY(-1px);
    }

    .btn-primary:active { transform: translateY(0); }

    .btn-primary:focus-visible {
      outline: 3px solid var(--color-brand);
      outline-offset: 3px;
    }

    /* ─── FOOTER LINK ─── */
    .form-footer {
      text-align: center;
      margin-top: 1.5rem;
      font-size: 0.875rem;
      color: var(--color-text-muted);
    }

    .form-footer a {
      color: var(--color-brand);
      font-weight: 600;
      text-decoration: none;
    }

    .form-footer a:hover { text-decoration: underline; }

    /* ─── DIVIDER ─── */
    .divider {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin: 1.5rem 0;
      color: var(--color-text-muted);
      font-size: 0.875rem;
    }

    .divider::before, .divider::after {
      content: "";
      flex: 1;
      height: 1px;
      background: var(--color-border);
    }
  </style>
</head>
<body>

<div class="form-card">
  <div class="form-card__header">
    <span class="form-card__logo">☕</span>
    <h1 class="form-card__title">Join BeanCo</h1>
    <p class="form-card__subtitle">Your perfect cup awaits</p>
  </div>

  <form action="/register" method="POST" novalidate>

    <div class="form-group">
      <input
        class="form-input"
        type="text"
        id="name"
        name="name"
        placeholder=" "
        required
        autocomplete="name"
        minlength="2"
      >
      <label class="form-label" for="name">Full Name</label>
    </div>

    <div class="form-group">
      <input
        class="form-input"
        type="email"
        id="email"
        name="email"
        placeholder=" "
        required
        autocomplete="email"
      >
      <label class="form-label" for="email">Email Address</label>
    </div>

    <div class="form-group">
      <input
        class="form-input"
        type="password"
        id="password"
        name="password"
        placeholder=" "
        required
        minlength="8"
        autocomplete="new-password"
      >
      <label class="form-label" for="password">Password (8+ characters)</label>
    </div>

    <button type="submit" class="btn-primary">
      Create Account 🚀
    </button>

  </form>

  <div class="divider">or</div>

  <p class="form-footer">
    Already have an account?
    <a href="/login">Sign in</a>
  </p>
</div>

</body>
</html>

📝 KEY POINTS:
✅ Floating labels use :not(:placeholder-shown) — placeholder must be a space " "
✅ CSS custom properties (variables) make theming effortless
✅ :focus-visible shows focus ring for keyboard users, not mouse
✅ Dark mode with @media (prefers-color-scheme: dark) and CSS variables
✅ Transform + transition for hover lift effect on buttons
✅ :not(:placeholder-shown):valid/:invalid for post-interaction validation styles
❌ Never rely on CSS-only validation to actually secure your form — use server validation
❌ Floating label placeholder must be a space " " not empty — required for the CSS trick
''',
  quiz: [
    Quiz(question: 'Why must the placeholder attribute be a space (" ") for the floating label CSS trick?', options: [
      QuizOption(text: ':not(:placeholder-shown) only triggers when there is a placeholder — a space satisfies this', correct: true),
      QuizOption(text: 'Empty placeholder causes layout issues', correct: false),
      QuizOption(text: 'A space placeholder displays the label by default', correct: false),
      QuizOption(text: 'It prevents the browser from showing its own placeholder text', correct: false),
    ]),
    Quiz(question: 'What CSS selector shows the floating label only after user interaction (not on page load)?', options: [
      QuizOption(text: '.form-input:not(:placeholder-shown):invalid — shows error only after user typed something', correct: true),
      QuizOption(text: '.form-input:invalid — shows on page load too', correct: false),
      QuizOption(text: '.form-input:touched — not a real CSS selector', correct: false),
      QuizOption(text: '.form-input:focus:invalid — only while focused', correct: false),
    ]),
    Quiz(question: 'What is the main benefit of using CSS custom properties (variables) for a color system?', options: [
      QuizOption(text: 'Change one variable and the entire theme updates — dark mode in one @media block', correct: true),
      QuizOption(text: 'Custom properties are faster than regular CSS values', correct: false),
      QuizOption(text: 'They work in all CSS properties including content', correct: false),
      QuizOption(text: 'They are required for CSS animations to work', correct: false),
    ]),
  ],
);
