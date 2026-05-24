part of 'home_cubit.dart';

@freezed
abstract class HomeTab with _$HomeTab {
  const factory HomeTab.home() = _HomeTab;

  const factory HomeTab.search() = _SearchTab;

  const factory HomeTab.favorite() = _FavoriteTab;

  const factory HomeTab.profile() = _ProfileTab;

  const HomeTab._();

  String label(BuildContext context) => when(
    home: () => 'Home',
    search: () => 'Search',
    favorite: () => 'Favorite',
    profile: () => 'Profile',
  );

  IconData get icon => when(
    home: () => Icons.home,
    search: () => Icons.search,
    favorite: () => Icons.favorite,
    profile: () => Icons.person,
  );

  int get index =>
      when(home: () => 0, search: () => 1, favorite: () => 2, profile: () => 3);
}
