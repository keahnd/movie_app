import 'package:movie_app/database_models/movies.dart';
import 'package:movie_app/database_models/db.dart';

class Cast
{
  final String name;
  final String character;
  final String image;

  List<Movie> inMovie = [];

  final Database db = Database();

  Cast({required this.name, required this.character, required this.image});

  addToMovie(Movie movie)
  {
    inMovie.add(movie);
  }
}

class Crew
{
  final String name;
  final String role;
  final String image;

  List<Movie> inMovie = [];

  final Database db = Database();

  Crew({required this.name, required this.role, required this.image});

  addToMovie(Movie movie)
  {
    inMovie.add(movie);
  }
}