import 'package:flutter/material.dart';
import 'package:derpiviewer/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:derpiviewer/helpers/philomena_api.dart';

class PrefModel extends ChangeNotifier {
  final List<String> _boorus = ConstStrings.boorus;
  final params = PrefParams();
  String key = "";
  String booruHost = "trixiebooru.org";
  Booru booru = Booru.trixie;
  String featuredQuery = "first_seen_at.gt:3 days ago";
  List<String> history = <String>[];
  int historyCount = 0;

  PrefModel() {
    getPref();
  }
  void changeHost(Booru b) {
    if (booru == b) return;
    booruHost = _boorus[b.index];
    booru = b;
    notifyListeners();
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    int tmpBooru = prefs.getInt("booru") ?? booru.index;
    String tmpKey = prefs.getString("key") ?? key;
    int tmpFilterID = prefs.getInt("filter_id") ?? params.filterID;
    int tmpPerPage = prefs.getInt("per_page") ?? params.perPage;
    int tmpSD = prefs.getInt("sd") ?? params.sortDirection.index;
    int tmpSF = prefs.getInt("sf") ?? params.sortField.index;
    booru = Booru.values[tmpBooru];
    booruHost = _boorus[booru.index];
    key = tmpKey;
    params.update(
        fid: tmpFilterID,
        pp: tmpPerPage,
        sd: SortDirection.values[tmpSD],
        sf: SortField.values[tmpSF]);
    history = prefs.getStringList(key) ?? history;
    historyCount = history.length;
  }

  Future savePref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("booru", booru.index);
    await prefs.setString("key", key);
    await prefs.setInt("filter_id", params.filterID);
    await prefs.setInt("per_page", params.perPage);
    await prefs.setInt("sd", params.sortDirection.index);
    await prefs.setInt("sf", params.sortField.index);
    await prefs.setStringList("history", history);
  }
}
