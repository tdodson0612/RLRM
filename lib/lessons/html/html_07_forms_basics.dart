// lib/lessons/html/html_07_forms_basics.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson07 = Lesson(
  language: 'HTML',
  title: 'Forms: The Basics',
  content: '''
🎯 METAPHOR:
A form is a conversation between your website and its visitor.
"What's your name?" — text input.
"Choose your preference." — radio buttons.
"Select all that apply." — checkboxes.
"Tell us more." — textarea.
Every signup, login, search bar, comment box, checkout page,
and survey you have ever filled out is an HTML form.
Forms are how the web goes from passive reading to active
participation. They are the moment your website stops
broadcasting and starts listening.

📖 EXPLANATION:
<form> — container for all form elements
  action   — URL to send data to
  method   — GET (in URL) or POST (in body)
  enctype  — for file uploads: multipart/form-data
  novalidate — skip browser validation

<label> — pairs with an input, crucial for accessibility
  for="input-id" — links to input's id

INPUT TYPES (beginner set):
  text       — single line text
  email      — email with validation
  password   — hidden text
  number     — numeric input
  tel        — telephone number
  url        — URL with validation
  search     — search field
  date       — date picker
  time       — time picker
  checkbox   — boolean toggle
  radio      — single choice from group
  file       — file upload
  hidden     — invisible data field
  submit     — submit button
  reset      — reset button
  button     — generic button

COMMON ATTRIBUTES:
  id, name, value, placeholder, required, disabled,
  readonly, autofocus, autocomplete, min, max, step,
  minlength, maxlength, pattern, multiple

<textarea> — multi-line text input
<select> + <option> — dropdown menu
<optgroup> — group options in select
<button> — clickable button
<fieldset> + <legend> — group related inputs
<datalist> — autocomplete suggestions
<output> — display calculation result
<meter> — scalar measurement
<progress> — progress bar

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Form Basics</title>
</head>
<body>

<form action="/submit" method="POST">

  <!-- ─── FIELDSET + LEGEND ─── -->
  <fieldset>
    <legend>Personal Information</legend>

    <!-- LABEL + INPUT: always pair them! -->
    <label for="name">Full Name *</label>
    <input
      type="text"
      id="name"
      name="name"
      placeholder="Alice Johnson"
      required
      autocomplete="name"
    >

    <label for="email">Email Address *</label>
    <input
      type="email"
      id="email"
      name="email"
      placeholder="alice@example.com"
      required
      autocomplete="email"
    >

    <label for="password">Password *</label>
    <input
      type="password"
      id="password"
      name="password"
      minlength="8"
      required
      autocomplete="new-password"
    >

    <label for="phone">Phone Number</label>
    <input
      type="tel"
      id="phone"
      name="phone"
      placeholder="+1 (555) 000-0000"
      autocomplete="tel"
    >

    <label for="dob">Date of Birth</label>
    <input
      type="date"
      id="dob"
      name="dob"
      min="1900-01-01"
      max="2010-12-31"
    >

    <label for="age">Age</label>
    <input
      type="number"
      id="age"
      name="age"
      min="0"
      max="120"
      step="1"
    >
  </fieldset>

  <!-- ─── TEXTAREA ─── -->
  <fieldset>
    <legend>About You</legend>

    <label for="bio">Short Bio</label>
    <textarea
      id="bio"
      name="bio"
      rows="4"
      cols="50"
      placeholder="Tell us a little about yourself..."
      maxlength="500"
    ></textarea>
  </fieldset>

  <!-- ─── RADIO BUTTONS ─── -->
  <fieldset>
    <legend>Preferred Contact Method</legend>

    <!-- All radios in same group share the same name -->
    <label>
      <input type="radio" name="contact" value="email" checked>
      Email
    </label>
    <label>
      <input type="radio" name="contact" value="phone">
      Phone
    </label>
    <label>
      <input type="radio" name="contact" value="text">
      Text Message
    </label>
  </fieldset>

  <!-- ─── CHECKBOXES ─── -->
  <fieldset>
    <legend>Interests</legend>

    <label>
      <input type="checkbox" name="interests" value="html"> HTML
    </label>
    <label>
      <input type="checkbox" name="interests" value="css"> CSS
    </label>
    <label>
      <input type="checkbox" name="interests" value="javascript"> JavaScript
    </label>
  </fieldset>

  <!-- ─── SELECT DROPDOWN ─── -->
  <label for="country">Country</label>
  <select id="country" name="country" autocomplete="country-name">
    <option value="">-- Select your country --</option>
    <optgroup label="North America">
      <option value="us">United States</option>
      <option value="ca">Canada</option>
      <option value="mx">Mexico</option>
    </optgroup>
    <optgroup label="Europe">
      <option value="uk">United Kingdom</option>
      <option value="de">Germany</option>
      <option value="fr">France</option>
    </optgroup>
  </select>

  <!-- ─── DATALIST (autocomplete suggestions) ─── -->
  <label for="browser">Favorite Browser</label>
  <input list="browsers" id="browser" name="browser">
  <datalist id="browsers">
    <option value="Chrome">
    <option value="Firefox">
    <option value="Safari">
    <option value="Edge">
    <option value="Opera">
  </datalist>

  <!-- ─── FILE UPLOAD ─── -->
  <label for="avatar">Profile Picture</label>
  <input
    type="file"
    id="avatar"
    name="avatar"
    accept="image/png, image/jpeg, image/webp"
  >

  <!-- ─── HIDDEN FIELD ─── -->
  <input type="hidden" name="csrf_token" value="abc123xyz">

  <!-- ─── BUTTONS ─── -->
  <button type="submit">Create Account 🚀</button>
  <button type="reset">Clear Form</button>
  <button type="button" onclick="doSomething()">Custom Action</button>

</form>

</body>
</html>

📝 KEY POINTS:
✅ ALWAYS pair every input with a <label> using matching for/id attributes
✅ Use <fieldset> and <legend> to group related inputs — crucial for accessibility
✅ name attribute is what gets sent to the server — required on all inputs
✅ Radio buttons in a group must share the same name attribute
✅ autocomplete hints help browsers autofill correctly
✅ required, minlength, max etc. give browser native validation for free
❌ Never use placeholder as a replacement for a label
❌ type="button" does NOT submit the form; type="submit" does
''',
  quiz: [
    Quiz(question: 'Why must every input have a matching <label>?', options: [
      QuizOption(text: 'Screen readers need it to announce what the input is, and it enlarges the click target', correct: true),
      QuizOption(text: 'Labels are required for forms to submit', correct: false),
      QuizOption(text: 'Labels apply styling to inputs', correct: false),
      QuizOption(text: 'Without labels, inputs won\'t display in the browser', correct: false),
    ]),
    Quiz(question: 'How do you group radio buttons so only one can be selected?', options: [
      QuizOption(text: 'Give all radio inputs the same name attribute', correct: true),
      QuizOption(text: 'Wrap them in a <radiogroup> element', correct: false),
      QuizOption(text: 'Give them all the same id attribute', correct: false),
      QuizOption(text: 'Add the exclusive attribute to each radio input', correct: false),
    ]),
    Quiz(question: 'What is the difference between method="GET" and method="POST" on a form?', options: [
      QuizOption(text: 'GET appends data to the URL; POST sends data in the request body (more secure for sensitive data)', correct: true),
      QuizOption(text: 'GET is faster; POST is more secure', correct: false),
      QuizOption(text: 'POST is for file uploads only; GET is for text', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
    ]),
  ],
);
