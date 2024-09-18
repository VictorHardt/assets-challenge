import 'package:assets_challenge/build_config.dart';
import 'package:assets_challenge/core/helpers/http_helper.dart';
import 'package:assets_challenge/core/helpers/internet_connection_helper.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/repository/assets_tree_view_repository.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/bloc/assets_tree_view_bloc.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/screens/companies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  BuildConfig.fakeApi();

  runApp(TractianAssetTreeViewApp());
}

class TractianAssetTreeViewApp extends StatelessWidget {
  final HttpHelper _httpHelper = HttpHelperImpl(
    Client(),
    InternetConnectionHelperImpl(
      InternetConnectionChecker(),
    ),
  );

  TractianAssetTreeViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AssetsTreeViewRepository(_httpHelper),
      child: BlocProvider<AssetsTreeViewBloc>(
        lazy: false,
        create: (context) => AssetsTreeViewBloc(
          AssetsTreeViewRepository(_httpHelper),
        ),
        child: MaterialApp(
          initialRoute: CompaniesScreen.screenName,
          routes: {
            CompaniesScreen.screenName: (context) => const CompaniesScreen(),
          },
        ),
      ),
    );
  }
}
