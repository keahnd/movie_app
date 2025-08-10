import 'package:movie_app/database_models/people.dart';
import 'package:movie_app/services/tmdb_api/api.dart';
import 'package:movie_app/database_models/utilities.dart';
import 'package:logging/logging.dart';

class Movie
{
  final String title;
  final String backdropPath;
  final String synopsis;
  final String posterPath;
  final DateTime releaseDate;
  final List<ProductionCompany> productionCompanies;
  final List<Genre> genres;
  final int budget;
  String tmdbId;
  Collection? series;
  int? tmdbRating;
  List<Cast> cast = [];
  Crew? director;
  int score = -1;

  Movie({required this.title, required this.backdropPath, required this.synopsis,
         required this.posterPath, required this. releaseDate, required this.productionCompanies,
         required this.genres, required this.budget, required this.tmdbId, this.series, this.tmdbRating})
  {
    cast = getCastList(this);
    director = getDirector(this);
  }

  factory Movie.fromJson(Map<String, dynamic> jsonResp)
  {
    List<ProductionCompany> prodCompanies = get_all_prod_comp(jsonResp["production_companies"]);
    List<Genre> genresList = get_all_genres(jsonResp["genres"]);
    Collection? seriesCollection;
    if(jsonResp['series'])
    {
      seriesCollection = jsonResp['series'];
    }

    return Movie(
      title: jsonResp['title'],
      backdropPath: jsonResp['backdrop_path'],
      synopsis: jsonResp['overview'],
      posterPath: jsonResp['poster_path'],
      releaseDate: jsonResp['release_date'],
      productionCompanies: prodCompanies,
      genres: genresList,
      budget: jsonResp['budget'],
      series: seriesCollection,
      tmdbRating: jsonResp['rating'],
      tmdbId: jsonResp['id']
    );
  }

  List<Cast> getCastList(Movie movie)
  {
    List<Cast> castList = [];
    Api().getCrew(tmdbId, CastCrew.cast).then((jsonResp)
    {
      for(var item in jsonResp)
      {
        castList.add(Cast(name: item['name'],
                          character: item['character'],
                          image: item['profile_path']
        ));
      }
    });
    // TODO: Implement logger
    print("Unable to get director for $title");
    return castList;
  }

  Crew? getDirector(Movie movie)
  {
    Api().getCrew(tmdbId, CastCrew.crew).then((jsonResp)
    {
      for(var item in jsonResp)
      {
        if (item['job'] == 'Director')
        {
          director = Crew(name: item['name'],
                          role: item['job'],
                          image: item['profile_path']
          );
          return director;
        }
      }
    });
    // TODO: Implement logger
    print("Unable to get director for $title");
    return null;
  }
}

class ProductionCompany
{
  final String name;
  final String logoPath;
}

class Genre
{
  final String name;
  final int id;
}

class Collection
{
  final int id;
  final String name;
  final String posterPath;
  final String backdropPath;
  final List<Movie> movies;
}