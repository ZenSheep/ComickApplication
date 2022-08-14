import 'dart:convert';
import 'dart:io';

import 'package:comick_application/requests/Models/chapters_model.dart';
import 'package:comick_application/requests/Models/comic_informations_model.dart';
import 'package:comick_application/requests/Models/comick_model.dart';
import 'package:comick_application/requests/Models/pages_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;


Future<List<Comick>> getComicsByName(String? value) async {
  final queryParameters = {'q': value};
  final response = await http.get(Uri.https('api.comick.fun', '/search', queryParameters));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body) as List<dynamic>;
    return jsonResponse.map((e) => Comick.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load comick');
  }
}

Future<Chapters> getChaptersFromId(int id, int value) async{
  final queryParameters = {'page': value.toString()};
  final response = await http.get(Uri.https('api.comick.fun', '/comic/$id/chapter', queryParameters));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Chapters.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load comick');
  }
}

Future<Pages> getPagesFromHid(String hid) async{
  final response = await http.get(Uri.https('api.comick.fun', '/chapter/$hid'));
  
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Pages.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load comick');
  }
}

Stream<double> downloadChapter(String hid) async* {
  final response = await http.get(Uri.https('api.comick.fun', '/chapter/$hid'));
  
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final pages = Pages.fromJson(jsonResponse);

    final directory = await getDownloadPath(pages.chapter.mdComics.slug, pages.chapter.mdChaptersGroups.first.mdGroups.slug);
    final directoryPath = path.join(directory, '${pages.chapter.chap}');

    final mdImages = pages.chapter.mdImages;
    for (var i = 0; i < mdImages.length; i++){
      final element = mdImages[i];

      final url = element.getImageUrl();
      final response = await http.get(Uri.parse(url));

      final localPath = path.join(directoryPath, "Page_$i.png");


      final imageFile = await File(localPath).create(recursive: true);
      final resultFile = await imageFile.writeAsBytes(response.bodyBytes);

      if (!resultFile.existsSync())
      {
        yield -1;
        return;
      }
      yield (i + 1) / mdImages.length;
    }
  }
  else {
    yield -1;
  }
}

Future<ComicInformations> getComicInformations(String slug) async {
  final response = await http.get(Uri.https('api.comick.fun', '/comic/$slug'));
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return ComicInformations.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load comick');
  }
}

Future<String> getDownloadPath(String? comicSlug, String? groupSlug) async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final directoryPath = path.join(directory.path, 'downloads', comicSlug, groupSlug);
  return directoryPath;
}