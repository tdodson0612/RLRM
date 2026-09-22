// lib/lessons/css/css_43_form_styling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson43 = Lesson(
  language: 'CSS',
  title: 'Styling Forms and Inputs',
  content: '''
🎯 METAPHOR:
Forms are the most stubbornly ugly parts of the web by
default. Browsers have strong opinions about how inputs,
selects, checkboxes, and buttons should look — and those
opinions differ wildly between operating systems and browsers.
Styling forms is like renovating a kitchen where every
appliance brand has different mounting standards. Some
parts clean up easily (text inputs), some need creative
workarounds (file inputs, select dropdowns), and some
are basically untouchable without JavaScript (date pickers).
The key property is appearance: none — the sledgehammer
that strips browser defaults so you can build your own.

📖 EXPLANATION:
FORM STYLING CHALLENGES:
  - Browser and OS apply their own default styles
  - appearance: none removes platform styling
  - Some inputs (file, color, date) resist full styling
  - :focus, :valid, :invalid, :disabled states all need styles

KEY PROPERTIES:
  appearance: none         remove browser UI chrome
  accent-color: #color     tint checkboxes, radios, range, progress
  resize: none | both      control textarea resize handle
  outline: none            remove default focus ring (always replace it!)
  caret-color: #color      style the text cursor blink color
  field-sizing: content    input sizes to its content (new!)

💻 CODE:
/* ─── TEXT INPUT BASE STYLE ─── */
input[type="text"],
input[type="email"],
input[type="password"],
input[type="number"],
input[type="search"],
input[type="tel"],
input[type="url"],
textarea,
select {
  appearance: none;
  -webkit-appearance: none;
  display: block;
  width: 100%;
  padding: 0.625rem 0.875rem;
  font-size: 1rem;
  font-family: inherit;
  color: #333;
  background: #fff;
  border: 1.5px solid #d0d0d0;
  border-radius: 6px;
  line-height: 1.5;
  transition: border-color 0.15s, box-shadow 0.15s;
  outline: none;
}

/* Focus state */
input:focus,
textarea:focus,
select:focus {
  border-color: #6c63ff;
  box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.15);
}

/* Error state */
input:invalid:not(:placeholder-shown),
input.error {
  border-color: #e53935;
  box-shadow: 0 0 0 3px rgba(229, 57, 53, 0.12);
}

/* Valid state */
input:valid:not(:placeholder-shown) {
  border-color: #43a047;
}

/* Disabled state */
input:disabled,
textarea:disabled,
select:disabled {
  background: #f5f5f5;
  color: #aaa;
  cursor: not-allowed;
  border-color: #e0e0e0;
}

/* Placeholder */
::placeholder {
  color: #aaa;
  opacity: 1;
}

/* ─── TEXTAREA ─── */
textarea {
  resize: vertical;           /* only vertical resize */
  min-height: 120px;
}

/* ─── SELECT DROPDOWN ─── */
select {
  padding-right: 2.5rem;      /* space for custom arrow */
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='%23666' d='M8 11L3 6h10z'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 1rem;
  cursor: pointer;
}

/* ─── CHECKBOX & RADIO — accent-color approach ─── */
/* Easiest: just tint with accent-color */
input[type="checkbox"],
input[type="radio"] {
  accent-color: #6c63ff;
  width: 1.1rem;
  height: 1.1rem;
  cursor: pointer;
}

/* ─── CHECKBOX — fully custom ─── */
.custom-checkbox {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}

.custom-checkbox input[type="checkbox"] {
  appearance: none;
  -webkit-appearance: none;
  width: 1.25rem;
  height: 1.25rem;
  border: 2px solid #d0d0d0;
  border-radius: 4px;
  background: white;
  flex-shrink: 0;
  transition: border-color 0.15s, background 0.15s;
  position: relative;
}

.custom-checkbox input[type="checkbox"]:checked {
  background: #6c63ff;
  border-color: #6c63ff;
}

.custom-checkbox input[type="checkbox"]:checked::after {
  content: "";
  position: absolute;
  left: 3px;
  top: 1px;
  width: 10px;
  height: 6px;
  border-left: 2px solid white;
  border-bottom: 2px solid white;
  transform: rotate(-45deg);
}

/* ─── RANGE INPUT ─── */
input[type="range"] {
  appearance: none;
  -webkit-appearance: none;
  width: 100%;
  height: 6px;
  background: #e0e0e0;
  border-radius: 3px;
  outline: none;
  accent-color: #6c63ff;
}

input[type="range"]::-webkit-slider-thumb {
  appearance: none;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: #6c63ff;
  cursor: pointer;
  box-shadow: 0 1px 4px rgba(0,0,0,0.2);
}

input[type="range"]::-moz-range-thumb {
  width: 18px;
  height: 18px;
  border: none;
  border-radius: 50%;
  background: #6c63ff;
  cursor: pointer;
}

/* ─── BUTTON ─── */
button,
input[type="submit"],
input[type="reset"],
input[type="button"] {
  appearance: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  font-size: 1rem;
  font-family: inherit;
  font-weight: 500;
  color: white;
  background: #6c63ff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.15s, transform 0.1s;
  min-width: 44px;
  min-height: 44px;
}

button:hover  { background: #5a52d5; }
button:active { transform: scale(0.98); }
button:focus-visible {
  outline: 3px solid #6c63ff;
  outline-offset: 3px;
}
button:disabled {
  background: #ccc;
  cursor: not-allowed;
  transform: none;
}

/* ─── FORM LABEL ─── */
label {
  display: block;
  margin-bottom: 0.3rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: #444;
}

.required::after {
  content: " *";
  color: #e53935;
}

/* ─── FORM GROUP ─── */
.form-group {
  margin-bottom: 1.25rem;
}

.form-hint {
  margin-top: 0.3rem;
  font-size: 0.8rem;
  color: #888;
}

.form-error {
  margin-top: 0.3rem;
  font-size: 0.8rem;
  color: #e53935;
  display: none;
}

input:invalid:not(:placeholder-shown) ~ .form-error {
  display: block;  /* show error when field is invalid and touched */
}

/* ─── CARET COLOR ─── */
input, textarea {
  caret-color: #6c63ff;
}

📝 KEY POINTS:
✅ appearance: none strips browser defaults — always add your own focus styles after
✅ accent-color is the easiest way to tint checkboxes, radios, range, and progress
✅ Never remove :focus outline without providing a visible replacement
✅ :invalid:not(:placeholder-shown) only shows errors after the user has interacted
✅ Custom select arrows use background-image with an inline SVG data URI
✅ font-family: inherit on inputs prevents browsers from using a different font
❌ Don't try to fully custom-style file inputs, date pickers, or color pickers — use JS libraries
❌ Don't use placeholder text as a label substitute — always include a visible label
''',
  quiz: [
    Quiz(question: 'What does appearance: none do on a form element?', options: [
      QuizOption(text: 'Removes the browser\'s platform-specific styling so you can apply your own', correct: true),
      QuizOption(text: 'Hides the element from the page', correct: false),
      QuizOption(text: 'Removes the element from the accessibility tree', correct: false),
      QuizOption(text: 'Disables the element so it cannot be interacted with', correct: false),
    ]),
    Quiz(question: 'What does accent-color do for form elements?', options: [
      QuizOption(text: 'Tints the browser-native UI of checkboxes, radios, range sliders, and progress bars', correct: true),
      QuizOption(text: 'Sets the text color of all form elements', correct: false),
      QuizOption(text: 'Changes the border color on focus', correct: false),
      QuizOption(text: 'Applies a color theme to the entire form', correct: false),
    ]),
    Quiz(question: 'Why use :invalid:not(:placeholder-shown) instead of just :invalid?', options: [
      QuizOption(text: 'To only show error styles after the user has typed something — not on empty untouched fields', correct: true),
      QuizOption(text: 'To prevent styling required empty fields as errors immediately on page load', correct: false),
      QuizOption(text: 'Both answers above are correct', correct: true),
      QuizOption(text: ':invalid alone does not work on text inputs', correct: false),
    ]),
  ],
);
