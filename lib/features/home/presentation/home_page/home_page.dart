import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:use_me/app/app.dart';
import 'package:use_me/core/core.dart';
import 'package:use_me/features/home/home.dart';
import 'package:use_me/injections.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppCubit appCubit = di<AppCubit>();
  final HomeCubit homeCubit = di<HomeCubit>();
  final AppNavigator appNavigator = di<AppNavigator>();

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (context) => appCubit),
        BlocProvider<HomeCubit>(create: (context) => homeCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppCubit, AppState>(
            listener: (context, state) {
              state.whenOrNull(
                unauthenticated: () => di<AppNavigator>().goToSplash(context),
                error: (error) {
                  if (appNavigator.canPop(context)) {
                    appNavigator.back(context);
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                },
                loading: () => showLoading(context),
              );
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Scaffold(
              body: IndexedStack(
                index: state.currentIndex,
                children: HomeState.allTabs
                    .map((tab) => state.pages[tab] ?? const SizedBox.shrink())
                    .toList(),
              ),
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (index) =>
                    context.read<HomeCubit>().changeTabByIndex(index),
                selectedIndex: state.currentIndex,
                destinations: HomeState.allTabs.map((tab) {
                  return NavigationDestination(
                    icon: Icon(tab.icon),
                    label: tab.label(context),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

// mock views
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          TextButton(
            onPressed: () => context.read<AppCubit>().logout(),
            child: Text('Logout'),
          ),
        ],
      ),
      body: Center(child: Text('home page')),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Center(child: Text('Hello Search')),
    );
  }
}

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite')),
      body: Center(child: Text('Hello Favorite')),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Hello Profile')),
    );
  }
}
