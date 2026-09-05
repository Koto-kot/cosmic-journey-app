# Hosting, CI/CD, and store release

This file is the operational guide for Cosmic Journey: how the web app is
hosted on every push to `main`, and what it takes later to ship iOS and
Android.

## Current pipeline (already in the repo)

GitHub Actions workflow: `.github/workflows/ci.yml`

On every pull request and every push to `main`:

1. Install Flutter 3.47.2 (stable)
2. `dart format --set-exit-if-changed`
3. `flutter analyze`
4. `flutter test`

On a successful **push to `main` only**:

5. `flutter build web --release`
6. Deploy `app/build/web` to **GitHub Pages**

That is the same shape as a typical Flutter team pipeline: quality gates on
every change, a hosted web build only from the default branch.

### One-time GitHub Pages setup

This does **not** run on Cursor's temporary git remote. It runs on GitHub
`Koto-kot/cosmic-journey-app` (public).

The deploy job uses `actions/configure-pages` and `actions/deploy-pages`.
It does **not** create or update the Pages site through the REST API:
`GITHUB_TOKEN` from Actions is not allowed to enable Pages
(`Resource not accessible by integration`, HTTP 403).

Set this once in the GitHub UI:

1. **Settings → Pages → Source: GitHub Actions**
2. Approve the `github-pages` environment under **Settings → Environments**

Hosted URL:

`https://koto-kot.github.io/cosmic-journey-app/`

The workflow sets Flutter `--base-href` from GitHub Pages so assets load on a
project subpath. A copy of `index.html` is published as `404.html` so a refresh
on a nested path still boots the app.

Public GitHub repos get Actions + Pages at no extra cost. Private repos use
the plan's Actions minutes; Pages on a private repo needs GitHub Pro or a
team/enterprise plan.

### Optional later: Firebase Hosting

Use this if you want a custom domain, preview channels per PR, or a CDN
without depending on GitHub Pages.

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com).
2. `npm i -g firebase-tools && firebase login`
3. From the repo root: `firebase init hosting` and set public dir to
   `app/build/web`, SPA rewrite to `/index.html`.
4. Add `FirebaseExtended/action-hosting-deploy` to the workflow and store the
   service-account JSON as a GitHub secret.
5. Keep the same `flutter build web --release` step; only the publish target
   changes.

Spark (free) is enough for an early web preview. Blaze is only needed if you
add paid Firebase products.

## What we could take from CardMedic

The `cardmedic` GitHub org exists, but it has **no public repositories**, so
this session could not read their Flutter CI files, Fastlane setup, or
signing secrets.

Their **public product** is still a useful model:

- Ship a **web/PWA** that works on phone, tablet, and desktop.
- Also ship **App Store and Google Play** binaries of the same product.
- Core experience works **offline**; the hosted web build is how people try it
  without installing anything.

For Cosmic Journey that maps to:

| Now | Later |
| --- | --- |
| GitHub Actions tests | Same tests as a release gate |
| GitHub Pages web host | Custom domain / Firebase if needed |
| No store accounts required | Apple + Google developer accounts |
| No signing | Android keystore + iOS certificates |

Do **not** copy a healthcare app's analytics, accounts, or backend. Cosmic
Journey stays local-first.

## Recommended CI/CD options (when you add stores)

| Option | Best for | Cost (indicative) |
| --- | --- | --- |
| **GitHub Actions (Linux)** | Tests + Flutter web, as we have now | Free on public repos. Private: included minutes (Free plan 2,000 Linux min/month; macOS minutes count ~10×) |
| **GitHub Actions (macOS)** | iOS IPA in the same repo | Same minute pool; macOS is expensive on private repos |
| **Codemagic** | Least-friction iOS signing + TestFlight/Play upload | Personal: 500 free macOS M2 min/month, then about $0.095/min. Linux ~$0.045/min. No free Linux minutes |
| **Fastlane** | Talks to App Store Connect and Play Console | Free tool; you still pay the CI that runs it |
| **Xcode Cloud** | iOS-only Apple-hosted builds | Included with Apple Developer; extra hours billed by Apple |

Practical combo for a small team:

1. Keep **GitHub Actions** for format / analyze / test / web host (already done).
2. When you are ready to ship stores, add **Codemagic** *or* GitHub macOS +
   Fastlane. Codemagic is usually faster to get a first TestFlight build.
3. Do **not** auto-publish to production on every `main` push. Auto-deploy
   **web**. For stores: build on tag (`v1.2.3`) → TestFlight / Play internal
   testing → promote manually.

## Publish to Google Play

### Cost

