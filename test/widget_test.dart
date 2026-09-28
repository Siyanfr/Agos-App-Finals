// Widget tests: they build small pieces of the AGOS UI in memory and check
// what is on screen. Run them all with: flutter test
//
// These test the reusable widgets on their own, so no Firebase is needed.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/theme.dart';
import 'package:final_project/widgets/primary_button.dart';
import 'package:final_project/widgets/report_card.dart';
import 'package:final_project/widgets/stat_summary_card.dart';
import 'package:final_project/widgets/status_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: appTheme,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('StatusBadge shows each status with the right color',
      (tester) async {
    await tester.pumpWidget(_wrap(
      Column(
        children: const [
          StatusBadge(status: 'Pending', label: 'PENDING'),
          StatusBadge(status: 'Resolved', label: 'RESOLVED'),
          StatusBadge(status: 'Rejected', label: 'REJECTED'),
        ],
      ),
    ));

    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('RESOLVED'), findsOneWidget);
    expect(find.text('REJECTED'), findsOneWidget);

    final rejected = tester.widget<Text>(find.text('REJECTED'));
    expect(rejected.style?.color, AppColors.statusRejected);
  });

  testWidgets('PrimaryButton calls onPressed when tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(_wrap(
      PrimaryButton(label: 'Login', onPressed: () => taps++),
    ));

    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('PrimaryButton shows a spinner and ignores taps while loading',
      (tester) async {
    var taps = 0;

    await tester.pumpWidget(_wrap(
      PrimaryButton(label: 'Login', isLoading: true, onPressed: () => taps++),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Login'), findsNothing);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(taps, 0);
  });

  testWidgets('ReportCard shows its details and reacts to a tap',
      (tester) async {
    var tapped = false;

    await tester.pumpWidget(_wrap(
      ReportCard(
        reportTitle: 'Double parking on main st',
        status: 'Pending',
        date: '9/22/2026',
        location: 'Angeles City',
        onTap: () => tapped = true,
      ),
    ));

    expect(find.text('Double parking on main st'), findsOneWidget);
    expect(find.text('Angeles City'), findsOneWidget);
    expect(find.text('9/22/2026'), findsOneWidget);
    expect(find.text('PENDING'), findsOneWidget);

    await tester.tap(find.byType(ReportCard));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('StatSummaryCard shows the count and an uppercase label',
      (tester) async {
    await tester.pumpWidget(_wrap(
      Row(
        children: const [
          StatSummaryCard(
            label: 'Total Reports',
            count: 3,
            icon: Icons.description_outlined,
          ),
        ],
      ),
    ));

    expect(find.text('3'), findsOneWidget);
    expect(find.text('TOTAL REPORTS'), findsOneWidget);
  });
}