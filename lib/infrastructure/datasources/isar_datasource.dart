import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';

// Clase que implementa la fuente de datos local utilizando Isar
class IsarDatasource extends LocalStorageDatasource {
  
  // Base de datos de Isar
  late Future<Isar> db;

  // Constructor que inicializa la base de datos
  IsarDatasource() {
  db = openDB();
  }

  // Método para abrir la base de datos de Isar
  Future<Isar> openDB() async {
  // Si no hay instancias de Isar abiertas
  if (Isar.instanceNames.isEmpty) {
    // Obtiene el directorio de documentos de la aplicación
    final dir = await getApplicationDocumentsDirectory();
    // Abre la base de datos de Isar con el esquema de Movie
    return await Isar.open([MovieSchema], inspector: true, directory: dir.path);
  }
  // Si ya hay una instancia abierta, la retorna
  return Future.value(Isar.getInstance());
  }

  // Método para verificar si una película es favorita
  @override
  Future<bool> isMovieFavorite(int movieId) async {
  final isar = await db;

  // Busca la película por su ID
  final Movie? isFavoriteMovie = await isar.movies
    .filter()
    .idEqualTo(movieId)
    .findFirst();

  // Retorna true si la película es encontrada, de lo contrario false
  return isFavoriteMovie != null;
  }

  // Método para alternar el estado de favorito de una película
  @override
  Future<void> toggleFavorite(Movie movie) async {
  final isar = await db;

  // Busca la película por su ID
  final favoriteMovie = await isar.movies
    .filter()
    .idEqualTo(movie.id)
    .findFirst();

  if (favoriteMovie != null) {
    // Si la película es encontrada, la elimina
    isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
    return;
  }

  // Si la película no es encontrada, la inserta
  isar.writeTxnSync(() => isar.movies.putSync(movie));
  }

  // Método para cargar una lista de películas con paginación
  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
  final isar = await db;

  // Retorna una lista de películas con el límite y el offset especificados
  return isar.movies.where()
    .offset(offset)
    .limit(limit)
    .findAll();
  }
}