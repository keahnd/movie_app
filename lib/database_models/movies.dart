import 'package:movie_app/database_models/people.dart';

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
  Collection? series;
  int? tmdbRating;
  List<Cast> cast;
  Crew director;
  int score;

  Movie({required this.title, required this.backdropPath, required this.synopsis,
         required this.posterPath, required this. releaseDate, required this.productionCompanies,
         required this.genres, required this.budget, this.series, this.tmdbRating})
  {

  }

  factory Movie.fromJson(Map<String, dynamic> jsonResp)
  {
    List<ProductionCompany> prodCompanies = get_all_prod_comp(jsonResp["production_companies"]);
    List<Genre> genresList = get_all_genres(jsonResp["genres"]);
    Collection seriesCollection = null;
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
      tmdbRating: jsonResp['rating']
    );
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