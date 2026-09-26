# Design system

> Final Project Design System V2 — submitted September 18, 2026.

## Palette

| Role | Hex | Used for |
|---|---|---|
| `primary` | `#2563EB` | Main buttons, App Bar accents |
| `onPrimary` | `#FFFFFF` | Text/icons on primary buttons |
| `secondary` | `#10B981` | Generic success indicators |
| `statusPending` | `#004AC6` | Pending status text/icons, "Violation Description" section label |
| `statusPendingBg` | `#D9E3F6` | Pending badge background |
| `statusResolved` | `#006C49` | Resolved status text/icons |
| `background` | `#F8F9FF` | Main screen background |
| `surface` | `#FFFFFF` | Cards, forms, dialogs, modal |
| `surfaceTint` | `#DBE1FF` | Stat-card backgrounds (e.g. "Total Reports") |
| `onSurface` | `#1F2937` | Body text, headings, labels |
| `error` | `#DC2626` | Validation errors, failed submissions, destructive actions |
| `scrim` | `rgba(0,0,0,0.5)` | Modal/dialog overlay |

## Type scale

| Style | Flutter slot | Size | Weight | Used for |
|---|---|---|---|---|
| Heading | `headlineSmall` | 28sp | Bold | Screen titles ("Welcome to AGOS," "Submit Report," "Report Details") |
| Body | `bodyMedium` | 16sp | Regular | Descriptions, placeholder text, list body copy |
| Field Label | `bodyMedium` (weight override) | 16sp | Medium | Field labels ("Username," "Description," "Location"), section headers ("Your Reports") |
| Caption | `labelSmall` | 12sp | Regular | Timestamps, hints, helper text |
| Section Label | `labelSmall` (color override) | 12sp | Bold, letter-spaced, `statusPending` blue | Small-caps section labels inside content blocks (e.g. "VIOLATION DESCRIPTION") |

## Spacing

```dart
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;  // spacingTight — closely related elements
  static const double md = 16; // spacingStandard — between sections/components
  static const double lg = 24; // spacingScreen — screen edge padding
}

class AppRadius {
  static const double small = 8;   // badges
  static const double medium = 12; // inputs, image containers
  static const double large = 16;  // cards, modal
  static const double pill = 28;   // buttons — visually near-full pill
}
```

## Components

| Component | Level | File | Constructor parameters | Appears on |
|---|---|---|---|---|
| Primary Button | Atom | `lib/widgets/primary_button.dart` | `String label, VoidCallback? onPressed, IconData? icon, bool isLoading` | Login, Home Dashboard, Submit Report, Report Details |
| Text Input Field | Atom | `lib/widgets/text_input_field.dart` | `String label, String? hint, TextEditingController controller, bool obscureText, String? Function(String?)? validator, IconData? leadingIcon, IconData? trailingIcon, bool multiline` | Login, Submit Report |
| Status Badge | Atom | `lib/widgets/status_badge.dart` | `String status, String label, bool onImage` | Home Dashboard (Report Card), Report Details (photo overlay) |
| Detail Row | Atom | `lib/widgets/detail_row.dart` | `IconData icon, String label, String value` | Report Details |
| Report Card | Molecule | `lib/widgets/report_card.dart` | `String reportTitle, String status, String date, String location, String? imageUrl, VoidCallback onTap` | Home Dashboard |
| Image Upload Component | Molecule | `lib/widgets/image_upload.dart` | `String? image, VoidCallback onUpload, VoidCallback onRemove` | Submit Report |
| Photo Evidence Viewer | Molecule | `lib/widgets/photo_evidence_viewer.dart` | `List<String> images, String? mapThumbnailUrl, String status` | Report Details |
| Stat Summary Card | Molecule | `lib/widgets/stat_summary_card.dart` | `String label, int count, IconData icon, bool highlighted` | Home Dashboard |
| Navigation Header | Organism | `lib/widgets/navigation_header.dart` | `String title, bool showBackButton, VoidCallback? onBack, List<Widget>? actions, bool showBrandIcon` | Home Dashboard, Submit Report, Report History, Report Details |
| Detail Modal | Organism | `lib/widgets/detail_modal.dart` | `String title, VoidCallback onClose, Widget child, Widget? actionButton` | Report Details |

### The theme file, assembled

```dart
// lib/theme.dart
import 'package:flutter/material.dart';

const _primary = Color(0xFF2563EB);
const _secondary = Color(0xFF10B981);
const _statusPending = Color(0xFF004AC6);
const _statusPendingBg = Color(0xFFD9E3F6);
const _statusResolved = Color(0xFF006C49);
const _background = Color(0xFFF8F9FF);
const _surface = Color(0xFFFFFFFF);
const _surfaceTint = Color(0xFFDBE1FF);
const _onSurface = Color(0xFF1F2937);
const _error = Color(0xFFDC2626);

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: _primary,
    onPrimary: Colors.white,
    secondary: _secondary,
    background: _background,
    surface: _surface,
    onSurface: _onSurface,
    error: _error,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
    labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
  ),
  cardTheme: CardThemeData(
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    ),
  ),
);
```

> Per the September 20 increment report, `theme.dart` now implements all of
> the tokens above as `AppColors`, `AppSpacing`, `AppRadius`, and the
> assembled `ThemeData` — this is live in the codebase, not just planned.

## Changes since the last version

| Element | Prelim said | Now says | Why it changed |
|---|---|---|---|
| Palette | 6 hand-picked colors, no status distinction | Kept the full role table, added confirmed `statusPending`, `statusPendingBg`, `statusResolved`, and `surfaceTint`; updated `background` to `#F8F9FF` | Building the actual screens surfaced two dedicated status colors and a light card tint that plain success/error/background/surface didn't cover, and the real background hex was slightly off from the original spec |
| Radius | Not defined at all | Added `AppRadius` (small/medium/large/pill) | Every button, card, input, and modal in the mockups is consistently rounded — the theme file needed a real value to reuse |
| Heading size | 24sp | 28sp | Confirmed directly from the Login screen |
| Field labels | No dedicated style | 16sp Medium (weight override on `bodyMedium`, not a new size) | Confirmed directly from the Username field label |
