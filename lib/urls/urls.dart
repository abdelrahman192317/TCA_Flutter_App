
class Urls {
  static const String baseUrl = "api.themoviedb.org";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/original";
  //you should register an account in TMDB website and get an apikey. then replace it here.
  static const String apiKey = "your api key";

  static const String topRated = '/3/movie/top_rated';
  static const String popularMovies = "/3/movie/popular";
  static const String newPlayingMovies = '/3/movie/new_playing';
  static const String upcomingMovies = "/3/movie/upcoming";
  static const String search = '/3/search/movie';
}