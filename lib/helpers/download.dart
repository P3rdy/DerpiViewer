import 'dart:developer';

import 'package:derpiviewer/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:share_plus/share_plus.dart';

class DownloadHelper {
  static const _channel = MethodChannel('com.p3rdy.derpiviewer/path');
  static var downloadpath;
  static var temppath;
  static Future getDownloadPath() async {
    downloadpath ??= await _channel.invokeMethod('getPictures');
  }

  static Future getTempPath() async {
    temppath ??= await _channel.invokeMethod('getTemp');
    // log(temppath);
    Directory tempdir = Directory(temppath);
    if (!tempdir.existsSync()) {
      await tempdir.create(recursive: true);
    }
  }

  static Future checkPath() async {
    Directory derpidir = Directory("$downloadpath/DerpiViewer/Derpibooru");
    Directory ponydir = Directory("$downloadpath/DerpiViewer/Ponybooru");
    if (!derpidir.existsSync()) {
      await derpidir.create(recursive: true);
      await ponydir.create(recursive: true);
    }
  }

  static Future downloadFile(
      String uri, Booru booru, int id, String type) async {
    String? bs;
    await getDownloadPath();
    await checkPath();
    // final status = await Permission.storage.request();
    switch (booru) {
      case Booru.derpi:
      case Booru.trixie:
        bs = "Derpibooru";
        break;
      case Booru.pony:
        bs = "Ponybooru";
        break;
      default:
    }
    log("$downloadpath/DerpiViewer/$bs/$id.$type");
    await FlutterDownloader.enqueue(
      url: uri,
      fileName: "$id.$type",
      savedDir: "$downloadpath/DerpiViewer/$bs",
      // showNotification: true,
      // openFileFromNotification: true,
    );
    // MediaScanner.loadMedia(path: "$downloadpath/DerpiViewer/$bs/$id.$type");
  }

  static Future shareFile(
      String uri, Booru booru, int id, ContentFormat type) async {
    await getTempPath();
    String? bs;
    switch (booru) {
      case Booru.derpi:
      case Booru.trixie:
        bs = "Derpibooru";
        break;
      case Booru.pony:
        bs = "Ponybooru";
        break;
      default:
    }
    var file = await DefaultCacheManager().getSingleFile(uri);

    // var response = await http.get(Uri.parse(uri));
    // Uint8List bytes = response.bodyBytes;

    ShareResult result = await Share.shareXFiles([
      XFile(file.path,
          name: "$bs-$id.${ConstStrings.format[type.index]}",
          mimeType: ConstStrings.mime[type.index])
    ], text: "$bs, ID: $id");
    if (result.status == ShareResultStatus.success) {
      Fluttertoast.showToast(msg: "Shared");
    }
  }
}
