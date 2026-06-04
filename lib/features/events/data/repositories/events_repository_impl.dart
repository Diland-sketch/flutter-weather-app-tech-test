import 'package:fpdart/fpdart.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/events/data/datasources/events_local_datasource.dart';
import 'package:weather_app/features/events/data/datasources/events_remote_datasource.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/events/domain/repositories/i_events_repository.dart';

class EventsRepositoryImpl implements IEventsRepository {
  final IEventsRemoteDataSource _remote;
  final IEventsLocalDataSource _local;
  final ConnectivityService _connectivity;

  const EventsRepositoryImpl({
    required IEventsRemoteDataSource remote,
    required IEventsLocalDataSource local,
    required ConnectivityService connectivity,
  }) : _remote = remote,
       _local = local,
       _connectivity = connectivity;

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents(String location) async {
    final isConnected = await _connectivity.isConnected;

    if (!isConnected) {
      return _getCachedEvents(location);
    }

    try {
      final dto = await _remote.getEvents(location);
      final entities = dto.toEntities();
      await _local.saveEvents(location, entities).catchError((_) {});
      return Right(entities);
    } on NetworkException {
      return _getCachedEvents(location);
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } on ParsingException {
      return Left(ParsingFailure());
    }
  }

  Either<Failure, List<EventEntity>> _getCachedEvents(String location) {
    try {
      return Right(_local.getCachedEvents(location));
    } on CacheException {
      return Left(CacheFailure('Sin conexión y sin eventos guardados'));
    }
  }
}