import 'package:derpiviewer/enums.dart';
import 'package:derpiviewer/helpers/connect.dart';

Future<ImageResponse> fetchImage(
    {required String booru, required int id, String? key}) async {
  Map<String, dynamic> params = {"key": key ?? ""};
  var data = await getData(
      booru: booru, path: "/api/v1/json/images/$id", params: params);
  return ImageResponse.fromJson(data["image"]);
}

Future<ImageResponse> fetchFeaturedImage(
    {required String booru, String? key}) async {
  Map<String, dynamic> params = {"key": key ?? ""};
  var data = await getData(
      booru: booru, path: "/api/v1/json/images/featured", params: params);
  return ImageResponse.fromJson(data["image"]);
}

Future<List<ImageResponse>> fetchImages(
    {required String booru,
    required String query,
    String? key,
    int? filterID,
    int? page,
    int? perPage,
    String? sortDirection,
    String? sortField}) async {
  Map<String, dynamic> params = {
    "q": query,
    "key": key ?? "",
    "filter_id": "${filterID ?? ''}",
    "page": "${page ?? ''}",
    "per_page": "${perPage ?? ''}",
    "sd": sortDirection ?? "",
    "sf": sortField ?? ""
  };
  var data = await getData(
      booru: booru, path: "/api/v1/json/search/images", params: params);
  if (data.isEmpty) return [];
  List<dynamic> images = data["images"];
  List<ImageResponse> res =
      images.map((e) => ImageResponse.fromJson(e)).toList(growable: false);
  return res;
}

class ImageResponse {
  late int id;
  late String fullUrl;
  late String smallUrl;
  late String mediumUrl;
  late String largeUrl;
  late String tallUrl;
  late String thumbUrl;
  late String thumbSmallUrl;
  late String thumbTinyUrl;
  late ContentFormat format;

  ImageResponse(
      this.id,
      this.fullUrl,
      this.smallUrl,
      this.mediumUrl,
      this.largeUrl,
      this.tallUrl,
      this.thumbUrl,
      this.thumbSmallUrl,
      this.thumbTinyUrl);
  ImageResponse.fromJson(Map<String, dynamic> obj) {
    id = obj["id"];
    fullUrl = obj["representations"]["full"];
    smallUrl = obj["representations"]["small"];
    mediumUrl = obj["representations"]["medium"];
    largeUrl = obj["representations"]["large"];
    tallUrl = obj["representations"]["tall"];
    thumbUrl = obj["representations"]["thumb"];
    thumbSmallUrl = obj["representations"]["thumb_small"];
    thumbTinyUrl = obj["representations"]["thumb_tiny"];
    if (obj["format"] == "webm") {
      // fullUrl = fullUrl.replaceFirst(".webm", ".gif");
      // smallUrl = smallUrl.replaceFirst(".webm", ".gif");
      // mediumUrl = mediumUrl.replaceFirst(".webm", ".gif");
      // largeUrl = largeUrl.replaceFirst(".webm", ".gif");
      // tallUrl = tallUrl.replaceFirst(".webm", ".gif");
      thumbUrl = thumbUrl.replaceFirst(".webm", ".gif");
      thumbSmallUrl = thumbSmallUrl.replaceFirst(".webm", ".gif");
      thumbTinyUrl = thumbTinyUrl.replaceFirst(".webm", ".gif");
      smallUrl = thumbUrl;
    }
    format = ContentFormat.values[ConstStrings.format.indexOf(obj["format"])];
  }
}

class PrefParams {
  int filterID;
  int perPage;
  SortDirection sortDirection;
  SortField sortField;
  String filterName;
  PrefParams(
      {this.filterID = 56027,
      this.perPage = 18,
      this.sortDirection = SortDirection.desc,
      this.sortField = SortField.wilsonScore,
      this.filterName = "Everything"});
  update({int? fid, int? pp, SortDirection? sd, SortField? sf, String? fn}) {
    filterID = fid ?? filterID;
    perPage = pp ?? perPage;
    sortDirection = sd ?? sortDirection;
    sortField = sf ?? sortField;
    filterName = fn ?? filterName;
  }
}
