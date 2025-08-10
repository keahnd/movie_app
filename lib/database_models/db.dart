import 'package:movie_app/database_models/movies.dart';
import 'package:movie_app/database_models/credits.dart';

// Should I make this a template class? - maybe use inheritance from the template class
// Should I create different database instances for each list/container?
class DatabaseModel<T>
{
  List<T> allItems = [];

  addToAllItems(T item)
  {
    allItems.add(item);
  }

  getAllItems()
  {
    return allItems;
  }

  bool findItemByTitle(String title, T item)
  {
    
    for (var entry in allItems)
    {
      if(entry?.title == item)
      {
        return 
      }
    }
  }

  DatabaseModel();
}

class Database
{
  DatabaseModel<Movie> allMovies = DatabaseModel<Movie>();
  DatabaseModel<Movie> upcomingMovies = DatabaseModel<Movie>();
  DatabaseModel<Movie> trendingMovies  =DatabaseModel<Movie>();
  DatabaseModel<Cast> performers = DatabaseModel<Cast>();
  DatabaseModel<Crew> directors = DatabaseModel<Crew>();
  DatabaseModel<Genre> allGenres = DatabaseModel<Genre>();
  DatabaseModel<Collection> allCollections = DatabaseModel<Collection>();
  DatabaseModel<ProductionCompany> allProdCompanies = DatabaseModel<ProductionCompany>();

  Database._priveConstructor();

  static final Database _instance = Database._priveConstructor();

  factory Database()
  {
    return _instance;
  }
}