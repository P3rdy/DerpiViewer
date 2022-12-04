import 'dart:developer';

import 'package:derpiviewer/enums.dart';
import 'package:derpiviewer/helpers/philomena_api.dart';
import 'package:derpiviewer/models/pref_model.dart';
import 'package:flutter/widgets.dart';

class SearchModel extends SearchInterface {
  late PrefModel _prefModel;

  List<ImageResponse> results = <ImageResponse>[];
  int page = 1;
  int imageCount = 0;
  bool over = false;
  String _query = "";

  SearchModel(PrefModel model) {
    _prefModel = model;
  }

  Future _fetchResult({String? query, bool refresh = false}) async {
    if (query == null && _query.isEmpty) return;
    over = !(query != _query);
    if (over && !refresh) return;
    PrefParams params = _prefModel.params;
    _query = refresh ? query ?? _query : _query;
    page = refresh ? 1 : page + 1;
    List<ImageResponse> more = await fetchImages(
        booru: _prefModel.booruHost,
        query: query ?? _query,
        filterID: params.filterID,
        page: page,
        key: _prefModel.key,
        perPage: params.perPage,
        sortDirection: ConstStrings.sds[params.sortDirection.index],
        sortField: ConstStrings.sfs[params.sortField.index]);
    if (more.isEmpty && !refresh) {
      over = true;
      return;
    } else {
      over = false;
    }
    results = refresh ? <ImageResponse>[] : results;
    results.addAll(more);
    imageCount = results.length;
    notifyListeners();
  }

  void newSearch(String query) async {
    log(query);
    await _fetchResult(query: query, refresh: true);
    _prefModel.history.add(query);
    _prefModel.historyCount = _prefModel.history.length;
  }

  @override
  void fetchMore({bool refresh = false}) {
    _fetchResult(refresh: refresh);
  }

  @override
  ImageResponse getItem(int index) {
    return results[index];
  }

  @override
  int getItemCount() {
    return imageCount;
  }

  @override
  ContentFormat getItemFormat(int index) {
    return results[index].format;
  }

  @override
  int getItemID(int index) {
    return results[index].id;
  }

  @override
  String getItemUrl(int index, Size size) {
    switch (size) {
      case Size.full:
        return results[index].fullUrl;
      case Size.large:
        return results[index].largeUrl;
      case Size.medium:
        return results[index].mediumUrl;
      case Size.small:
        return results[index].smallUrl;
      case Size.tall:
        return results[index].tallUrl;
      case Size.thumb:
        return results[index].thumbUrl;
      case Size.thumbSmall:
        return results[index].thumbSmallUrl;
      case Size.thumbTiny:
        return results[index].thumbTinyUrl;
      default:
        return "";
    }
  }

  @override
  Booru getBooru() {
    return _prefModel.booru;
  }
}

abstract class SearchInterface extends ChangeNotifier {
  int getItemCount();
  int getItemID(int index);
  String getItemUrl(int index, Size size);
  ImageResponse getItem(int index);
  ContentFormat getItemFormat(int index);
  void fetchMore({bool refresh});
  Booru getBooru();
}
