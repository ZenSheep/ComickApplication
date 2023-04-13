import 'package:path/path.dart' as path;

class DownloadedComic {
  String slug = '';
  String? title;
  String cover = '';

  DownloadedComic(String comicPath) {
    final basename = path.basename(comicPath);
    final splitedBasename = basename.split(' ');
    slug = splitedBasename[0];
    title = splitedBasename.length == 1 ? null : splitedBasename.sublist(1).join(' ');
    cover = path.join(comicPath, 'cover.png');
  }
}