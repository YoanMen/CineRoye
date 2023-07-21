import 'dart:io';

import 'package:cineroye/core/failure.dart';
import 'package:cineroye/features/movie_showing/onDisplay/movie_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:html/dom.dart' as dom;

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return WebMovieRepository();
});

abstract class MovieRepository {
  Future<List<MovieEntity>> fetchMovies();
  Future<List<MovieEntity>> fetchComingMovies();
}

class WebMovieRepository implements MovieRepository {
  @override
  Future<List<MovieEntity>> fetchMovies() async {
    try {
      List<MovieEntity> allMovies = [];
      final url = Uri.parse("https://www.cineode.fr/roye/horaires/");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        dom.Document html = dom.Document.html(response.body);

        final moviesUrl = html.querySelectorAll(
            "html body.roye.horaires.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.wrap-fiche-film div.fichefilm-small-v2 a.horaires-affiche");

        final genre = html.querySelectorAll(
            "html body.roye.horaires.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.wrap-fiche-film div.fichefilm-small-v2 p.horaires-infos-film span.horaires-genre strong.hi");

        final getRealisator = html.querySelectorAll(
            "html body.roye.horaires.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.wrap-fiche-film div.fichefilm-small-v2 p.horaires-infos-film span.horaires-realisateur strong.hi");

        for (var movie in moviesUrl) {
          final movieNumber = moviesUrl.indexOf(movie);
          final url = Uri.parse(movie.attributes["href"]!);
          final response = await http.get(url);
          dom.Document html = dom.Document.html(response.body);

          if (response.statusCode == 404) {}

          final linkForBA = html.querySelector(
              "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full div.col span.bloc_fa a.ba");

          final urlVideo = Uri.parse(linkForBA!.attributes["href"] as String);
          final responseVideo = await http.get(urlVideo);

          dom.Document htmlVideo = dom.Document.html(responseVideo.body);

          final video = htmlVideo
              .querySelector(
                  "html body.roye.video div#conteneur div#masthead div#maincontent_v2 div.fichefilm-full-v2 div.videopanel iframe")
              ?.attributes["src"];

          final days = html
              .querySelectorAll(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div#horaires.fichefilm-horaire div.horaires div.tablehoraireout div.tablehorairein table.table.table-bordered.horaires thead.well tr th")
              .map((e) {
            final regex = RegExp(r"<\/?em>");
            final cleanedString = e.innerHtml.replaceAll(regex, "");
            return cleanedString;
          }).toList();

          final title = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full div.col a")
              ?.attributes["title"];

          final overview = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full p.synopsis.description")
              ?.innerHtml;

          final poster = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full div.col a ")
              ?.attributes["href"];
          final duration = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full p strong.hi.duration")
              ?.text
              .trim()
              .replaceAll(".", "");

          String? firstProjection;

          var schedulesDays = html
              .querySelectorAll(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div#horaires.fichefilm-horaire td ")
              .map((e) {
            var text = e.text.trim();

            int length = 5;
            var separatedSchedule = <String>[];

            for (int i = 0; i < text.length; i += length) {
              if (i + length <= text.length) {
                String schedule = text.substring(i, i + length);
                separatedSchedule.add(schedule);
              }
            }

            return separatedSchedule;
          }).toList();

          for (var day in days) {
            var schedule = schedulesDays[days.indexOf(day)];
            if (day == "Aujourd'hui" && schedule.isNotEmpty) {
              for (var element in schedule) {
                DateTime now = DateTime.now();
                List<String> timeParts = element.split('h');
                int hour = int.parse(timeParts[0]);
                int minute = int.parse(timeParts[1]);
                DateTime projectionDateTime =
                    DateTime(now.year, now.month, now.day, hour, minute);

                if (projectionDateTime.isAfter(DateTime.now())) {
                  firstProjection = "Aujourd'hui à $element";
                  break;
                }
              }
            }
          }
          final movieData = MovieEntity.fromMap({
            "title": title,
            "actors": null, //actors[movieNumber],
            "realisators": getRealisator[movieNumber].innerHtml,
            "poster": poster,
            "schedules": schedulesDays,
            "firstProjection": firstProjection,
            "duration": duration,
            "days": days,
            "overview": overview,
            "video": video,
            "genres": genre[movieNumber].innerHtml.toLowerCase().split(", "),
          });

          allMovies.add(movieData);
        }

        return allMovies;
      } else if (response.statusCode == 404) {
        throw Failure(message: "Films introuvable");
      } else {
        throw Failure(
            message:
                "Erreur lors de la récupération des films. Code d'état: ${response.statusCode}");
      }
    } catch (error) {
      if (error is SocketException) {
        throw Failure(message: "Vérifié votre connection internet");
      }
      throw Failure(message: "Impossible de récupérer les films");
    }
  }

  @override
  Future<List<MovieEntity>> fetchComingMovies() async {
    List<MovieEntity> allMovies = [];
    var moviesUrl = [];
    var genres = [];
    var firstProjection = [];
    try {
      final url = Uri.parse("https://www.cineode.fr/roye/prochainement/");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        dom.Document html = dom.Document.html(response.body);

        final firstProjectionImpair = html
            .querySelectorAll(
                "html body.roye.prochainement.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.fichefilm-mini-block.fichefilm-mini-block-impair div.vevent div.fichefilm-mini span.date_prog")
            .map((e) => e.text.trim())
            .toList();

        final firstProjectionPair = html
            .querySelectorAll(
                "html body.roye.prochainement.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.fichefilm-mini-block.fichefilm-mini-block-pair div.vevent div.fichefilm-mini span.date_prog")
            .map((e) => e.text.trim())
            .toList();

        firstProjection.addAll(firstProjectionImpair + firstProjectionPair);

        final moviesUrlImpair = html.querySelectorAll(
            "html body.roye.prochainement.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.fichefilm-mini-block.fichefilm-mini-block-impair div.vevent a.vignette.url");

        final moviesUrlPair = html.querySelectorAll(
            "html body.roye.prochainement.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.fichefilm-mini-block.fichefilm-mini-block-pair div.vevent a.vignette.url");

        moviesUrl.addAll(moviesUrlImpair + moviesUrlPair);

        final genreImpair = html.querySelectorAll(
            "html body.roye.prochainement.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.fichefilm-mini-block.fichefilm-mini-block-impair div.vevent div.fichefilm-mini p.genre.nope strong.hi");
        final genrePair = html.querySelectorAll(
            "html body.roye.prochainement.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.cadre-out div.cadre-in div div.fichefilm-mini-block.fichefilm-mini-block-pair div.vevent div.fichefilm-mini p.genre.nope strong.hi");

        genres.addAll(genreImpair + genrePair);

        for (var movie in moviesUrl) {
          final movieNumber = moviesUrl.indexOf(movie);
          final url = Uri.parse(movie.attributes["href"]!);
          final response = await http.get(url);
          dom.Document html = dom.Document.html(response.body);

          final linkForBA = html.querySelector(
              "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full div.col span.bloc_fa a.ba");

          final urlVideo = Uri.parse(linkForBA!.attributes["href"] as String);
          final responseVideo = await http.get(urlVideo);

          dom.Document htmlVideo = dom.Document.html(responseVideo.body);

          final video = htmlVideo
              .querySelector(
                  "html body.roye.video div#conteneur div#masthead div#maincontent_v2 div.fichefilm-full-v2 div.videopanel iframe")
              ?.attributes["src"];

          final days = html
              .querySelectorAll(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div#horaires.fichefilm-horaire div.horaires div.tablehoraireout div.tablehorairein table.table.table-bordered.horaires thead.well tr th")
              .map((e) {
            final regex = RegExp(r"<\/?em>");
            final cleanedString = e.innerHtml.replaceAll(regex, "");
            return cleanedString;
          }).toList();

          final title = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full div.col a")
              ?.attributes["title"];

          final getRealisator = html.querySelector(
              "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full p strong");

          final overview = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full p.synopsis.description")
              ?.innerHtml;

          final poster = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full div.col a ")
              ?.attributes["href"];
          final duration = html
              .querySelector(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div.hreview div.item div.fichefilm-full p strong.hi.duration")
              ?.text
              .trim()
              .replaceAll(".", "");

          var schedulesDays = html
              .querySelectorAll(
                  "html body.roye.film.not_dfp div#conteneur div#masthead div#mod_ccweb_cine_jeu_large div#maincontent-large.ct_left div#horaires.fichefilm-horaire td ")
              .map((e) {
            var text = e.text.trim();

            int length = 5;
            var separatedSchedule = <String>[];

            for (int i = 0; i < text.length; i += length) {
              if (i + length <= text.length) {
                String schedule = text.substring(i, i + length);
                separatedSchedule.add(schedule);
              }
            }

            return separatedSchedule;
          }).toList();
          final movieData = MovieEntity.fromMap({
            "title": title,
            "realisators": getRealisator?.text,
            "poster": poster,
            "schedules": schedulesDays,
            "firstProjection": firstProjection[movieNumber],
            "duration": duration,
            "days": days,
            "overview": overview,
            "video": video,
            "genres": genres[movieNumber].text.toLowerCase().split(", "),
          });

          allMovies.add(movieData);
        }

        return allMovies;
      } else if (response.statusCode == 404) {
        throw Failure(message: "Films introuvable");
      } else {
        throw Failure(
            message:
                "Erreur lors de la récupération des films. Code d'état: ${response.statusCode}");
      }
    } on HttpClientRequest catch (error) {
      if (error is SocketException) {
        throw Failure(
          message: "Vérifié votre connection internet",
        );
      }

      throw Failure(
        message: "Impossible de récupérer les films",
      );
    }
  }
}
