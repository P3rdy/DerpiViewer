import 'package:derpiviewer/models/pref_model.dart';
import 'package:flutter/material.dart';
import 'package:derpiviewer/enums.dart';
import 'package:provider/provider.dart';

class ChangeBooruDialog extends StatelessWidget {
  final PrefModel pref;
  const ChangeBooruDialog({super.key, required this.pref});
  @override
  Widget build(BuildContext context) {
    List<String> boorus = ConstStrings.boorus;
    int booruNum = boorus.length;
    return SimpleDialog(
      title: const Text('Select a booru'),
      children: <Widget>[
        for (var i = 0; i < booruNum; i++) generateOption(boorus[i], context, i)
      ],
    );
  }

  Widget generateOption(String text, BuildContext context, int idx) {
    return SimpleDialogOption(
      onPressed: () {
        pref.changeHost(Booru.values[idx]);
        Navigator.pop(context, null);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text),
      ),
    );
  }
}

class ChangeParamDialog extends StatelessWidget {
  const ChangeParamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrefModel>(builder: ((context, pref, child) {
      Map<String, int> curFilters = ConstStrings.filters[pref.booruHost]!;
      return SimpleDialog(
        title: const Text("Set your preference"),
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<SortDirection>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.arrow_upward),
                      border: OutlineInputBorder(),
                      labelText: "Sort direction"),
                  items: [
                    for (SortDirection i in SortDirection.values)
                      DropdownMenuItem<SortDirection>(
                        value: i,
                        child: Text(ConstStrings.sds[i.index]),
                      )
                  ],
                  value: pref.params.sortDirection,
                  onChanged: ((value) {
                    pref.params.update(sd: value);
                  }))),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<SortField>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.sort),
                      border: OutlineInputBorder(),
                      labelText: "Sort field"),
                  items: [
                    for (SortField i in SortField.values)
                      DropdownMenuItem<SortField>(
                        value: i,
                        child: Text(ConstStrings.sfs[i.index]),
                      )
                  ],
                  value: pref.params.sortField,
                  onChanged: ((value) {
                    pref.params.update(sf: value);
                    Navigator.pop(context, null);
                  }))),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.filter_alt),
                      border: OutlineInputBorder(),
                      labelText: "Filter"),
                  value: pref.params.filterName,
                  items: [
                    for (String s in curFilters.keys)
                      DropdownMenuItem(value: s, child: Text(s))
                  ],
                  onChanged: ((value) {
                    pref.params.update(fid: curFilters[value], fn: value);
                    Navigator.pop(context, null);
                  })))
        ],
      );
    }));
  }
}

class ChangeDownloadPrefDialog extends StatelessWidget {
  const ChangeDownloadPrefDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrefModel>(builder: ((context, pref, child) {
      return SimpleDialog(
        title: const Text("Set prefered size"),
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<Size>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.image),
                      border: OutlineInputBorder(),
                      labelText: "Preview image size"),
                  items: const [
                    DropdownMenuItem<Size>(
                      value: Size.full,
                      child: Text("Full"),
                    ),
                    DropdownMenuItem<Size>(
                      value: Size.large,
                      child: Text("Large"),
                    )
                  ],
                  value: pref.imageSize,
                  onChanged: ((value) {
                    pref.imageSize = value ?? pref.imageSize;
                  }))),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<Size>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.video_file),
                      border: OutlineInputBorder(),
                      labelText: "Preview video size"),
                  items: const [
                    DropdownMenuItem<Size>(
                      value: Size.full,
                      child: Text("Full"),
                    ),
                    DropdownMenuItem<Size>(
                      value: Size.medium,
                      child: Text("Medium"),
                    )
                  ],
                  value: pref.videoSize,
                  onChanged: ((value) {
                    pref.videoSize = value ?? pref.videoSize;
                  }))),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<Size>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.download),
                      border: OutlineInputBorder(),
                      labelText: "Download size"),
                  items: const [
                    DropdownMenuItem<Size>(
                      value: Size.full,
                      child: Text("Full"),
                    ),
                    DropdownMenuItem<Size>(
                      value: Size.large,
                      child: Text("Large"),
                    )
                  ],
                  value: pref.downloadSize,
                  onChanged: ((value) {
                    pref.downloadSize = value ?? pref.downloadSize;
                  }))),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<Size>(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.share),
                      border: OutlineInputBorder(),
                      labelText: "Share size"),
                  items: const [
                    DropdownMenuItem<Size>(
                      value: Size.full,
                      child: Text("Full"),
                    ),
                    DropdownMenuItem<Size>(
                      value: Size.large,
                      child: Text("Large"),
                    ),
                    DropdownMenuItem<Size>(
                      value: Size.medium,
                      child: Text("Medium"),
                    )
                  ],
                  value: pref.shareSize,
                  onChanged: ((value) {
                    pref.shareSize = value ?? pref.shareSize;
                    Navigator.pop(context, null);
                  }))),
        ],
      );
    }));
  }
}
