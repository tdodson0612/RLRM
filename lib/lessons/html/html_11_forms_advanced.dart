// lib/lessons/html/html_11_forms_advanced.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson11 = Lesson(
  language: 'HTML',
  title: 'Forms: Advanced Input Types and Validation',
  content: '''
🎯 METAPHOR:
HTML5 input types are like specialized tools in a toolbox.
Before HTML5, web developers had one tool: type="text".
Need a date picker? Build it in JavaScript. Need a color
picker? Build it in JavaScript. Email validation? JavaScript.
HTML5 handed developers a full toolbox — specialized inputs
for every job. The browser provides a native, accessible,
mobile-optimized UI for each one. A date input on iOS opens
the iOS date wheel. A color input opens the OS color picker.
A range input gives a slider. All for free. All accessible.
All validated automatically. Use these gifts.

📖 EXPLANATION:
ALL INPUT TYPES:
  text, password, email, url, tel, search
  number, range, date, time, datetime-local,
  month, week, color, file, checkbox, radio,
  hidden, submit, reset, button, image

ADVANCED VALIDATION:
  required         — must have a value
  pattern="regex"  — must match regular expression
  min, max         — range limits
  step             — allowed increments
  minlength, maxlength — text length limits
  multiple         — allow multiple values (email, file)
  accept           — file types for file input

FORM FEATURES:
  <output>  — display calculation result
  <meter>   — gauge/scalar measurement
  <progress> — progress indicator
  <datalist> — autocomplete suggestions
  form="form-id" — input outside the form element

CONSTRAINT VALIDATION API:
  setCustomValidity("message") — custom error message
  checkValidity() — returns true/false
  reportValidity() — shows native error UI

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Advanced Forms</title>
</head>
<body>

<!-- ─── ALL THE INPUT TYPES ─── -->
<form>

  <!-- TEXT VARIANTS -->
  <label for="search">Search:</label>
  <input type="search" id="search" name="q" placeholder="Search...">

  <label for="url-field">Website:</label>
  <input type="url" id="url-field" name="website"
    placeholder="https://example.com">

  <!-- NUMBER AND RANGE -->
  <label for="qty">Quantity (1-100):</label>
  <input type="number" id="qty" name="qty"
    min="1" max="100" step="1" value="1">

  <label for="volume">Volume:</label>
  <input
    type="range"
    id="volume"
    name="volume"
    min="0"
    max="100"
    step="5"
    value="50"
    oninput="volumeOutput.value = this.value"
  >
  <output id="volumeOutput" for="volume">50</output>

  <!-- DATE AND TIME -->
  <label for="birthday">Birthday:</label>
  <input type="date" id="birthday" name="birthday"
    min="1900-01-01" max="2010-12-31">

  <label for="meeting-time">Meeting time:</label>
  <input type="time" id="meeting-time" name="meeting"
    min="09:00" max="18:00" step="900">
  <!-- step="900" = 15-minute increments -->

  <label for="appointment">Appointment:</label>
  <input type="datetime-local" id="appointment" name="appointment">

  <label for="month">Month:</label>
  <input type="month" id="month" name="month">

  <label for="week">Week:</label>
  <input type="week" id="week" name="week">

  <!-- COLOR PICKER -->
  <label for="fav-color">Favorite Color:</label>
  <input type="color" id="fav-color" name="color" value="#6c63ff">

  <!-- FILE INPUT -->
  <label for="resume">Resume (PDF or DOC):</label>
  <input
    type="file"
    id="resume"
    name="resume"
    accept=".pdf,.doc,.docx,application/pdf"
  >

  <!-- Multiple files -->
  <label for="gallery">Upload Photos:</label>
  <input
    type="file"
    id="gallery"
    name="photos"
    accept="image/*"
    multiple
    capture="environment"
  >
  <!-- capture="environment" opens camera on mobile! -->

  <!-- ─── VALIDATION ─── -->
  <!-- Pattern validation -->
  <label for="postal">US Zip Code:</label>
  <input
    type="text"
    id="postal"
    name="zip"
    pattern="[0-9]{5}(-[0-9]{4})?"
    placeholder="12345 or 12345-6789"
    title="Five digit zip code, optionally followed by a dash and four digits"
  >

  <!-- Email with multiple -->
  <label for="emails">CC Emails:</label>
  <input
    type="email"
    id="emails"
    name="cc"
    multiple
    placeholder="alice@example.com, bob@example.com"
  >

  <!-- Custom validation message -->
  <label for="username">Username:</label>
  <input
    type="text"
    id="username"
    name="username"
    pattern="[a-zA-Z0-9_]{3,20}"
    title="3-20 characters: letters, numbers, underscores only"
    required
    oninvalid="this.setCustomValidity('Username must be 3-20 chars: letters, numbers, underscores')"
    oninput="this.setCustomValidity('')"
  >

  <!-- ─── METER AND PROGRESS ─── -->
  <!-- meter: a scalar measurement with min/max/optimal -->
  <label>Disk Usage:</label>
  <meter
    value="70"
    min="0"
    max="100"
    low="30"
    high="70"
    optimum="20"
    title="70 GB used of 100 GB"
  >
    70 GB used
  </meter>

  <!-- progress: completion of a task -->
  <label>Upload Progress:</label>
  <progress value="65" max="100">65%</progress>

  <!-- Indeterminate progress (no value) -->
  <progress>Loading...</progress>

  <!-- ─── OUTPUT ELEMENT ─── -->
  <form oninput="result.value = parseInt(a.value) + parseInt(b.value)">
    <input type="number" id="a" name="a" value="10">
    +
    <input type="number" id="b" name="b" value="5">
    =
    <output name="result" for="a b">15</output>
  </form>

  <!-- ─── INPUT OUTSIDE FORM (using form attribute) ─── -->
  <button type="submit" form="my-remote-form">
    Submit Form from Outside
  </button>

</form>

<!-- This form is submitted by the button above -->
<form id="my-remote-form" action="/submit" method="POST">
  <input type="text" name="value" value="remote input">
</form>

</body>
</html>

📝 KEY POINTS:
✅ type="date", "time", "color" give native browser UI — no JS library needed
✅ pattern attribute accepts regex for custom format validation
✅ multiple on type="email" allows comma-separated email addresses
✅ capture="environment" on file input opens the device camera
✅ setCustomValidity("") (empty string) clears a custom validation message
✅ <meter> is for measurements; <progress> is for task completion
✅ form="id" lets inputs outside the <form> element belong to it
❌ Don't use type="text" for emails and URLs — use type="email" and type="url"
❌ The title attribute on an input is shown as the validation tooltip
''',
  quiz: [
    Quiz(question: 'What does capture="environment" on a file input do?', options: [
      QuizOption(text: 'Opens the device\'s rear camera on mobile for photo capture', correct: true),
      QuizOption(text: 'Captures the current screen state', correct: false),
      QuizOption(text: 'Saves the file to an environment variable', correct: false),
      QuizOption(text: 'Restricts files to the current environment\'s folder', correct: false),
    ]),
    Quiz(question: 'What is the semantic difference between <meter> and <progress>?', options: [
      QuizOption(text: '<meter> is for scalar measurements; <progress> is for task completion percentage', correct: true),
      QuizOption(text: 'They are identical — just different styling', correct: false),
      QuizOption(text: '<progress> shows a value; <meter> shows animation', correct: false),
      QuizOption(text: '<meter> requires JavaScript; <progress> does not', correct: false),
    ]),
    Quiz(question: 'How do you clear a custom validation message set with setCustomValidity()?', options: [
      QuizOption(text: 'Call setCustomValidity("") with an empty string', correct: true),
      QuizOption(text: 'Call clearCustomValidity()', correct: false),
      QuizOption(text: 'Remove the oninvalid attribute', correct: false),
      QuizOption(text: 'Set the pattern attribute to .*', correct: false),
    ]),
  ],
);
