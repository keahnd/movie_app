import 'package:flutter/material.dart';
import "package:movie_app/services/tmdb_api/api.dart";
import "package:movie_app/database_models/movies.dart";

class Homepage extends StatefulWidget
{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Homepage>
{
  late Future<List<Movie>> upcomingMovies;

  @override initState()
  {
    upcomingMovies = Api().getUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return const Scaffold();
  }
}