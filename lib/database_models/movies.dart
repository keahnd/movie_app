import 'package:movie_app/database_models/credits.dart';
import 'package:movie_app/database_models/db.dart';
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
  List<ProductionCompany> productionCompanies = [];
  List<Genre> genres = [];
  final int budget;
  int tmdbId;
  Collection? series;
  int? tmdbRating;
  List<Cast> cast = [];
  Crew? director;
  int score = -1;

  Movie({
    required this.title, 
    required this.backdropPath, 
    required this.synopsis,
    required this.posterPath, 
    required this.releaseDate, 
    required List<dynamic> prodCompaniesJson,
    required List<dynamic> genresJson, 
    required this.budget, 
    required this.tmdbId, 
    required Map<String, dynamic> seriesJson,
    this.tmdbRating})
  {
    productionCompanies = getAllProdComp(prodCompaniesJson);
    genres = getAllGenres(genresJson);
    cast = getCastList(this);
    director = getDirector(this);

    if(seriesJson.isNotEmpty)
    {
      series = Collection(backdropPath: seriesJson['backdrop_path'],
                          id: seriesJson['id'],
                          posterPath: seriesJson['poster_path'],
                          name: seriesJson['name']);
      series?.addMovieToCollection(this);
    }

    // TODO: add to database
  }

  factory Movie.fromJson(Map<String, dynamic> jsonResp)
  {
    // Movie movie;
    // if (db.findAllMovies(jsonResp['title'], movie))
    // {
    //   return movie;
    // }
    return Movie(
      title: jsonResp['title'],
      backdropPath: jsonResp['backdrop_path'],
      synopsis: jsonResp['overview'],
      posterPath: jsonResp['poster_path'],
      releaseDate: jsonResp['release_date'],
      prodCompaniesJson: jsonResp["production_companies"],
      genresJson: jsonResp["genres"],
      budget: jsonResp['budget'],
      seriesJson: jsonResp['belongs_to_collection'],
      tmdbRating: jsonResp['rating'],
      tmdbId: jsonResp['id']);
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

  List<ProductionCompany> getAllProdComp(List<dynamic> jsonData)
  {
    List<ProductionCompany> producedBy = [];
    for (var item in jsonData)
    {
      producedBy.add(ProductionCompany(name: item['name'],
                                       logoPath: item['logo_path'],
                                       id: item['id']
      ));
    }
    return producedBy;
  }

  List<Genre> getAllGenres(List<dynamic> jsonData)
  {
    List<Genre> genres = [];
    for (var item in jsonData)
    {
      genres.add(Genre(name: item['name'],
                        id: item['id']
      ));
    }
    return genres;
  }

  @override
  bool operator ==(Object other)
  {
    return other is Movie && (title == other.title);
  }

  @override
  int get hashCode => Object.hash(title, tmdbId);
}

class ProductionCompany
{
  final String name;
  final String logoPath;
  final int id;

  ProductionCompany({
    required this.name, 
    required this.logoPath, 
    required this.id});
}

class Genre
{
  final String name;
  final int id;
  List<Movie> movies = [];
  final Database db = Database();
  
  Genre({
    required this.name, 
    required this.id})
  {
    // db.addToAllGenres(this);
  }

  addMovieToGenre(Movie movie)
  {
    movies.add(movie);
  }
}

class Collection
{
  final int id;
  final String name;
  final String posterPath;
  final String backdropPath;
  List<Movie> movies = [];

  final Database db = Database();

  Collection({
    required this.id, 
    required this.name, 
    required this.posterPath, 
    required this.backdropPath});

  addMovieToCollection(Movie movie)
  {
    movies.add(movie);
  }
}