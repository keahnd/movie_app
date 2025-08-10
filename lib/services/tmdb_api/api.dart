import 'package:flutter/material.dart';
import 'package:movie_app/services/tmdb_api/data.dart';
import 'package:movie_app/database_models/movies.dart';
import 'package:movie_app/database_models/credits.dart';
import 'package:movie_app/database_models/utilities.dart';
import 'package:movie_app/services/tmdb_api/keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api
{
  Future<List<Movie>> getUpcomingMovies() async
  {
    final response = await http.get(Uri.parse(Endpoints.urlBase+Endpoints.urlMovie+Endpoints.urlUpcoming),
                                    headers: {'Authorization': accessToken});

    if(response.statusCode == 200)
    {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> upcomingMovies = data.map((movie) => Movie.fromJson(movie)).toList();
      return upcomingMovies;
    }
    throw Exception('Failed to get Upcoming Movies');
  }

  Future<List<dynamic>> getCrew(int movieId, CastCrew option) async
  {
    String sMovieId = movieId.toString();
    // only using english as a default param
    // TODO: Allow changing the language param
    final Map<String, String> queryParameters = {'language': 'en-US'};
    final Uri uri = Uri.https(Endpoints.urlBase, sMovieId+Endpoints.urlCastCrew,  queryParameters);
    final response = await http.get(uri,
                                    headers: {'Authorization': accessToken});

    if(response.statusCode == 200)
    {
      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
      if(jsonData['id'] == movieId)
      {
        if(option == CastCrew.cast)
        {
          return jsonData['cast'];
        }
        else if (option == CastCrew.crew)
        {
          return jsonData['crew'];
        }
      }
    }
    throw Exception('Failed to get Cast and Crew from movie: $movieId');
  }
}
