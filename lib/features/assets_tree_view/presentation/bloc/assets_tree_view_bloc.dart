import 'package:assets_challenge/core/exceptions/request_failure.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/companies_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/repository/assets_tree_view_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assets_tree_view_event.dart';
part 'assets_tree_view_state.dart';

class AssetsTreeViewBloc
    extends Bloc<AssetsTreeViewEvent, AssetsTreeViewState> {
  final AssetsTreeViewRepository _repository;

  // List<CompaniesModel> _companies = [];
  // List<CompaniesModel> get companies => _companies;

  AssetsTreeViewBloc(this._repository) : super(AssetsTreeViewInitial()) {
    on<GetCompanies>((event, emit) async {
      try {
        emit(AssetsTreeViewLoading());

        List<CompaniesModel> companies = await _repository.getCompanies();

        emit(
          AssetsTreeViewSuccess(companies: companies),
        );
      } on RequestFailure catch (failure) {
        emit(
          AssetsTreeViewFailure(
            message: failure.message ?? 'Erro ao carregar',
          ),
        );
      }
    });
  }
}