- Play Console registration: **US$25, one time**
  ([official help](https://support.google.com/googleplay/android-developer/answer/6112435)).
- No annual Google fee after that.
- Cosmic Pro is a **Play Billing subscription** (ADR 0002). Google takes
  **15%** on the first US$1M/year digital goods in a calendar year, **30%**
  after that (consumer app default). Physical goods do not apply here.
  Setup: [`MONETIZATION.md`](MONETIZATION.md).

### New personal accounts (after 13 Nov 2023)

You cannot go straight to production. You must:

1. Run a **closed test** with at least **12 opted-in testers**.
2. Keep them active for **14 continuous days**.
3. Verify an Android device with the Play Console app.
4. Then apply for production access.

Organization Play accounts skip that 12×14 rule. Use an organization account
if you already have a company.

### Steps

1. Register at [play.google.com/console](https://play.google.com/console).
2. Create the app listing (name, default language, app vs game, free vs paid).
3. Complete Data safety, content rating, target audience, and a **privacy
   policy URL**. Even a local-only app needs a policy that says birth year
   stays on device.
4. Create an upload keystore **once** and back it up. Losing it means you
   cannot update the listing.

   ```bash
   keytool -genkey -v -keystore upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

   Point `android/key.properties` at it. Never commit the `.jks` or passwords.
5. Set `applicationId` (already `com.cosmicjourney.cosmic_journey`) and bump
   `version:` in `app/pubspec.yaml` (`1.0.0+1` → `1.0.1+2`). The `+` build
   number must increase every upload.
6. Build the Play artifact (AAB, not APK):

   ```bash
   cd app
   flutter build appbundle --release
   ```

   Output: `app/build/app/outputs/bundle/release/app-release.aab`
7. Upload to **internal testing**, then closed testing, then production.
8. Phone / tablet screenshots, 512×512 icon, short and full description,
   Ukrainian + English listings if you want both.

### Options besides Play Store

- **Sideload APK** / GitHub Releases for testers (`flutter build apk`). Fine
  for friends, not a store.
- **Firebase App Distribution** for testers without Play review.
- **Amazon Appstore** and other stores: skip until Play/App Store exist.

## Publish to the Apple App Store

### Cost

- Apple Developer Program: **US$99 / year**
  ([official programs page](https://developer.apple.com/programs/)).
  Individual or organization. Organization enrollment needs a D-U-N-S number
  and usually takes longer.
- Apple Developer **Enterprise** Program: **US$299 / year** — internal staff
  distribution only. **Not** for the public App Store. Skip it.
- If the membership lapses, the app is removed from the store until you renew.
- Cosmic Pro is an App Store **auto-renewable subscription**. Apple takes
  **15%** under the Small Business Program (under US$1M/year) or **30%**
  standard. Product IDs and Restore: [`MONETIZATION.md`](MONETIZATION.md).

You can install a debug build on your own iPhone with a **free** Apple ID
(Personal Team), but that profile expires in 7 days and you cannot use
TestFlight or the App Store.

### Steps

1. Enroll at [developer.apple.com/programs](https://developer.apple.com/programs/).
2. In [App Store Connect](https://appstoreconnect.apple.com) create the app:
   bundle ID `com.cosmicjourney.cosmic_journey`, name, SKU, primary language.
3. In Apple Developer → Identifiers, create that App ID.
4. Signing (pick one):
   - **Automatic** in Xcode on a Mac: easiest first upload.
   - **Codemagic / Fastlane match**: better once CI uploads every release.
5. Privacy: App Privacy questionnaire, Privacy Manifest
   (`PrivacyInfo.xcprivacy`) if plugins use required-reason APIs, and a
   privacy policy URL. Cosmic Journey should declare that birth year is
   stored only on-device.
6. Build (Mac with Xcode):

   ```bash
   cd app
   flutter build ipa --release
   ```

   Or open `app/ios/Runner.xcworkspace` in Xcode → Product → Archive →
   Distribute to App Store Connect.
7. Upload with Transporter, `xcrun altool`, or Codemagic.
8. Attach the build to a version in App Store Connect, add screenshots
   (6.7" and 6.1" iPhone at minimum), age rating, review notes.
9. Submit. First review is often 24–48 hours; rejections for missing privacy
   text or incomplete metadata are common.

### TestFlight (do this before production)

Included in the $99 membership. Invite up to 10,000 external testers by
email or public link. Use it as the iOS analogue of Play internal/closed
testing.

## Minimum spend to be “in both stores”

| Item | When | Money |
| --- | --- | --- |
| GitHub Pages web host | now | $0 (public repo) |
| Google Play | first Android listing | $25 once |
| Apple Developer | first iOS listing | $99 / year |
| Closed Play testers | personal Play account | $0, but 14 days + 12 people |
| Mac for iOS archive | if you skip Codemagic | hardware you already have, or Codemagic minutes |
| Privacy policy hosting | both stores | $0 if a GitHub Pages `/privacy` page |

So: **web this week is free**. **Both stores ≈ $124 in the first year**, plus
time for listings, screenshots, and Apple/Google review. Year two is $99
unless you drop iOS.

## What not to automate yet

- Production store submit on every `main` push (review + signing risk)
- Live AdMob / StoreKit in `main` until Phase 3 sandbox QA passes
- Analytics SDKs (AGENTS.md forbids them in MVP)
- A backend (only if Phase 3.8 chooses Stripe / webhooks)

Subscription **product setup** (not auto-submit) is documented in
[`MONETIZATION.md`](MONETIZATION.md). The Phase 3 build plan is
[`PHASE_3.md`](PHASE_3.md). Decision history: [`adr/`](adr/README.md).

## Checklist before the first store upload

- [ ] Unique store name and subtitle
- [ ] Privacy policy URL
- [ ] App icon 1024×1024 (replace the default Flutter icon)
- [ ] Screenshots of the live number screen
- [ ] `pubspec.yaml` version bumped
- [ ] Android keystore backed up offline
- [ ] Apple bundle ID matches App Store Connect
- [ ] No GPS, no account, no ads on the main screen (already true)
- [ ] Documented CMB model in-app (Science screen — later milestone)
