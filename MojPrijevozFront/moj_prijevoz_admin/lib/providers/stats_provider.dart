import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/providers/http_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/search_result.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/fares_this_month/fares_this_month_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/users_by_city/users_by_city_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/base_response_by_month/base_response_by_month.dart';

class StatsProvider with ChangeNotifier {
  final httpProvider = GetIt.I<HttpProvider>();
  final uiProvider = GetIt.I<UIProvider>();
  static const String _apiUrl = "admin/stats/";
  SearchResult<UsersByCityResponse> usersByCitySearchResult = SearchResult();
  SearchResult<BaseResponseByMonth> usersByMonthSearchResult = SearchResult();
  SearchResult<BaseResponseByMonth> revenueByMonthSearchResult = SearchResult();
  SearchResult<FaresThisMonthResponse> faresThisMonthSearchResult =
      SearchResult();

  Future getUsersByCity() async {
    uiProvider.disableLoading();
    usersByCitySearchResult.items.clear();
    final response = await httpProvider
        .getAllWithoutSearchObject<UsersByCityResponse>(
          "${_apiUrl}usersByCity",
        );
    response.copyTo(usersByCitySearchResult);
    notifyListeners();
  }

  Future getUsersByMonth() async {
    uiProvider.disableLoading();
    usersByMonthSearchResult.items.clear();
    final response = await httpProvider
        .getAllWithoutSearchObject<BaseResponseByMonth>(
          "${_apiUrl}usersByMonth",
        );
    response.copyTo(usersByMonthSearchResult);
    notifyListeners();
  }

  Future getRevenueByMonth() async {
    uiProvider.disableLoading();
    revenueByMonthSearchResult.items.clear();
    final response = await httpProvider
        .getAllWithoutSearchObject<BaseResponseByMonth>(
          "${_apiUrl}revenueByMonth",
        );
    response.copyTo(revenueByMonthSearchResult);
    notifyListeners();
  }

  Future getFaresThisMonth() async {
    uiProvider.disableLoading();
    faresThisMonthSearchResult.items.clear();
    final response = await httpProvider
        .getAllWithoutSearchObject<FaresThisMonthResponse>(
          "${_apiUrl}allFaresThisMonth",
        );
    response.copyTo(faresThisMonthSearchResult);
    notifyListeners();
  }
}
