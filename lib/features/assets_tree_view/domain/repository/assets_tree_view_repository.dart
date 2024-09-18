import 'package:assets_challenge/build_config.dart';
import 'package:assets_challenge/core/exceptions/repository_exception_handler_scope.dart';
import 'package:assets_challenge/core/helpers/http_helper.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/companies_model.dart';

class AssetsTreeViewRepository {
  final HttpHelper _httpHelper;

  AssetsTreeViewRepository(this._httpHelper);

  Future<List<CompaniesModel>> getCompanies() async {
    return repositoryExceptionHandlerScope<List<CompaniesModel>>(
      () async {
        List<dynamic> result = await _httpHelper.getRequest(
          '${BuildConfig.instance.fakeApiUrl}/companies',
        );

        return result
            .map((element) => CompaniesModel.fromJson(element))
            .toList();
      },
    );
  }
}
