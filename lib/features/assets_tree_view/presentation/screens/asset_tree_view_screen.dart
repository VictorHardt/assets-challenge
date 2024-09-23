import 'dart:async';

import 'package:assets_challenge/core/utils/assets_path.dart';
import 'package:assets_challenge/design_system/tractian_colors.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/bloc/assets_tree_view_bloc.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/widgets/asset_tree_view_widget.dart';
import 'package:assets_challenge/features/assets_tree_view/presentation/widgets/tractian_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetTreeViewScreen extends StatefulWidget {
  final String companyId;

  static const screenName = 'AssetTreeViewScreen';

  const AssetTreeViewScreen({super.key, required this.companyId});

  @override
  State<AssetTreeViewScreen> createState() => _AssetTreeViewScreenState();
}

class _AssetTreeViewScreenState extends State<AssetTreeViewScreen> {
  Timer? _debounce;
  late final AssetsTreeViewBloc _bloc;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<AssetsTreeViewBloc>(context);

    _bloc.add(
      GetlocationsAndAssets(
        companyId: widget.companyId,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 500), () {
        BlocProvider.of<AssetsTreeViewBloc>(context).add(
          SearchAssetsAndLocationsByName(
            query: query,
          ),
        );
      });
    } else {
      BlocProvider.of<AssetsTreeViewBloc>(context).add(
        const RemoveSearchAssetsAndLocationsByName(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: TractianColors.white,
            ),
          ),
        ),
        title: Text(
          'Assets',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: TractianColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
        ),
        centerTitle: true,
        backgroundColor: TractianColors.appbarDeepBlue,
      ),
      body: BlocConsumer<AssetsTreeViewBloc, AssetsTreeViewState>(
        listener: (context, state) {
          if (_controller.text.isNotEmpty) {
            _onSearchChanged(_controller.text);
          }
        },
        builder: (context, state) {
          return BlocBuilder<AssetsTreeViewBloc, AssetsTreeViewState>(
            builder: (context, state) {
              if (state is AssetsTreeViewSuccess) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: TractianColors.white,
                        border: Border(
                          bottom: BorderSide(color: TractianColors.gray2),
                        ),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _controller,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Buscar Ativo ou Local',
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: TractianColors.gray2,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(
                                16.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              TractianButton(
                                prefixIconPath: AssetsPaths.bolt,
                                buttonType: _bloc.usingEnergyAssetFilter
                                    ? TractianButtonType.elevated
                                    : TractianButtonType.outlined,
                                textColor: _bloc.usingEnergyAssetFilter
                                    ? TractianColors.white
                                    : TractianColors.gray3,
                                onPressed: () {
                                  _bloc.add(const FilterEnergyAssets());
                                },
                                label: 'Sensor de energia',
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                width: 200,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TractianButton(
                                prefixIconPath: AssetsPaths.exclamationCircle,
                                buttonType: _bloc.usingCriticalStatusFilter
                                    ? TractianButtonType.elevated
                                    : TractianButtonType.outlined,
                                textColor: _bloc.usingCriticalStatusFilter
                                    ? TractianColors.white
                                    : TractianColors.gray3,
                                onPressed: () {
                                  _bloc.add(const FilterCriticalStatusAssets());
                                },
                                label: 'Crítico',
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                width: 100,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: TractianColors.gray4,
                        child: ListView.separated(
                          itemCount: state.assetsTreeViews.length,
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                            bottom: 50,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 20,
                          ),
                          itemBuilder: (context, index) {
                            return AssetTreeViewWidget(
                              assetTreeView: state.assetsTreeViews[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Container(
                color: TractianColors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
