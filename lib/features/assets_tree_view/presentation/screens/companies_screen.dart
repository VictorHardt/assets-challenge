import 'package:assets_challenge/core/utils/assets_path.dart';
import 'package:assets_challenge/design_system/tractian_colors.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/bloc/assets_tree_view_bloc.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/screens/asset_tree_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CompaniesScreen extends StatefulWidget {
  static const screenName = 'CompaniesScreen';

  const CompaniesScreen({super.key});

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  late final AssetsTreeViewBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<AssetsTreeViewBloc>(context);

    _bloc.add(const GetCompanies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(AssetsPaths.tractianLogo),
        backgroundColor: TractianColors.appbarDeepBlue,
      ),
      body: Container(
        color: TractianColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          child: BlocBuilder<AssetsTreeViewBloc, AssetsTreeViewState>(
            builder: (context, state) {
              if (state is AssetsTreeViewSuccess) {
                return ListView.separated(
                  itemCount: state.companies.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 40,
                  ),
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssetTreeViewScreen(
                              companyId: state.companies[index].id,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          TractianColors.buttonBlue,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 30,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AssetsPaths.companiesIcon,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            state.companies[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: TractianColors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
