// lib/lessons/html/html_19_microdata_schema.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson19 = Lesson(
  language: 'HTML',
  title: 'Microdata, Schema.org, and Structured Data',
  content: '''
🎯 METAPHOR:
Your HTML describes what users SEE. Structured data tells
search engines what your content MEANS. It is like the
difference between a menu and a receipt. The menu shows
diners beautiful descriptions. The receipt tells the
accounting system exactly what was sold, at what price,
to whom. Google's search engine is the accounting system.
It reads your receipt (structured data) to know:
"This is a 4.5-star restaurant" → shows star ratings in
search results. "This product costs \$14.99" → shows price
in Shopping. "This event is on July 4th" → shows in Events.
Rich results. More clicks. Better search visibility.

📖 EXPLANATION:
STRUCTURED DATA — machine-readable metadata about content.
Three formats:
  1. JSON-LD (recommended by Google) — separate <script> block
  2. Microdata — attributes in HTML elements
  3. RDFa — attributes in HTML elements

SCHEMA.ORG — the vocabulary:
  Agreed-upon types and properties maintained by
  Google, Microsoft, Yahoo, and Yandex.
  Types: Organization, Person, Product, Recipe, Event,
         Article, FAQPage, BreadcrumbList, LocalBusiness,
         WebSite, Movie, Book, Course, JobPosting...

JSON-LD EXAMPLE TYPES:
  Article, BlogPosting, NewsArticle
  Product, Offer
  Recipe
  Event
  Person, Organization
  LocalBusiness, Restaurant
  FAQPage
  BreadcrumbList
  WebSite (for sitelinks searchbox)
  Review, AggregateRating

RICH RESULTS IN GOOGLE:
  Stars/ratings on products
  Recipe details in search
  Event dates and locations
  Job listings
  FAQ dropdowns
  Product prices and availability

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Ethiopian Light Roast Coffee — BeanCo</title>

  <!-- ─── JSON-LD STRUCTURED DATA (Google preferred) ─── -->

  <!-- PRODUCT with rating and offer -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Product",
    "name": "Ethiopian Light Roast Coffee",
    "image": [
      "https://beancocoffee.com/images/ethiopian-1x1.jpg",
      "https://beancocoffee.com/images/ethiopian-4x3.jpg",
      "https://beancocoffee.com/images/ethiopian-16x9.jpg"
    ],
    "description": "A bright, fruity light roast from the Yirgacheffe region of Ethiopia, with notes of jasmine and blueberry.",
    "sku": "ETH-LR-250",
    "brand": {
      "@type": "Brand",
      "name": "BeanCo Coffee"
    },
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "reviewCount": "247"
    },
    "offers": {
      "@type": "Offer",
      "url": "https://beancocoffee.com/products/ethiopian-light-roast",
      "priceCurrency": "USD",
      "price": "14.99",
      "availability": "https://schema.org/InStock",
      "itemCondition": "https://schema.org/NewCondition"
    }
  }
  </script>

  <!-- BREADCRUMB -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "https://beancocoffee.com"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "Shop",
        "item": "https://beancocoffee.com/shop"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "Ethiopian Light Roast",
        "item": "https://beancocoffee.com/products/ethiopian-light-roast"
      }
    ]
  }
  </script>
</head>
<body>

  <!-- ─── VISIBLE BREADCRUMB (matches JSON-LD above) ─── -->
  <nav aria-label="Breadcrumb">
    <ol>
      <li><a href="/">Home</a></li>
      <li><a href="/shop">Shop</a></li>
      <li aria-current="page">Ethiopian Light Roast</li>
    </ol>
  </nav>

  <main>
    <h1>Ethiopian Light Roast Coffee</h1>
    <!-- product content -->

    <!-- ─── MICRODATA APPROACH (alternative to JSON-LD) ─── -->
    <!-- Uses itemscope, itemtype, itemprop on HTML elements -->
    <article
      itemscope
      itemtype="https://schema.org/Product"
    >
      <h2 itemprop="name">Ethiopian Yirgacheffe Light Roast</h2>

      <img
        itemprop="image"
        src="/images/yirgacheffe.jpg"
        alt="Ethiopian Yirgacheffe light roast coffee beans"
      >

      <p itemprop="description">
        Bright and fruity with notes of jasmine and blueberry.
      </p>

      <div
        itemprop="aggregateRating"
        itemscope
        itemtype="https://schema.org/AggregateRating"
      >
        <span itemprop="ratingValue">4.8</span> stars
        (<span itemprop="reviewCount">247</span> reviews)
      </div>

      <div
        itemprop="offers"
        itemscope
        itemtype="https://schema.org/Offer"
      >
        <span itemprop="priceCurrency" content="USD">\$</span>
        <span itemprop="price">14.99</span>
        <link itemprop="availability" href="https://schema.org/InStock">
        In Stock
      </div>
    </article>

    <!-- ─── FAQ PAGE SCHEMA ─── -->
    <section id="faq">
      <h2>Frequently Asked Questions</h2>
    </section>

    <!-- JSON-LD for FAQ -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "How should I store my coffee beans?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Store in an airtight container away from light, heat, and moisture. Avoid the refrigerator — condensation damages beans. A cool dark pantry is ideal."
          }
        },
        {
          "@type": "Question",
          "name": "What grind size should I use for espresso?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Use a fine grind for espresso — similar to table salt. The grind should be fine enough that a 9-bar pump takes 25-30 seconds to pull a 36g shot from 18g of grounds."
          }
        }
      ]
    }
    </script>

    <!-- ─── ARTICLE SCHEMA ─── -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "headline": "The Complete Guide to Light Roast Coffee",
      "image": "https://beancocoffee.com/images/guide-og.jpg",
      "datePublished": "2024-03-15",
      "dateModified": "2024-06-01",
      "author": {
        "@type": "Person",
        "name": "Alice Chen",
        "url": "https://beancocoffee.com/authors/alice"
      },
      "publisher": {
        "@type": "Organization",
        "name": "BeanCo Coffee",
        "logo": {
          "@type": "ImageObject",
          "url": "https://beancocoffee.com/logo.png"
        }
      }
    }
    </script>
  </main>
</body>
</html>

─────────────────────────────────────
TEST YOUR STRUCTURED DATA:
─────────────────────────────────────
Google Rich Results Test:
  search.google.com/test/rich-results

Schema.org Validator:
  validator.schema.org

Google Search Console:
  Checks real-time rich result status
─────────────────────────────────────

📝 KEY POINTS:
✅ JSON-LD is Google's preferred format — add it in a <script type="application/ld+json">
✅ Structured data must accurately reflect visible page content — no hidden info
✅ Product schema can unlock star ratings, price, and availability in search results
✅ FAQPage schema can create expandable FAQ dropdowns directly in Google results
✅ BreadcrumbList schema shows the page hierarchy in search results URLs
✅ Test your markup at search.google.com/test/rich-results before deploying
❌ Don't add structured data for content that isn't visible on the page
❌ Fake reviews or false product data in schema violates Google's guidelines
''',
  quiz: [
    Quiz(question: 'What is the recommended format for adding structured data to HTML pages?', options: [
      QuizOption(text: 'JSON-LD in a <script type="application/ld+json"> block', correct: true),
      QuizOption(text: 'Microdata using itemscope and itemprop attributes', correct: false),
      QuizOption(text: 'RDFa attributes inside HTML elements', correct: false),
      QuizOption(text: 'Meta tags with schema properties', correct: false),
    ]),
    Quiz(question: 'What can Product schema markup unlock in Google search results?', options: [
      QuizOption(text: 'Star ratings, price, and availability shown directly in search snippets', correct: true),
      QuizOption(text: 'Priority ranking in search results', correct: false),
      QuizOption(text: 'A dedicated product listing in Google Shopping automatically', correct: false),
      QuizOption(text: 'A verified checkmark next to the site name', correct: false),
    ]),
    Quiz(question: 'What is Schema.org?', options: [
      QuizOption(text: 'A shared vocabulary of types and properties maintained by Google, Microsoft, Yahoo, and Yandex', correct: true),
      QuizOption(text: 'A CSS framework for styling schema markup', correct: false),
      QuizOption(text: 'Google\'s proprietary structured data format', correct: false),
      QuizOption(text: 'A validator tool for HTML', correct: false),
    ]),
  ],
);
