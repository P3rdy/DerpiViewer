import 'dart:developer';

import 'package:derpiviewer/models/pref_model.dart';
import 'package:derpiviewer/models/search_model.dart';
import 'package:derpiviewer/widgets/image_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends SearchDelegate {
  SearchPage();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
      IconButton(
          onPressed: (() {
            showResults(context);
          }),
          icon: const Icon(Icons.search))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const Center();
    Provider.of<SearchModel>(context, listen: false).newSearch(query);
    return const ResultScroll();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<PrefModel>(
        builder: ((context, value, child) => CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        ((context, index) => ListTile(
                              title: Text(value.history[index]),
                              onTap: (() {
                                query = value.history[index];
                                showResults(context);
                              }),
                            )),
                        childCount: value.historyCount))
              ],
            )));
  }
}

class ResultScroll extends StatefulWidget {
  const ResultScroll({super.key});
  @override
  State<ResultScroll> createState() => _ResultScrollState();
}

class _ResultScrollState extends State<ResultScroll> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(scrollCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        Consumer<SearchModel>(
            builder: ((context, value, child) => ImageGrid(
                  model: value,
                )))
      ],
      controller: _scrollController,
    );
  }

  void scrollCallback() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      log("loading more");
      Provider.of<SearchModel>(context, listen: false).fetchMore();
    }
  }
}
