import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_me/features/home/home.dart';

part 'home_state.dart';
part 'home_tab.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
    : super(
        HomeState(
          pages: {
            const HomeTab.home(): const HomeView(),
            const HomeTab.search(): const SearchView(),
            const HomeTab.favorite(): const FavoriteView(),
            const HomeTab.profile(): const ProfileView(),
          },
        ),
      );

  void onChangeTab(HomeTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void changeTabByIndex(int index) {
    final tabs = HomeState.allTabs;
    if (index >= 0 && index < tabs.length) {
      onChangeTab(tabs[index]);
    }
  }

  void updateBadge(HomeTab tab, int count) {
    final badges = Map<HomeTab, int>.from(state.badges);
    if (count > 0) {
      badges[tab] = count;
    } else {
      badges.remove(tab);
    }
    emit(state.copyWith(badges: badges));
  }

  void clearBadge(HomeTab tab) {
    final badges = Map<HomeTab, int>.from(state.badges);
    badges.remove(tab);
    emit(state.copyWith(badges: badges));
  }

  void clearAllBadges() {
    emit(state.copyWith(badges: {}));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  void addPage(HomeTab tab, Widget page) {
    final pages = Map<HomeTab, Widget>.from(state.pages);
    pages[tab] = page;
    emit(state.copyWith(pages: pages));
  }

  void removePage(HomeTab tab) {
    final pages = Map<HomeTab, Widget>.from(state.pages);
    pages.remove(tab);
    emit(state.copyWith(pages: pages));
  }
}
