part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeTab.home()) HomeTab currentTab,
    @Default({}) Map<HomeTab, Widget> pages,
    @Default({}) Map<HomeTab, int> badges,
    @Default(false) bool isLoading,
  }) = _HomeState;

  const HomeState._();

  Widget get currentPage => pages[currentTab] ?? const SizedBox.shrink();
  int get currentIndex => currentTab.index;
  bool get hasCurrentPage => pages.containsKey(currentTab);
  int getBadgeCount(HomeTab tab) => badges[tab] ?? 0;
  bool hasBadge(HomeTab tab) => badges.containsKey(tab) && badges[tab]! > 0;

  static List<HomeTab> get allTabs => [
    const HomeTab.home(),
    const HomeTab.search(),
    const HomeTab.favorite(),
    const HomeTab.profile(),
  ];
}
