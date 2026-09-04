# Cosmic Journey

A mobile app that shows, in real time, how long and how far a person has travelled through space since birth.

## Core experience

The main screen shows only:
- distance travelled in kilometres;
- total days since birth;
- total seconds since birth;
- a minimal menu control.

The magic of the product is the continuous motion of the numbers.

## Product principles

- Minimal main screen.
- No registration in MVP.
- Birth data stored locally.
- Core app works offline.
- Base version is free.
- Cosmic Pro is a one-time purchase.
- No ads on the main screen.
- Scientific assumptions are documented and replaceable.

## Platforms

- iOS
- Android

## Recommended stack

- Flutter
- Dart
- Local storage
- Local notifications
- In-app purchases
- Optional ads only in secondary screens

## Repository structure

```text
cosmic-journey/
├── README.md
├── AGENTS.md
├── docs/
│   ├── PRODUCT_OVERVIEW.md
│   ├── PRODUCT_SPEC.md
│   ├── ARCHITECTURE.md
│   └── design/
└── app/
```

## First development milestone

Create a Flutter app that:
1. lets the user enter a birth year;
2. stores it locally;
3. calculates elapsed days and seconds;
4. calculates estimated cosmic distance;
5. renders the three values on a live animated screen;
6. recalculates correctly after background/resume.

Read `AGENTS.md` and the files in `docs/` before implementing features.
