<!-- docs/LEGAL_CHECKLIST.md -->

# Legal checklist: RLRM

Not legal advice. Source: Epic Games Fan Content Policy
(https://legal.epicgames.com/epicgames/fan-art-policy), last read 2026-09-19.
Epic may change the policy or withdraw permission at any time (section 1.5), so
re-read it before every release and update `LegalText.policyCheckedOn`.

## What the policy covers
Personal, non-commercial fan content, including free public apps. Section 2 says
Epic's terms and the game's own EULA still apply. Nothing in this app touches the
game (no memory reading, no automation), so there is no conflict with them.

## Rules and how the app complies
| Policy | Requirement (paraphrased) | Status |
|---|---|---|
| 1.4 | No monetary objective | OK. No ads, purchases, donations, affiliate or sponsored links. Do not add any. |
| 1.6, 1.8 | Never imply endorsement; must not look official | OK. Own name, palette, icon and typeface; About page and store text say unofficial. Never call packs, stats or results "official" or "verified by the game". |
| 1.7 | No links to cheat or hack sites | OK so far: pack sources are official Rocket League news posts. Keep it that way. |
| 1.10 | Show Epic's exact disclaimer | In the app: done (About page). In the store listing: paste it into `docs/STORE_LISTING.md`. |
| 1.11 | Game marks only to discuss the game; never alter them; no look-alike domains | OK today (no logos, no title in the name, no game assets). Gray area: the "RL" in "RLRM". |

## Done
- About & legal page, with the unofficial notice, the Epic notice, credits and data versions
- Open-source licenses page, including the typeface license
- Original app icon (a road with waypoints) and a bundled open-license typeface
- Store listing and privacy policy drafts (`docs/STORE_LISTING.md`, `docs/PRIVACY_POLICY.md`)
- No network code: the release app does not use the internet

## Before release
1. Try each training pack in-game. Only packs you have seen load and match their name should be marked active.
2. Decide the name risk (the "RL" in "RLRM"): keep "Unofficial" in the store title, get a short legal review, or pick a name without "RL".
3. Bundle/application ID and any website domain must not contain the game's name.
4. Host the privacy policy at a public URL. A free option: put the repo on GitHub, then Settings > Pages > deploy from the `/docs` folder.
5. Store screenshots and video: app screens only. No game footage or logos.
6. Fill in your contact email in the privacy policy and the store listing.
7. Re-read Epic's policy and both stores' trademark and impersonation rules. Update `policyCheckedOn`.
8. Keep the app free of ads, accounts and chat (the game has younger players).
9. If the optional photo Stat Check is added later: on-device only, no upload, photo discarded after reading, clear camera and photo permission text, and update the privacy policy first.