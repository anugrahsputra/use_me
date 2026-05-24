import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/features/home/home.dart';

void main() {
  group('HomeTab', () {
    testWidgets('labels are correct', (tester) async {
      await tester.pumpWidget(const SizedBox());
      final ctx = tester.element(find.byType(SizedBox));
      expect(const HomeTab.home().label(ctx), 'Home');
      expect(const HomeTab.search().label(ctx), 'Search');
      expect(const HomeTab.favorite().label(ctx), 'Favorite');
      expect(const HomeTab.profile().label(ctx), 'Profile');
    });

    test('icons are correct', () {
      expect(const HomeTab.home().icon, Icons.home);
      expect(const HomeTab.search().icon, Icons.search);
      expect(const HomeTab.favorite().icon, Icons.favorite);
      expect(const HomeTab.profile().icon, Icons.person);
    });

    test('indices are sequential', () {
      expect(const HomeTab.home().index, 0);
      expect(const HomeTab.search().index, 1);
      expect(const HomeTab.favorite().index, 2);
      expect(const HomeTab.profile().index, 3);
    });
  });

  group('HomeState', () {
    test('default state uses home tab', () {
      final state = HomeState();
      expect(state.currentTab, const HomeTab.home());
      expect(state.isLoading, false);
      expect(state.badges, isEmpty);
    });

    test('allTabs contains 4 tabs', () {
      expect(HomeState.allTabs.length, 4);
      expect(HomeState.allTabs[0], const HomeTab.home());
      expect(HomeState.allTabs[3], const HomeTab.profile());
    });

    test('currentPage returns SizedBox for missing tab', () {
      final state = HomeState();
      expect(state.hasCurrentPage, isFalse);
      expect(state.currentPage, isA<SizedBox>());
      expect((state.currentPage as SizedBox).width, 0.0);
      expect((state.currentPage as SizedBox).height, 0.0);
      expect(state.currentIndex, 0);
    });

    test('getBadgeCount returns 0 for missing badge', () {
      final state = HomeState();
      expect(state.getBadgeCount(const HomeTab.search()), 0);
    });

    test('hasBadge returns false for missing badge', () {
      final state = HomeState();
      expect(state.hasBadge(const HomeTab.home()), isFalse);
    });

    test('copyWith updates fields', () {
      final state = HomeState();
      final updated = state.copyWith(isLoading: true, badges: {
        const HomeTab.home(): 3,
      });
      expect(updated.isLoading, isTrue);
      expect(updated.getBadgeCount(const HomeTab.home()), 3);
    });
  });

  group('HomeCubit', () {
    test('initial state has all pages', () {
      final cubit = HomeCubit();
      expect(cubit.state.pages.length, 4);
      expect(cubit.state.pages.containsKey(const HomeTab.home()), isTrue);
    });

    test('onChangeTab updates current tab', () {
      final cubit = HomeCubit();
      cubit.onChangeTab(const HomeTab.search());
      expect(cubit.state.currentTab, const HomeTab.search());
    });

    test('changeTabByIndex updates tab', () {
      final cubit = HomeCubit();
      cubit.changeTabByIndex(2);
      expect(cubit.state.currentTab, const HomeTab.favorite());
    });

    test('changeTabByIndex ignores invalid index', () {
      final cubit = HomeCubit();
      cubit.changeTabByIndex(10);
      expect(cubit.state.currentTab, const HomeTab.home());
      cubit.changeTabByIndex(-1);
      expect(cubit.state.currentTab, const HomeTab.home());
    });

    test('updateBadge adds badge', () {
      final cubit = HomeCubit();
      cubit.updateBadge(const HomeTab.home(), 5);
      expect(cubit.state.getBadgeCount(const HomeTab.home()), 5);
    });

    test('updateBadge with zero removes badge', () {
      final cubit = HomeCubit();
      cubit.updateBadge(const HomeTab.home(), 5);
      cubit.updateBadge(const HomeTab.home(), 0);
      expect(cubit.state.hasBadge(const HomeTab.home()), isFalse);
    });

    test('clearBadge removes specific badge', () {
      final cubit = HomeCubit();
      cubit.updateBadge(const HomeTab.home(), 3);
      cubit.clearBadge(const HomeTab.home());
      expect(cubit.state.hasBadge(const HomeTab.home()), isFalse);
    });

    test('clearAllBadges removes all badges', () {
      final cubit = HomeCubit();
      cubit.updateBadge(const HomeTab.home(), 3);
      cubit.updateBadge(const HomeTab.search(), 5);
      cubit.clearAllBadges();
      expect(cubit.state.badges, isEmpty);
    });

    test('setLoading updates loading state', () {
      final cubit = HomeCubit();
      cubit.setLoading(true);
      expect(cubit.state.isLoading, isTrue);
      cubit.setLoading(false);
      expect(cubit.state.isLoading, isFalse);
    });

    test('addPage adds new page', () {
      final cubit = HomeCubit();
      const page = SizedBox.shrink();
      cubit.addPage(const HomeTab.search(), page);
      expect(cubit.state.pages[const HomeTab.search()], page);
    });

    test('removePage removes existing page', () {
      final cubit = HomeCubit();
      cubit.removePage(const HomeTab.home());
      expect(cubit.state.pages.containsKey(const HomeTab.home()), isFalse);
    });
  });
}
