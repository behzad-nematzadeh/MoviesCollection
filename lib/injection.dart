import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/local/local_data_source.dart';
import 'package:moviescollection/src/data/datasources/remote/api_provider.dart';
import 'package:moviescollection/src/data/datasources/remote/auth_remote_data_source.dart';
import 'package:moviescollection/src/data/datasources/remote/genre_remote_data_source.dart';
import 'package:moviescollection/src/data/datasources/remote/movie_remote_data_source.dart';
import 'package:moviescollection/src/data/datasources/remote/user_remote_data_source.dart';
import 'package:moviescollection/src/data/repositories/auth_remote_repository_impl.dart';
import 'package:moviescollection/src/data/repositories/genre_remote_repository_impl.dart';
import 'package:moviescollection/src/data/repositories/movie_remote_repository_impl.dart';
import 'package:moviescollection/src/data/repositories/user_remote_repository_impl.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';
import 'package:moviescollection/src/domain/repositories/genre_repository.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';
import 'package:moviescollection/src/domain/repositories/user_repository.dart';
import 'package:moviescollection/src/domain/usecases/add_movie.dart';
import 'package:moviescollection/src/domain/usecases/authentication.dart';
import 'package:moviescollection/src/domain/usecases/get_genres.dart';
import 'package:moviescollection/src/domain/usecases/get_movie_info.dart';
import 'package:moviescollection/src/domain/usecases/get_movies.dart';
import 'package:moviescollection/src/domain/usecases/get_movies_by_genre_id.dart';
import 'package:moviescollection/src/domain/usecases/get_user_info.dart';
import 'package:moviescollection/src/domain/usecases/refresh_token.dart';
import 'package:moviescollection/src/domain/usecases/register.dart';
import 'package:moviescollection/src/domain/usecases/search_movies.dart';
import 'package:moviescollection/src/domain/usecases/user_login.dart';
import 'package:moviescollection/src/presentation/blocs/auth/auth_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/genre/genre_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/login/login_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/movie/movie_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/signup/signup_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/splash/splash_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/user/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiProvider(httpClient: sl()));

  //Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<GenreRemoteDataSource>(
    () => GenreRemoteDataSourceImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiProvider: sl()),
  );
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRemoteRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<GenreRepository>(
    () => GenreRemoteRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRemoteRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRemoteRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  //Use cases
  sl.registerLazySingleton(() => AddMovie(repository: sl()));
  sl.registerLazySingleton(() => GetGenres(repository: sl()));
  sl.registerLazySingleton(() => GetMovieInfo(repository: sl()));
  sl.registerLazySingleton(() => GetMovies(repository: sl()));
  sl.registerLazySingleton(() => GetMoviesByGenreId(repository: sl()));
  sl.registerLazySingleton(() => GetUserInfo(repository: sl()));
  sl.registerLazySingleton(() => RefreshToken(repository: sl()));
  sl.registerLazySingleton(() => Register(repository: sl()));
  sl.registerLazySingleton(() => SearchMovies(repository: sl()));
  sl.registerLazySingleton(() => UserLogin(repository: sl()));
  sl.registerLazySingleton(() => Authentication(repository: sl()));

  //Blocs
  sl.registerFactory(() => SplashCubit(authentication: sl()));
  sl.registerFactory(() => SignupCubit(register: sl()));
  sl.registerFactory(() => LoginCubit(userLogin: sl()));
  sl.registerFactory(() => AuthCubit(userLogin: sl(), refreshToken: sl()));
  sl.registerFactory(() => UserCubit(getUserInfo: sl(), register: sl()));
  sl.registerFactory(() => GenreCubit(getGenres: sl()));
  sl.registerFactory(
    () => MovieCubit(
        getMovieInfo: sl(),
        getMovies: sl(),
        getMoviesByGenreId: sl(),
        addMovie: sl(),
        searchMovies: sl()),
  );

  //Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
