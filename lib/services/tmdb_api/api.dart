import 'package:flutter/material.dart';
import "package:movie_app/services/tmdb_api/data.dart";
import "package:movie_app/database_models/movies.dart";
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
    else
    {
      throw Exception('Failed to get Upcoming Movies');
    }
  }
}
