enum Booru { derpi, trixie, pony }

enum SortField {
  wilsonScore,
  created,
  updated,
  firstSeen,
  score,
  relevance,
  width,
  height,
  comments,
  tagCount
}

enum SortDirection { desc, asc }

// enum Filter { nofilter, defalta, everything }

enum Size { full, large, medium, small, tall, thumb, thumbSmall, thumbTiny }

enum ContentFormat { gif, jpg, jpeg, png, svg, webm }

class ConstStrings {
  static List<String> boorus = [
    'derpibooru.org',
    'trixiebooru.org',
    'ponybooru.org'
  ];
  static List<String> sfs = [
    "wilson_score",
    "created_at",
    "updated_at",
    "first_seen_at",
    "score",
    "relevance",
    "width",
    "height",
    "comments",
    "tag_count"
  ];
  static List<String> sds = ["desc", "asc"];
  static String fallbackImg = "https://derpicdn.net/img/2012/1/2/1/medium.png";
  static List<String> format = ["gif", "jpg", "jpeg", "png", "svg", "webm"];
  static List<String> mime = [
    "image/gif",
    "image/jpeg",
    "image/jpeg",
    "image/png",
    "image/svg+xml",
    "video/webm"
  ];
  static Map<String, Map<String, int>> filters = {
    "derpibooru.org": {
      "Legacy Default": 37431,
      "18+ Dark": 37429,
      "Everything": 56027,
      "18+ R34": 37432,
      "Maximum Spoilers": 37430,
      "Default": 100073
    },
    "trixiebooru.org": {
      "Legacy Default": 37431,
      "18+ Dark": 37429,
      "Everything": 56027,
      "18+ R34": 37432,
      "Maximum Spoilers": 37430,
      "Default": 100073
    },
    "ponybooru.org": {"Default": 1, "Everything": 2}
  };
}
