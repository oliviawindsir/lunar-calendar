# flutter_lunar_calendar

A cross-platform lunar calendar app built with Flutter and Tyme.

This is created out of the need for a simple, ad-free lunar calendar app.

## Pain points: 
- Google calendar interface looks bloated and messy when we add another alternate calendar. For elderly, it is hard to see and read, especially when there are public holidays and other events.
- Calendar app from Android playstore has a lot of ads. One has to wait and watch for the ads before being able to view the calendar. 
- Is this safe for my parents to use?

## Solution:
- A darn simple, ad-free lunar calendar app that tells you the month and day of the lunar date.
- Easy to use and understand. 
- Ran through `osv-scanner`, `gitleaks` and `trivy` to ensure there are no security vulnerabilities. 
- Scan using MobSF to ensure there are no critical security vulnerabilities. 

## Features: 
- Main display is Gregorian calendar, followed by the lunar date in grey
- Swipe left or right to navigate between months
- Tap on a date to view the lunar date
- Display lunar date and solar term below the date
- That's it. Read-only. 

## Future expansion
- Does this display the public holiday of different countries?
- Can I choose to set alert when it is nearing Day 1 and 15 of each lunar month? 
- Can we have it in PWA so that I can add it to my home screen, without going through the playstore? 

## Getting Started

### Setup
```bash
flutter pub get
```

### Run
```bash
flutter run
```

### Build
```bash
flutter build apk
```

## Notes
- This app has only been tested on the following platform: 
  - Android (manually loading the .apk)
  - Chrome

## Scans
### osv-scanner
```
Starting filesystem walk for root: /
Scanned /home/flutter-calendar/flutter_lunar_calendar/pubspec.lock file and found 42 packages
End status: 0 dirs visited, 1 inodes visited, 1 Extract calls, 1.635042ms elapsed, 1.635ms wall time
No issues found
```

### gitleaks
```
    ○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

5:12PM INF 6 commits scanned.
5:12PM INF scanned ~204488 bytes (204.49 KB) in 272ms
5:12PM INF no leaks found
```

### trivy
```
Report Summary

┌─────────────────────────────────────────────────┬──────┬─────────────────┬─────────┐
│                     Target                      │ Type │ Vulnerabilities │ Secrets │
├─────────────────────────────────────────────────┼──────┼─────────────────┼─────────┤
│ .dart_tool/widget_preview_scaffold/pubspec.lock │ pub  │        0        │    -    │
├─────────────────────────────────────────────────┼──────┼─────────────────┼─────────┤
│ pubspec.lock                                    │ pub  │        0        │    -    │
└─────────────────────────────────────────────────┴──────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)
```

## Acknowledgements
- [Tyme](https://pub.dev/packages/tyme) for providing the lunar calendar flutter package.
- [tyme4dart](https://github.com/6tail/tyme4dart) for providing the base calendar library.