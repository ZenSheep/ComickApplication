import 'dart:convert';
import 'dart:io';

import 'package:comick_application/requests/Models/comicDto.dart';
import 'package:comick_application/requests/Models/comicInformationsChaptersDto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

import 'Models/chapterWithPagesInformationDto.dart';

const baseUrl = "ec2-13-50-247-58.eu-north-1.compute.amazonaws.com:8080";

Future<List<ComicDto>> getComicsByName(String? value) async {
  final queryParameters = {'search': value};
  final response =
      await http.get(Uri.http(baseUrl, '/comic', queryParameters));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<ComicDto> comics = [];
    for (var i = 0; i < jsonResponse.length; i++) {
      try {
        var comick = ComicDto.fromJson(jsonResponse[i]);
        comics.add(comick);
      } catch (e) {
        throw Exception('Failed to parse comick');
      }
    }
    return comics;
  } else {
    throw Exception('Failed to load comick');
  }
}

Future<ComicInformationsChaptersDto> getChaptersFromSlug(String slug, int value) async {
  final queryParameters = {'page': value.toString()};
  final response = await http
      .get(Uri.http(baseUrl, '/chapter/$slug', queryParameters));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return ComicInformationsChaptersDto.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load comick');
  }
}

Future<ChapterWithPagesInformationDto> getPagesFromHid(String hid) async {
  final response = await http.get(Uri.http(baseUrl, '/page/$hid'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return ChapterWithPagesInformationDto.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load comick');
  }
}

Stream<double> downloadChapter(String title, String hid, String slug, String comicImage) async* {
  final response = await http.get(Uri.http(baseUrl, '/page/$hid'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final pages = ChapterWithPagesInformationDto.fromJson(jsonResponse);

    final slugDirectory = await getComicPath(title, slug);

    final file = await downloadComicImage(comicImage, slugDirectory, "cover.png");
    if (!file.existsSync()) {
      yield -1;
      return;
    }


    final directory = path.join(slugDirectory, pages.chapter.getGroupName());
    final directoryPath = path.join(directory, pages.chapter.chap);

    final mdImages = pages.chapter.md_images;
    for (var i = 0; i < mdImages.length; i++) {
      final element = mdImages[i];

      final url = element.getImageUrl();
      final file = await downloadComicImage(url, directoryPath, "Page_$i.png");

      if (!file.existsSync()) {
        yield -1;
        return;
      }
      yield (i + 1) / mdImages.length;
    }
  } else {
    yield -1;
  }
}

Future<File> downloadComicImage(String imageUrl, String directory, String fileName) async {
  final localPath = path.join(directory, fileName);
  final localFile = File(localPath);
  if (await localFile.exists()) {
    return localFile;
  }

  final response = await http.get(Uri.parse(imageUrl));
  final imageFile = await localFile.create(recursive: true);
  final file = await imageFile.writeAsBytes(response.bodyBytes);
  return file;
}

Future<String> getComicPath(String? title, String comicSlug) async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final directoryPath =
      path.join(directory.path, 'downloads', '$comicSlug${title != null ? ' $title': ''}');
  return directoryPath;
}

Future<String> getChaptersPath(String? title, String comicSlug, String groupSlug) async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final directoryPath =
      path.join(directory.path, 'downloads', '$comicSlug${title != null ? ' $title': ''}', groupSlug);
  return directoryPath;
}

Future<List<ComicDto>> getTopComics() async {
  final response = await http.get(Uri.http(baseUrl, '/comic'));
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<ComicDto> topComics = [];
    var jsonComics = jsonResponse;
    for (var i = 0; i < jsonComics.length; i++) {
      try {
        var topComic = ComicDto.fromJson(jsonComics[i]);
        topComics.add(topComic);
      } catch (e) {
        throw Exception('Failed to parse comick');
      }
    }
    return topComics;
  } else {
    throw Exception('Failed to load comick');
  }
}
