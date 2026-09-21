<!-- docs/TEST_PLAN.md -->

# RLRM test plan

## Run everything
```bash
flutter analyze
flutter test
```

## Your checklist and where each item is tested
| Checklist item | Automated test | Also check on a phone |
|---|---|---|
| First launch, rank, mode, focus | `test/e2e/journey_test.dart` (first launch), `test/features/onboarding_test.dart` | Fresh install shows the welcome screen |
| Navigation | `test/widget_test.dart`, journeys | All five tabs open and come back |
| Roadmap, skill pages, dependencies | `curriculum_data_test.dart`, `skill_detail_screen_test.dart`, journeys | Open Beginner, Gold and SSL skills |
| Training packs, Copy Code | `training_screen_test.dart`, `release_checks_test.dart` | Copy a code, paste it into Notes |
| Progress persistence | `journey_test.dart` (closing and reopening), `progress_provider_test.dart` | Tick a box, force-close the app, reopen |
| Skill completion, mastery and match tests | `progress_logic_test.dart`, `product_checks_test.dart` | Finish a skill's checks and watch the status change |
| "I already know this" | `skill_progress_test.dart`, journey (skipping ahead) | Try it on a later stage |
| "I'm struggling" | `skill_progress_test.dart` | Open the help sheet |
| Next-skill recommendations | `recommendation_test.dart`, `home_screen_test.dart`, journeys | Home names a skill and says why |
| Training sessions | `session_generator_test.dart`, `session_screen_test.dart`, journeys | Build a 10, 30 and 60 minute session |
| Maintenance | `maintenance_test.dart`, `maintenance_screen_test.dart` | Not testable without waiting; the unit tests fake the dates |
| Search, favorites | `search_test.dart`, `favorites_test.dart`, `search_favorites_test.dart` | Search "flick", heart a skill, find it in Favorites |
| Reset progress | journey (settings) | Reset, confirm the roadmap is blank |
| Dark and light | `appearance_test.dart`, `accessibility_test.dart` | Switch in Settings, look at every tab |
| Offline | `release_checks_test.dart` | Airplane mode: use every tab |
| Controller customization | `control_bindings_test.dart`, journey (settings) | Change Boost, open Boost Basics |
| No made-up pack codes | `release_checks_test.dart` (packs) | Load each code in-game (see below) |
| Legal notices | `legal_test.dart`, `release_checks_test.dart` | Read Settings > About & legal |

## The four final questions
`test/e2e/product_checks_test.dart` asks each one of the real curriculum:
1. A Bronze player with no idea gets a clear next step, and why.
2. Thirty minutes says what, how, where, what success looks like, and what comes after.
3. A player can skip ahead and nothing breaks.
4. The curriculum teaches use in matches, and mechanics alone never count as mastered.

## On-device checklist (about 10 minutes)
1. Install fresh. Confirm the welcome screen, then finish setup.
2. Turn on airplane mode. Use every tab, open a lesson, build a session.
3. Tick some boxes, force-close the app, reopen. Progress is still there.
4. Change Boost to another button. Open Boost Basics and see it.
5. Switch to Light, look at every tab, switch back.
6. Turn on VoiceOver or TalkBack and open Home. Each button and progress bar is read out.
7. Set the phone's text size to the largest. Nothing overlaps or is cut off.
8. Load each training pack code in Rocket League. Note which load and match their name.

## Known gaps before release
- **Training packs are unchecked in-game.** All 16 come from official Rocket League news posts from 2019 and 2020 and are marked "needs verification". A release build hides them until you mark the working ones active.
- **Later stages are thinner.** Gold and above have shorter lessons than Beginner to Silver. Champion, Grand Champion and SSL are drafts.
- **The stat thresholds are guesses.** Only four exist, and nothing reads them yet.
- **Photo Stat Check is not built.** The data format is ready.
- **The name.** The "RL" in "RLRM" is a gray area under Epic's trademark rule.
- **Contact email** is still a placeholder in the privacy policy and store listing.
- **I could not run the app.** Everything above was written without a Flutter toolchain, so your test results are the only proof that it runs.