import 'package:assets_challenge/build_config.dart';
import 'package:assets_challenge/core/exceptions/repository_exception_handler_scope.dart';
import 'package:assets_challenge/core/helpers/http_helper.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/asset_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/companies_model.dart';
import 'package:assets_challenge/features/assets_tree_view/domain/models/location_model.dart';

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

  Future<List<LocationModel>> getLocations({required String companyId}) async {
    return repositoryExceptionHandlerScope<List<LocationModel>>(
      () async {
        List<dynamic> result = await _httpHelper.getRequest(
          '${BuildConfig.instance.fakeApiUrl}/companies/$companyId/locations',
        );

        return result
            .map((element) => LocationModel.fromJson(element))
            .toList();
      },
    );
  }

  Future<List<AssetModel>> getAssets({required String companyId}) async {
    return repositoryExceptionHandlerScope<List<AssetModel>>(
      () async {
        List<dynamic> result = await _httpHelper.getRequest(
          '${BuildConfig.instance.fakeApiUrl}/companies/$companyId/assets',
        );

        return result.map((element) => AssetModel.fromJson(element)).toList();
      },
    );
  }
}
